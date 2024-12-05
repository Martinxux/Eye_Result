#!/bin/bash
# Version 2.4.1.20240816

echo "██╗  ██╗ ██████╗████████╗     ███████╗██╗  ██╗ ██████╗ ██╗    ██╗"
echo "██║  ██║██╔════╝╚══██╔══╝     ██╔════╝██║  ██║██╔═══██╗██║    ██║"
echo "███████║██║  ███╗  ██║        ███████╗███████║██║   ██║██║ █╗ ██║"
echo "██╔══██║██║   ██║  ██║        ╚════██║██╔══██║██║   ██║██║███╗██║"
echo "██║  ██║╚██████╔╝  ██║███████╗███████║██║  ██║╚██████╔╝╚███╔███╔╝"
echo "╚═╝  ╚═╝ ╚═════╝   ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ "
           
echo "Version: 2.4.1.20240816"                                                       
sleep 1

# 初始化变量
root_dir=""

# 解析命令行参数
while getopts "f:" opt; do
  case $opt in
    f)
      root_dir="$OPTARG" # 从命令行参数中获取父目录路径
      ;;
    \?)
      echo "无效的选项：-$OPTARG" >&2
      exit 1
      ;;
  esac
done

# 如果没有提供 -f 参数，则提示用户输入
if [[ -z "$root_dir" ]]; then
    # 提示用户输入父目录路径
    echo "请输入要搜索的父目录路径："
    read -r root_dir
fi

# 验证用户输入的目录路径是否存在
if [[ ! -d "$root_dir" ]]; then
    echo "指定的目录路径不存在！"
    exit 1
fi

# 获取路径的最后一层作为文件名
filename=$(basename "$root_dir")

# 创建保存结果的 CSV 文件 all_result.csv
result_file="$filename.csv"
> "$result_file"  # 清空文件内容，如果文件存在的话

# 遍历所有子文件夹
find "$root_dir" -type d | sort | while read -r folder_name; do
    # 跳过根目录
    if [[ "$folder_name" == "$root_dir" ]]; then
        continue
    fi

    # 打印文件夹名称到终端和结果文件
    echo "文件夹: $folder_name"
    echo "$folder_name" >> "$result_file"
    
    # 写入 CSV 文件的标题行
    echo "LaneNum,Width(UI),Height(Units),Area(Units),fom" >> "$result_file"
    echo "lane,width,height,area,fom"  # 打印标题行到终端

    # 标志变量，检查是否找到测试文件
    found_results_in_folder=false
    
    # 遍历子文件夹中的txt文件
    for file in "$folder_name"/*.txt; do
        if [[ -f "$file" && ( $(basename "$file") =~ ^(Grp[0-9]Macro[0-9]Lane[0-9]\.txt$)]]; then
            # 提取文件名中的lane名
            lane=$(basename "$file" | cut -d. -f1)

            # 读取文件内容
            data=$(cat "$file")

            # 进行正则匹配
            width_pattern="max width: ([0-9]+) units, ([0-9]+\.[0-9]+) UI"
            height_units_pattern="max height: ([0-9]+) units"
            height_mv_pattern="max height: ([0-9]+) units, ([0-9]+\.[0-9]+) mv"
            area_pattern="area: ([0-9]+) units"
            fom_pattern="fom ([0-9]+)"

            # 初始化变量
            width=""
            height=""
            area=""
            fom=""

            # 进行正则匹配
            if [[ $data =~ $width_pattern ]]; then
                width=${BASH_REMATCH[2]}
            fi

            if [[ $data =~ $height_mv_pattern ]]; then
                height=${BASH_REMATCH[2]}
            fi

            if [[ $data =~ $area_pattern ]]; then
                area=${BASH_REMATCH[1]}
            fi

            if [[ $data =~ $fom_pattern ]]; then
                fom=${BASH_REMATCH[1]}
            fi

            # 打印并保存结果到 CSV 文件
            result_line="$lane,$width,$height,$area,$fom"
            echo "$result_line" >> "$result_file"
            echo "$result_line"  # 打印结果到终端
            
            # 标志变量，检查是否找到测试文件
            found_results_in_folder=true
        fi
    done
    
    # 添加空行以分隔不同文件夹的数据段落
    if [ "$found_results_in_folder" = true ]; then
        echo >> "$result_file"
        echo  # 打印空行到终端
    fi

done

# 完成后的提示信息
echo "脚本已完成，在以下路径生成了结果文件：$result_file"