####
# @Author                : Martinxux<wave.martin@qq.com>
# @CreatedDate           : 2024-12-07 10:57:09
# @LastEditors           : Martinxux<wave.martin@qq.com>
# @LastEditDate          : 2024-12-07 10:57:09
# @FilePath              : eye_result.sh
# 
####



#!/bin/bash
# Version 2.6.1.20241207
echo

echo "███████╗██╗   ██╗███████╗        ██████╗ ███████╗███████╗██╗   ██╗██╗  ████████╗"
echo "██╔════╝╚██╗ ██╔╝██╔════╝        ██╔══██╗██╔════╝██╔════╝██║   ██║██║  ╚══██╔══╝"
echo "█████╗   ╚████╔╝ █████╗          ██████╔╝█████╗  ███████╗██║   ██║██║     ██║   "
echo "██╔══╝    ╚██╔╝  ██╔══╝          ██╔══██╗██╔══╝  ╚════██║██║   ██║██║     ██║   "
echo "███████╗   ██║   ███████╗███████╗██║  ██║███████╗███████║╚██████╔╝███████╗██║   "
echo "╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚═╝   "
           
echo "Version: v2.6.1.20241207"   
echo                                                    
sleep 1

root_dir=""

# 检查是否提供了目录路径作为脚本的第一个参数
if [ $# -eq 0 ]; then
    echo "请提供一个目录路径作为参数"
	echo
	echo "示例 bash eye_result.sh Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5"
	echo
	echo "或 ./eye_result.sh Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5 （先赋权限给脚本文件）"
    exit 1
fi

root_dir=$1

# 验证输入路径
while [ ! -d "$root_dir" ]; do
    echo "指定的目录路径不存在"
    exit 1
done

# 获取路径的最后一层作为文件名
filename=$(basename "$root_dir")
result_file="./${filename}.csv"

# 清空 CSV 文件内容
> "$result_file"

# 初始化全局最小值变量
global_min_width=999999
global_min_lane=""
global_min_folder=""

# 创建临时文件来存储最小值
temp_file=$(mktemp)

# 遍历所有子文件夹
find "$root_dir" -type d | sort | while read -r folder_name; do
    if [ "$folder_name" = "$root_dir" ]; then
        continue
    fi

    echo "folder: $folder_name"
    echo "$folder_name" >> "$result_file"

    # 初始化表头标识
    header_written=false

    # 初始化最小值变量
    min_width=999999
    min_height=999999
    min_area=999999
    min_fom=999999
    found_results_in_folder=false

    for file in "$folder_name"/*.txt; do
        if [ -f "$file" ]; then
            # 确定表头和高度单位
            if echo "$(basename "$file")" | grep -qE "^(S[0-9])?D[0-9]T[0-9]P[0-9]L[0-9]\.txt$"; then
                height_label="Height(Units)"
            elif echo "$(basename "$file")" | grep -qE "^Grp[0-9]Macro[0-9]Lane[0-9]\.txt$"; then
                height_label="Height(mv)"
            else
                continue
            fi

            # 写入表头
            if [ "$header_written" = false ]; then
                echo "LaneNum,Width(UI),$height_label,Area(Units),fom" >> "$result_file"
                echo "LaneNum,Width(UI),$height_label,Area(Units),fom"
                header_written=true
            fi

            lane=$(basename "$file" | cut -d. -f1)
            data=$(cat "$file")

            width=""
            height=""
            area=""
            fom=""

            # 提取各项值
            if echo "$data" | grep -q "max width"; then
                width=$(echo "$data" | grep -oP "max width: [0-9]+ units, \K[0-9]+\.[0-9]+")
            fi
            if echo "$data" | grep -q "max height"; then
                if [ "$height_label" = "Height(mv)" ]; then
                    height=$(echo "$data" | grep -oP "max height: [0-9]+ units, \K[0-9]+\.[0-9]+")
                else
                    height=$(echo "$data" | grep -oP "max height: \K[0-9]+")
                fi
            fi
            if echo "$data" | grep -q "area:"; then
                area=$(echo "$data" | grep -oP "area: \K[0-9]+")
            fi
            if echo "$data" | grep -q "fom"; then
                fom=$(echo "$data" | grep -oP "fom \K[0-9]+")
            fi

            # 更新文件夹的最小值
            if [ -n "$width" ] && [ "$(echo "$width < $min_width" | bc -l)" -eq 1 ]; then
                min_width=$width
            fi
            if [ -n "$height" ]; then
                if [ "$(echo "$height < $min_height" | bc -l)" -eq 1 ]; then
                    min_height=$height
                fi
            fi
            if [ -n "$area" ] && [ "$area" -lt "$min_area" ]; then
                min_area=$area
            fi
            if [ -n "$fom" ] && [ "$fom" -lt "$min_fom" ]; then
                min_fom=$fom
            fi

            # 更新全局最小值到临时文件（添加文件夹信息）
            if [ -n "$width" ]; then
                echo "$width $lane $(basename "$folder_name")" >> "$temp_file"
            fi

            # 输出并保存当前文件的结果
            result_line="$lane,$width,$height,$area,$fom"
            echo "$result_line" >> "$result_file"
            echo "$result_line"
            found_results_in_folder=true
        fi
    done

    if [ "$found_results_in_folder" = true ]; then
        # 将文件夹最小值写入 CSV
        min_result_line="MinValues,$min_width,$min_height,$min_area,$min_fom"
        echo "$min_result_line" >> "$result_file"
        echo "$min_result_line"
        echo >> "$result_file"
        echo
    else
        echo "没有找到数据" >> "$result_file"
        echo "没有找到数据"
    fi
done

# 从临时文件中读取并计算全局最小值
if [ -f "$temp_file" ] && [ -s "$temp_file" ]; then
    # 读取最小值记录（包含width、lane和文件夹信息）
    read global_min_width global_min_lane global_min_folder <<< "$(sort -g "$temp_file" | head -n1)"
    echo "所有文件中最小眼宽 Width(UI) 是 $global_min_width UI，位于文件夹 $global_min_folder 的 Lane $global_min_lane"
else
    echo "未找到任何有效的最小 Width 数据"
fi

# 清理临时文件
rm -f "$temp_file"