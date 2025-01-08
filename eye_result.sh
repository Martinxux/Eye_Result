####
# @Author                : Martinxux<wave.martin@qq.com>
# @CreatedDate           : 2024-12-07 10:57:09
# @LastEditors           : Martinxux<wave.martin@qq.com>
# @LastEditDate          : 2024-12-07 10:57:09
# @FilePath              : eye_result.sh
# 
####



#!/bin/bash
# Version 2.7.2.20250108
echo

echo "███████╗██╗   ██╗███████╗        ██████╗ ███████╗███████╗██╗   ██╗██╗  ████████╗"
echo "██╔════╝╚██╗ ██╔╝██╔════╝        ██╔══██╗██╔════╝██╔════╝██║   ██║██║  ╚══██╔══╝"
echo "█████╗   ╚████╔╝ █████╗          ██████╔╝█████╗  ███████╗██║   ██║██║     ██║   "
echo "██╔══╝    ╚██╔╝  ██╔══╝          ██╔══██╗██╔══╝  ╚════██║██║   ██║██║     ██║   "
echo "███████╗   ██║   ███████╗███████╗██║  ██║███████╗███████║╚██████╔╝███████╗██║   "
echo "╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚═╝   "
           
echo "Version: v2.7.2.20250108"   
echo                                                    
sleep 1

# 定义颜色
RED='\033[0;31m' # 红色
GREEN='\033[0;32m' # 绿色
NC='\033[0m' # 恢复默认颜色

# 清除 unmatched_files.log 文件内容
> unmatched_files.log

# 初始化Spec值
WIDTH_SPEC=""
HEIGHT_SPEC=""
AREA_SPEC=""
FOM_SPEC=""

# 交互式输入Spec
input_specs() {
    echo "请输入各项指标Spec:"
    read -p "眼宽 Width(UI) Spec(若无直接回车跳过): " WIDTH_SPEC
    read -p "眼高 Height(mv/units) Spec(若无直接回车跳过): " HEIGHT_SPEC
    read -p "眼域 Area(units) Spec (若无直接回车跳过): " AREA_SPEC
    read -p "FOM Spec (若无直接回车跳过): " FOM_SPEC
}

# 判断是否通过规格
check_spec() {
    local value=$1
    local spec=$2
    
    # 如果value或spec为空，视为通过
    if [ -z "$value" ] || [ -z "$spec" ]; then
        echo ""
        return
    fi
    
    # 使用 bc 进行浮点数比较
    if (( $(echo "$value >= $spec" | bc -l) )); then
        echo ""
    else
        echo "1"
    fi
}

# 带颜色输出的包装函数（仅终端）
color_output() {
    local value=$1
    local spec=$2
    
    # 检查是否需要高亮
    local highlight=$(check_spec "$value" "$spec")
    
    if [ -n "$highlight" ]; then
        echo -e "${RED}$value${NC}"
    else
        echo "$value"
    fi
}

# 纯文本输出函数（用于CSV）
plain_output() {
    local value=$1
    echo "$value"
}

# 打印表头函数
print_table_header() {
    printf "%-18s %-12s %-18s %-12s %-6s\n" "LaneNum" "Width(UI)" "$height_label" "Area" "FOM"
    printf "%-18s %-12s %-18s %-12s %-6s\n" "--------" "---------" "-------------" "-----" "----"
}

