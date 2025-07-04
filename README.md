# Eye Diagram Analysis Tool

## 1. 项目简介

`eye_result.sh` 是一个用于分析眼图(Eye Diagram)测试结果的Bash脚本工具，主要功能包括：

- 分析PCIe Gen4/Gen5眼图测试数据
- 支持三种预设规格配置和自定义规格
- 检查眼宽(Width)、眼高(Height)、眼域(Area)和FOM指标
- 生成彩色终端输出和CSV格式报告
- 自动识别最小值并给出通过/失败判断

### 支持环境

| 信息 | 适用范围 |
|------|----------|
| OS   | Redhat/Centos/NFS/Ubuntu |
| BIOS | A/S |
| 平台 | Hygon/8501 |

## 2. 使用教程

### 2.1 安装与权限

**方法一：使用bash直接运行（无需权限）**
```bash
bash eye_result.sh
```

**方法二：赋予执行权限后运行**
```bash
chmod +x eye_result.sh
./eye_result.sh
```

### 2.2 规格配置

运行脚本后，系统会提示选择规格配置：

1. **HG4_PCIe Gen5**: Width=0.51 UI, Height=50 units
2. **HG3_PCIe Gen4**: Width=0.61 UI, Height=58 units 
3. **TIANQIN_PCIe Gen5**: Width=0.50 UI, Height=65 mv, FOM=200
4. **自定义**: 手动输入各项指标

## 3. 输出说明

### 3.1 终端输出

脚本会在终端显示彩色表格，包含以下信息：

- 每个Lane的眼宽、眼高、眼域和FOM值
- 不符合规格的值会显示为红色
- 每个文件夹的最小值汇总
- 全局最小值及其位置
- 最终通过/失败判断

### 3.2 CSV报告

脚本会在当前目录生成 `<目录名>.csv` 文件，包含:

- 每个Lane的详细测试数据
- 每个测试集的最小值
- 便于后续分析和存档

## 4. 结果解读

- **PASS**: 所有测试值均满足规格要求
- **FAIL**: 至少有一个测试值不满足规格要求
- **最小值位置**: 显示全局最小眼宽和眼高的具体位置

## 5. Release Notes

### v2.8.0.20250109
- ✨ 新增: 支持三种预设规格配置
- 🐛 修复: 规格判断逻辑优化
- 💄 优化: 终端输出格式改进

### v2.7.2.20250108
- 🐛 修复: 空规格判断问题
- 🐛 修复: 天琴日志匹配问题

### v2.7.1.2024.12.18
- ✨ 新增: 规格判断功能
- 💄 优化: 终端可读性提升

[...历史版本详情请查看完整ReleaseNote...]

## 6. 注意事项

1. 确保测试结果目录结构正确
2. 自定义规格时，留空的指标将不会被检查
3. CSV报告文件名基于输入目录名自动生成
4. 详细日志记录在 `unmatched_files.log` 中