## 1  简介

脚本支持：

| 信息 |     适用范围      |
| :--- | :---------------: |
| OS   | Redhat/Centos/NFS/Ubuntu |
| BIOS |        A/S        |
| 平台 |       Hygon/8501       |

- 使用 Bash 编写
- 支持测试完成后快捷查看测试结果
- 支持PCIe 4 & PCIe 5 Margin
- 支持将结果导出到csv文件

## 2 使用教程

### 2.1 执行权限

**执行以下命令赋权限**

`chmod 777 -R *` ，其中 * 是文件名。本工具执行 `chmod 777 -R eye_result.sh` 即可

### 2.2 执行命令

运行指令 `./eye_result.sh [待分析文件夹路径]` 

**也可使用 bash 解释器执行脚本，不需要赋权限**

使用 bash 解释器运行 `bash eye_result.sh Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5`

运行 `./eye_result.sh` 即可，输入待分析的文件夹名称相对路径绝对路径都可

运行 `./eye_result.sh [待分析文件夹路径]` 也可

**也可使用 sh 解释器执行脚本，不需要赋权限**

使用 sh 解释器运行 `bash eye_result.sh Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5`
## 3. 结果查看

运行完成后可在目录下找到 *all_result.txt* 文件，内容如下所示：

```log
folder: Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5-auto/default-eye
LaneNum,Width(UI),Height(Units),Area(Units),fom
S0D0T5P0L0,0.70,90,1430,253
S0D0T5P0L1,0.56,81,1024,240
S0D0T5P0L2,0.68,68,1086,238
S0D0T5P0L3,0.65,66,1039,234
S0D0T5P1L0,0.62,82,1182,243
S0D0T5P1L1,0.68,73,1235,241
S0D0T5P1L2,0.68,96,1488,252
S0D0T5P1L3,0.65,85,1305,244
S0D0T5P2L0,0.68,78,1178,238
S0D0T5P2L1,0.65,75,1121,250
S0D0T5P2L2,0.59,102,1334,236
S0D0T5P2L3,0.65,100,1466,255
S0D0T5P3L0,0.68,96,1449,254
S0D0T5P3L1,0.68,69,1061,242
S0D0T5P3L2,0.62,86,1220,237
S0D0T5P3L3,0.54,94,1154,240
MinValues,0.54,66,1024,234

folder: Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5-auto/default-eye-1
LaneNum,Width(UI),Height(Units),Area(Units),fom
S0D0T5P0L0,0.70,88,1331,250
S0D0T5P0L1,0.56,82,1050,242
S0D0T5P0L2,0.68,66,1063,237
S0D0T5P0L3,0.59,84,1159,236
S0D0T5P1L0,0.62,77,1109,244
S0D0T5P1L1,0.70,76,1261,241
S0D0T5P1L2,0.70,85,1426,248
S0D0T5P1L3,0.68,83,1276,242
S0D0T5P2L0,0.56,89,1129,239
S0D0T5P2L1,0.56,89,1079,248
S0D0T5P2L2,0.62,98,1257,238
S0D0T5P2L3,0.65,98,1378,255
S0D0T5P3L0,0.70,97,1491,255
S0D0T5P3L1,0.59,84,1087,243
S0D0T5P3L2,0.59,82,1094,233
S0D0T5P3L3,0.65,70,1097,239
MinValues,0.56,66,1050,233

folder: Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5-auto/default-eye-2
LaneNum,Width(UI),Height(Units),Area(Units),fom
S0D0T5P0L0,0.70,86,1392,253
S0D0T5P0L1,0.56,79,1027,239
S0D0T5P0L2,0.65,67,1044,239
S0D0T5P0L3,0.62,79,1092,234
S0D0T5P1L0,0.65,81,1184,244
S0D0T5P1L1,0.70,75,1251,243
S0D0T5P1L2,0.68,94,1460,249
S0D0T5P1L3,0.65,83,1251,243
S0D0T5P2L0,0.68,74,1188,238
S0D0T5P2L1,0.68,79,1195,253
S0D0T5P2L2,0.59,100,1298,235
S0D0T5P2L3,0.65,98,1381,255
S0D0T5P3L0,0.68,99,1453,254
S0D0T5P3L1,0.59,85,1134,245
S0D0T5P3L2,0.65,63,945,234
S0D0T5P3L3,0.56,94,1213,242
MinValues,0.56,63,945,234

folder: Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5-auto/default-eye-3
LaneNum,Width(UI),Height(Units),Area(Units),fom
S0D0T5P0L0,0.65,99,1299,254
S0D0T5P0L1,0.56,81,1028,242
S0D0T5P0L2,0.59,86,1153,233
S0D0T5P0L3,0.62,79,1099,236
S0D0T5P1L0,0.62,79,1176,241
S0D0T5P1L1,0.59,94,1325,240
S0D0T5P1L2,0.70,83,1417,247
S0D0T5P1L3,0.65,85,1286,244
S0D0T5P2L0,0.56,86,1104,239
S0D0T5P2L1,0.68,73,1116,245
S0D0T5P2L2,0.62,100,1340,235
S0D0T5P2L3,0.65,97,1460,255
S0D0T5P3L0,0.68,97,1436,255
S0D0T5P3L1,0.62,85,1096,245
S0D0T5P3L2,0.65,65,973,238
S0D0T5P3L3,0.56,95,1166,239
MinValues,0.56,65,973,233

folder: Bridge-48_03.07-Deivce-0xa2dc15b3-GEN5-auto/default-eye-4
LaneNum,Width(UI),Height(Units),Area(Units),fom
S0D0T5P0L0,0.73,85,1406,254
S0D0T5P0L1,0.56,83,1050,241
S0D0T5P0L2,0.68,66,1080,236
S0D0T5P0L3,0.62,78,1022,237
S0D0T5P1L0,0.65,78,1155,242
S0D0T5P1L1,0.70,77,1309,236
S0D0T5P1L2,0.73,83,1467,248
S0D0T5P1L3,0.65,89,1386,246
S0D0T5P2L0,0.68,74,1127,237
S0D0T5P2L1,0.65,78,1174,253
S0D0T5P2L2,0.68,69,1066,234
S0D0T5P2L3,0.65,96,1382,255
S0D0T5P3L0,0.65,93,1406,255
S0D0T5P3L1,0.62,83,1101,245
S0D0T5P3L2,0.56,83,1073,234
S0D0T5P3L3,0.65,76,1174,241
MinValues,0.56,66,1022,234

所有文件中最小眼宽 Width(UI) 是 0.54 UI，位于文件夹 default-eye 的 Lane S0D0T5P3L3
```


