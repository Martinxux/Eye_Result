####
# @Author                : Martinxux<wave.martin@qq.com>
# @CreatedDate           : 2024-12-05 20:29:42
# @LastEditors           : Martinxux<wave.martin@qq.com>
# @LastEditDate          : 2024-12-05 20:29:43
# @FilePath              : show_result_v2.4.1.sh
# 
####


#!/bin/bash
# Version 2.5.0.20241205

echo "██╗  ██╗ ██████╗████████╗     ███████╗██╗  ██╗ ██████╗ ██╗    ██╗"
echo "██║  ██║██╔════╝╚══██╔══╝     ██╔════╝██║  ██║██╔═══██╗██║    ██║"
echo "███████║██║  ███╗  ██║        ███████╗███████║██║   ██║██║ █╗ ██║"
echo "██╔══██║██║   ██║  ██║        ╚════██║██╔══██║██║   ██║██║███╗██║"
echo "██║  ██║╚██████╔╝  ██║███████╗███████║██║  ██║╚██████╔╝╚███╔███╔╝"
echo "╚═╝  ╚═╝ ╚═════╝   ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ "
           
echo "Version: 2.5.0.20241205"                                                       
sleep 1

root_dir=""

# 解析命令行参数
while getopts "f:" opt; do
  case $opt in
    f)
      root_dir="$OPTARG"
      ;;
    \?)
      echo "无效的选项：-$OPTARG" >&2
      exit 1
      ;;
  esac
done

# 如果没有提供 -f 参数，则提示用户输入
if [ -z "$root_dir" ]; then
    echo "请输入要搜索的父目录路径："
    read -r root_dir
fi

# 验证输入路径
while [ ! -d "$root_dir" ]; do
    echo "指定的目录路径不存在，请重新输入："
    read -r root_dir
done

# 获取路径的最后一层作为文件名
filename=$(basename "$root_dir")
result_file="./${filename}.csv"

# 清空 CSV 文件内容
> "$result_file"

# 初始化全局最小值变量
global_min_width=999999
global_min_lane=""

# 创建临时文件来存储最小值
temp_file=$(mktemp)

# 遍历所有子文件夹
find "$root_dir" -type d | sort | while read -r folder_name; do
    if [ "$folder_name" = "$root_dir" ]; then
        continue
    fi

    echo "folder: $folder_name"
    echo "$folder_name" >> "$result_file"
    echo "LaneNum,Width(UI),Height(Units),Area(Units),fom" >> "$result_file"
    echo "LaneNum,Width(UI),Height(Units),Area(Units),fom"

    # 初始化最小值变量
    min_width=999999
    min_height=999999
    min_area=999999
    min_fom=999999
    found_results_in_folder=false

    for file in "$folder_name"/*.txt; do
        if [ -f "$file" ]; then
            if echo "$(basename "$file")" | grep -qE "^(S[0-9])?D[0-9]T[0-9]P[0-9]L[0-9]\.txt$"; then
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
                    height=$(echo "$data" | grep -oP "max height: \K[0-9]+")
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
                if [ -n "$height" ] && [ "$height" -lt "$min_height" ]; then
                    min_height=$height
                fi
                if [ -n "$area" ] && [ "$area" -lt "$min_area" ]; then
                    min_area=$area
                fi
                if [ -n "$fom" ] && [ "$fom" -lt "$min_fom" ]; then
                    min_fom=$fom
                fi

                # 更新全局最小值到临时文件
                if [ -n "$width" ]; then
                    echo "$width $lane" >> "$temp_file"
                fi

                # 输出并保存当前文件的结果
                result_line="$lane,$width,$height,$area,$fom"
                echo "$result_line" >> "$result_file"
                echo "$result_line"
                found_results_in_folder=true
            fi
        fi
    done

    if [ "$found_results_in_folder" = true ]; then
        # 将文件夹最小值写入 CSV
        min_result_line="MinValues,$min_width,$min_height,$min_area,$min_fom"
        echo "$min_result_line" >> "$result_file"
        echo "$min_result_line"
        echo >> "$result_file"
    else
        echo "没有找到数据" >> "$result_file"
        echo "没有找到数据"
    fi
done

# 从临时文件中读取并计算全局最小值
if [ -f "$temp_file" ] && [ -s "$temp_file" ]; then
    read global_min_width global_min_lane <<< "$(sort -g "$temp_file" | head -n1)"
    echo "所有文件中最小的 Width(UI) 是 $global_min_width，位于 Lane $global_min_lane"
else
    echo "未找到任何有效的 Width 数据"
fi

# 清理临时文件
rm -f "$temp_file"