# 打印数据行函数
print_table_row() {
    local lane=$1
    local width=$2
    local height=$3
    local area=$4
    local fom=$5

    # 去除颜色控制字符计算实际长度
    local width_stripped=$(echo "$(color_output "$width" "$WIDTH_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local height_stripped=$(echo "$(color_output "$height" "$HEIGHT_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local area_stripped=$(echo "$(color_output "$area" "$AREA_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local fom_stripped=$(echo "$(color_output "$fom" "$FOM_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")

    # 计算需要填充的空格数量
    local width_padding=$((16 - ${#width_stripped}))
    local height_padding=$((14 - ${#height_stripped}))
    local area_padding=$((12 - ${#area_stripped}))
    local fom_padding=$((8 - ${#fom_stripped}))

    # 打印带颜色的行数据，并添加空格进行填充
    printf "%-18s %-16s %-14s %-11s %-8s\n" "$lane" \
        "$(color_output "$width" "$WIDTH_SPEC")$(printf "%*s" "$width_padding" " ")" \
        "$(color_output "$height" "$HEIGHT_SPEC")$(printf "%*s" "$height_padding" " ")" \
        "$(color_output "$area" "$AREA_SPEC")$(printf "%*s" "$area_padding" " ")" \
        "$(color_output "$fom" "$FOM_SPEC")$(printf "%*s" "$fom_padding" " ")"
}

# 打印最小值行函数
print_min_values_row() {
    local min_width=$1
    local min_height=$2
    local min_area=$3
    local min_fom=$4

    # 去除颜色控制字符计算实际长度
    local min_width_stripped=$(echo "$(color_output "$min_width" "$WIDTH_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local min_height_stripped=$(echo "$(color_output "$min_height" "$HEIGHT_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local min_area_stripped=$(echo "$(color_output "$min_area" "$AREA_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    local min_fom_stripped=$(echo "$(color_output "$min_fom" "$FOM_SPEC")" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")

    # 计算需要填充的空格数量
    local min_width_padding=$((16 - ${#min_width_stripped}))
    local min_height_padding=$((14 - ${#min_height_stripped}))
    local min_area_padding=$((12 - ${#min_area_stripped}))
    local min_fom_padding=$((8 - ${#min_fom_stripped}))

    # 打印带颜色的最小值行数据，并添加空格进行填充
    printf "%-18s %-16s %-14s %-11s %-8s\n" "MinValues" \
        "$(color_output "$min_width" "$WIDTH_SPEC")$(printf "%*s" "$min_width_padding" " ")" \
        "$(color_output "$min_height" "$HEIGHT_SPEC")$(printf "%*s" "$min_height_padding" " ")" \
        "$(color_output "$min_area" "$AREA_SPEC")$(printf "%*s" "$min_area_padding" " ")" \
        "$(color_output "$min_fom" "$FOM_SPEC")$(printf "%*s" "$min_fom_padding" " ")"
}

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

# 调用输入规格函数
input_specs

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
temp_width_file=$(mktemp)
temp_height_file=$(mktemp)

# 遍历所有子文件夹
find "$root_dir" -type d | sort | while read -r folder_name; do
    if [ "$folder_name" = "$root_dir" ]; then
        continue
    fi
    
    echo "------------------------------------------------------------------------"
    echo
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
            elif echo "$(basename "$file")" | grep -qE "^Grp[0-9]Macro[0-9]Lane[0-9](-[0-9]+)?\.txt$"; then
                height_label="Height(mv)"
            else
                echo "未匹配的文件: $file" >> unmatched_files.log
                continue
            fi

            # 写入表头到终端
            if [ "$header_written" = false ]; then
				echo "LaneNum,Width(UI),$height_label,Area(Units),fom" >> "$result_file"
                print_table_header
                header_written=true
            fi

            lane=$(basename "$file" | sed 's/-[0-9]\{14\}\.txt$//; s/\.txt$//')
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
                echo "$width $lane $(basename "$folder_name")" >> "$temp_width_file"
            fi
            if [ -n "$height" ]; then
                echo "$height $lane $(basename "$folder_name")" >> "$temp_height_file"
            fi

            # 打印当前文件的行数据到终端
            print_table_row "$lane" "$width" "$height" "$area" "$fom"

            # 输出并保存当前文件的结果到CSV
            width_csv=$(plain_output "$width")
            height_csv=$(plain_output "$height")
            area_csv=$(plain_output "$area")
            fom_csv=$(plain_output "$fom")

            result_line_csv="$lane,$width_csv,$height_csv,$area_csv,$fom_csv"
            echo "$result_line_csv" >> "$result_file"
            found_results_in_folder=true
        fi
    done

    if [ "$found_results_in_folder" = true ]; then
        # 打印文件夹的最小值行到终端
        print_min_values_row "$min_width" "$min_height" "$min_area" "$min_fom"

        min_width_csv=$(plain_output "$min_width")
        min_height_csv=$(plain_output "$min_height")
        min_area_csv=$(plain_output "$min_area")
        min_fom_csv=$(plain_output "$min_fom")

        min_result_line_csv="MinValues,$min_width_csv,$min_height_csv,$min_area_csv,$min_fom_csv"
        echo "$min_result_line_csv" >> "$result_file"
        echo >> "$result_file"
        echo
    else
        echo "没有找到数据" >> "$result_file"
        echo "没有找到数据"
    fi
done

# 从临时文件中读取并计算全局最小 width
if [ -f "$temp_width_file" ] && [ -s "$temp_width_file" ]; then
    # 读取最小值记录（包含width、lane和文件夹信息）
    read global_min_width global_min_lane global_min_folder <<< "$(sort -g "$temp_width_file" | head -n1)"
	echo "自定义Spec为："
	echo "眼宽(UI)："$WIDTH_SPEC
	echo "眼高(mv/unints)："$HEIGHT_SPEC
	echo "眼域(units)："$AREA_SPEC
	echo "FOM："$FOM_SPEC
	echo
    echo "所有文件中最小眼宽 Width(UI) 是 $global_min_width UI，位于文件夹 $global_min_folder 的 Lane $global_min_lane"
	echo
else
    echo "未找到任何有效的最小 Width 数据"
fi

# 从临时文件中读取并计算全局最小 Height
if [ -f "$temp_height_file" ] && [ -s "$temp_height_file" ]; then
    read global_min_height global_min_height_lane global_min_height_folder <<< "$(sort -g "$temp_height_file" | head -n1)"
    echo "所有文件中最小眼高 Height(mv/unints) 是 $global_min_height，位于文件夹 $global_min_height_folder 的 Lane $global_min_height_lane"
    echo
else
    echo "未找到任何有效的最小 Height 数据"
fi


# 判断全局最小宽度是否满足规格
# 初始化判断结果
width_pass=true
height_pass=true

# 检查 Width 是否符合规格
if [ -n "$WIDTH_SPEC" ]; then
    if [ "$(echo "$global_min_width >= $WIDTH_SPEC" | bc -l)" -ne 1 ]; then
        width_pass=false
    fi
fi

# 检查 Height 是否符合规格
if [ -n "$HEIGHT_SPEC" ]; then
    if [ "$(echo "$global_min_height >= $HEIGHT_SPEC" | bc -l)" -ne 1 ]; then
        height_pass=false
    fi
fi
# 综合判断
if $width_pass && $height_pass; then
	echo -e "${GREEN}██████╗  █████╗ ███████╗███████╗${NC}"
	echo -e "${GREEN}██╔══██╗██╔══██╗██╔════╝██╔════╝${NC}"
	echo -e "${GREEN}██████╔╝███████║███████╗███████╗${NC}"
	echo -e "${GREEN}██╔═══╝ ██╔══██║╚════██║╚════██║${NC}"
	echo -e "${GREEN}██║     ██║  ██║███████║███████║${NC}"
	echo -e "${GREEN}╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝${NC}"
else
	echo -e "${RED}███████╗ █████╗ ██╗██╗${NC}"
	echo -e "${RED}██╔════╝██╔══██╗██║██║${NC}"
	echo -e "${RED}█████╗  ███████║██║██║${NC}"
	echo -e "${RED}██╔══╝  ██╔══██║██║██║${NC}"
	echo -e "${RED}██║     ██║  ██║██║███████╗${NC}"
	echo -e "${RED}╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝${NC}"
fi

# 清理临时文件
rm -f "$temp_width_file"
rm -f "$temp_height_file"