## ReleaseNote
##### v2.6.1.2024.12.07

✨Feat: 
- 增加天琴眼图数据分析
- 8501&HG 眼高单位区分
- 8501&HG 最小值打印并保存到 csv
- 最小眼宽匹配对应文件夹和 Lane 打印到终端

🐛Fix: 修复HG数据提取也变成 mv 的 BUG

🔥Del: 删除重复的代码文件

📝Docs: README 修改

##### v2.4.1.2024.08.16

- ✨Feat: 增加 `-f` 参数

💄Style: 代码重构、优化 re

##### v2.3.1.2023.07.31

✨Feat: 

- 生产文件更改为CSV，更加方便查看
- 可选路径

🎨Refactor: 代码重构

##### v1.2.1.2024.01.12

🐛Fix: 修改Gen5的眼高抓取为按Units抓取

##### v1.2.0.2023.08.19

✨Feat: 

- 没有搜索到时显示cannot find test files

- txt中去除-----，方便在excel中分割
- 在txt中不显示无结果的文件夹

##### v1.1.0.2023.08.18

✨Feat: 

- 表格形式展现
- 输出txt

🎨Refactor: 增加HGT_SHOW标识

##### v1.0.0.2023.08.18

🎉Init: 初始化提交

📝Docs: README撰写