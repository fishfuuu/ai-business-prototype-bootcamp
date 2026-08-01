
Add-Type -AssemblyName System.Drawing

$assetsDir = "d:\AILearning\docs\assets\lesson-01"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null
}

function Create-Canvas {
    param([int]$width, [int]$height, [System.Drawing.Color]$bgColor)
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.Clear($bgColor)
    return @{ Bitmap = $bmp; Graphics = $g }
}

function Get-Brush {
    param([int]$r, [int]$g, [int]$b)
    return New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($r, $g, $b))
}

# 1. lesson-flow.png
$canvas1 = Create-Canvas 1200 400 ([System.Drawing.Color]::FromArgb(248, 250, 252))
$g1 = $canvas1.Graphics
$bmp1 = $canvas1.Bitmap

$titleFont = New-Object System.Drawing.Font("Microsoft YaHei", 16, [System.Drawing.FontStyle]::Bold)
$stepTitleFont = New-Object System.Drawing.Font("Microsoft YaHei", 12, [System.Drawing.FontStyle]::Bold)
$subFont = New-Object System.Drawing.Font("Microsoft YaHei", 10, [System.Drawing.FontStyle]::Regular)

$g1.DrawString("第一课：自然语言人机协作六步闭环流程", $titleFont, (Get-Brush 30 41 59), 40, 25)

$steps = @(
    @{ Num="01"; Title="说清业务问题"; Sub="描述场景与难点" },
    @{ Num="02"; Title="Claude 提方案"; Sub="复述需求与结构" },
    @{ Num="03"; Title="主管删改确认"; Sub="裁决范围与边界" },
    @{ Num="04"; Title="Claude 生成页面"; Sub="按确认方案修改" },
    @{ Num="05"; Title="主管连续微调"; Sub="自然语言 3 轮优化" },
    @{ Num="06"; Title="验证与保存"; Sub="一键脚本通过" }
)

$cardWidth = 160
$cardHeight = 220
$startX = 40
$startY = 90
$gap = 32

for ($i = 0; $i -lt $steps.Count; $i++) {
    $x = $startX + $i * ($cardWidth + $gap)
    $st = $steps[$i]
    
    $rect = New-Object System.Drawing.Rectangle($x, $startY, $cardWidth, $cardHeight)
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 2)
    
    $g1.FillRectangle($bgBrush, $rect)
    $g1.DrawRectangle($borderPen, $rect)
    
    $headerRect = New-Object System.Drawing.Rectangle($x, $startY, $cardWidth, 40)
    $headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 246, 255))
    $g1.FillRectangle($headerBrush, $headerRect)
    
    $numFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $g1.DrawString("STEP " + $st.Num, $numFont, (Get-Brush 37 99 235), $x + 12, $startY + 10)
    
    $g1.DrawString($st.Title, $stepTitleFont, (Get-Brush 15 23 42), $x + 12, $startY + 60)
    $g1.DrawString($st.Sub, $subFont, (Get-Brush 100 116 139), $x + 12, $startY + 120)
    
    if ($i -lt $steps.Count - 1) {
        $arrowX = $x + $cardWidth + 4
        $arrowY = $startY + ($cardHeight / 2) - 15
        $g1.DrawString("->", $titleFont, (Get-Brush 148 163 184), $arrowX, $arrowY)
    }
}

$bmp1.Save("$assetsDir\lesson-flow.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g1.Dispose()
$bmp1.Dispose()

# 2. page-layout.png
$canvas2 = Create-Canvas 1200 650 ([System.Drawing.Color]::FromArgb(248, 250, 252))
$g2 = $canvas2.Graphics
$bmp2 = $canvas2.Bitmap

$g2.DrawString("标准企业页面骨架结构示意图", $titleFont, (Get-Brush 30 41 59), 40, 25)

$noteFont = New-Object System.Drawing.Font("Microsoft YaHei", 10, [System.Drawing.FontStyle]::Italic)
$g2.DrawString("注：本图为页面结构示意，不要求每个系统同时包含全部模块，请根据实际业务问题灵活取舍。", $noteFont, (Get-Brush 225 29 72), 40, 60)

$containerRect = New-Object System.Drawing.Rectangle(40, 95, 1120, 520)
$g2.FillRectangle([System.Drawing.Brushes]::White, $containerRect)
$g2.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 2)), $containerRect)

$hRect = New-Object System.Drawing.Rectangle(60, 115, 1080, 70)
$g2.FillRectangle((Get-Brush 241 245 249), $hRect)
$g2.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)), $hRect)
$g2.DrawString("【1. 页面说明 / 筛选条件 / 主要操作】  系统名称 / 业务说明 / 时间段与状态条件筛选", $stepTitleFont, (Get-Brush 51 65 85), 80, 138)

for ($k = 0; $k -lt 4; $k++) {
    $kX = 60 + $k * 275
    $kRect = New-Object System.Drawing.Rectangle($kX, 200, 255, 90)
    $g2.FillRectangle((Get-Brush 239 246 255), $kRect)
    $g2.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(191, 219, 254), 1)), $kRect)
    $g2.DrawString("【2. 指标卡片 KpiCard " + ($k+1) + "】", $subFont, (Get-Brush 29 78 216), $kX + 15, $kRect.Y + 20)
    $g2.DrawString("关键数字 + 同比/环比趋势", $subFont, (Get-Brush 100 116 139), $kX + 15, $kRect.Y + 48)
}

$cRect = New-Object System.Drawing.Rectangle(60, 305, 1080, 140)
$g2.FillRectangle((Get-Brush 248 250 252), $cRect)
$g2.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)), $cRect)
$g2.DrawString("【3. 主要图表/业务信息区 SimpleLineChart / SimpleBarChart】", $stepTitleFont, (Get-Brush 30 41 59), 80, 335)
$g2.DrawString("用于展示核心业务趋势波动、渠道对比或构成占比", $subFont, (Get-Brush 100 116 139), 80, 375)

$tRect = New-Object System.Drawing.Rectangle(60, 460, 1080, 135)
$g2.FillRectangle((Get-Brush 241 245 249), $tRect)
$g2.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)), $tRect)
$g2.DrawString("【4. 明细数据表格区 DataTable & 操作入口】", $stepTitleFont, (Get-Brush 30 41 59), 80, 485)
$g2.DrawString("列出需要人工跟进的列项、状态标签 (StatusTag) 及右侧【处理/跟进】操作按钮", $subFont, (Get-Brush 100 116 139), 80, 525)

$bmp2.Save("$assetsDir\page-layout.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g2.Dispose()
$bmp2.Dispose()

# 3. component-map.png
$canvas3 = Create-Canvas 1200 600 ([System.Drawing.Color]::FromArgb(248, 250, 252))
$g3 = $canvas3.Graphics
$bmp3 = $canvas3.Bitmap

$g3.DrawString("通用组件用途速查表", $titleFont, (Get-Brush 30 41 59), 40, 25)

$comps = @(
    @{ Name="KpiCard"; Sub="核心指标卡片"; Desc="突出显示关键数值、变化趋势及状态标记" },
    @{ Name="FilterPanel"; Sub="筛选面板区"; Desc="提供时间范围、渠道、部门等多维度条件过滤" },
    @{ Name="StatusTag"; Sub="状态标签"; Desc="区分正常/预警/严重等业务状态色块" },
    @{ Name="DataTable"; Sub="数据明细表格"; Desc="支持分页、排序、状态及右侧操作按钮" },
    @{ Name="SimpleLineChart"; Sub="折线图组件"; Desc="展现连续时间段内的业务指标趋势波动" },
    @{ Name="SimpleBarChart"; Sub="柱状图组件"; Desc="用于不同渠道、商品或团队之间的横向对比" },
    @{ Name="SimplePieChart"; Sub="饼图/环形图"; Desc="清晰展示占比构成（如各渠道销售额占比）" }
)

$compWidth = 350
$compHeight = 110
$cStartX = 40
$cStartY = 80
$cGapX = 35
$cGapY = 25

for ($i = 0; $i -lt $comps.Count; $i++) {
    $row = [Math]::Floor($i / 3)
    $col = $i % 3
    $cx = $cStartX + $col * ($compWidth + $cGapX)
    $cy = $cStartY + $row * ($compHeight + $cGapY)
    
    $cp = $comps[$i]
    
    $cRect = New-Object System.Drawing.Rectangle($cx, $cy, $compWidth, $compHeight)
    $g3.FillRectangle([System.Drawing.Brushes]::White, $cRect)
    $g3.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 1)), $cRect)
    
    $barRect = New-Object System.Drawing.Rectangle($cx, $cy, 6, $compHeight)
    $g3.FillRectangle((Get-Brush 37 99 235), $barRect)
    
    $g3.DrawString($cp.Name, $stepTitleFont, (Get-Brush 30 41 59), $cx + 18, $cy + 15)
    $g3.DrawString("（" + $cp.Sub + "）", $subFont, (Get-Brush 37 99 235), $cx + 18 + ($cp.Name.Length * 12), $cy + 17)
    $g3.DrawString($cp.Desc, $subFont, (Get-Brush 100 116 139), $cx + 18, $cy + 55)
}

$bmp3.Save("$assetsDir\component-map.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g3.Dispose()
$bmp3.Dispose()

# 4. first-cohort-example.png
$canvas4 = Create-Canvas 1200 700 ([System.Drawing.Color]::FromArgb(248, 250, 252))
$g4 = $canvas4.Graphics
$bmp4 = $canvas4.Bitmap

$g4.DrawString("根据首期学员成果整理的结构示意图", $titleFont, (Get-Brush 30 41 59), 40, 25)

$warnBoxPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(251, 191, 36), 2)
$warnBoxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(254, 243, 199))
$g4.FillRectangle($warnBoxBrush, 520, 20, 640, 45)
$g4.DrawRectangle($warnBoxPen, 520, 20, 640, 45)
$g4.DrawString("根据首期学员成果整理的结构示意图 · 模拟数据 · 非实际页面截图 · 非标准答案", $subFont, (Get-Brush 180 83 9), 530, 34)

$webRect = New-Object System.Drawing.Rectangle(40, 85, 1120, 580)
$g4.FillRectangle([System.Drawing.Brushes]::White, $webRect)
$g4.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 2)), $webRect)

$webHeader = New-Object System.Drawing.Rectangle(40, 85, 1120, 50)
$g4.FillRectangle((Get-Brush 15 23 42), $webHeader)
$g4.DrawString("抖音达人带货 ROI 投产监控工作台", $stepTitleFont, [System.Drawing.Brushes]::White, 60, 98)

$sideRect = New-Object System.Drawing.Rectangle(40, 135, 200, 530)
$g4.FillRectangle((Get-Brush 30 41 59), $sideRect)
$g4.DrawString("投产概览 (首页)", $subFont, (Get-Brush 96 165 250), 60, 160)
$g4.DrawString("达人库明细", $subFont, (Get-Brush 148 163 184), 60, 200)
$g4.DrawString("亏损预警跟进", $subFont, (Get-Brush 148 163 184), 60, 240)

$contentX = 260
$g4.DrawString("筛选过滤：合作月份 [ 2026年7月 ]  平台 [ 全渠道 ]  ROI状态 [ 低于目标(1.5) ]", $subFont, (Get-Brush 71 85 105), $contentX, 155)

$kpis = @(
    @{ T="本月合作达人"; V="128 位"; S="+12%" },
    @{ T="总坑位费支出"; V="45.2 万"; S="环比-5%" },
    @{ T="带货GMV产出"; V="118.6 万"; S="目标达成82%" },
    @{ T="平均 ROI"; V="2.62"; S="合格(目标>2.0)" }
)
for ($k=0; $k -lt 4; $k++) {
    $kx = $contentX + $k * 210
    $kBox = New-Object System.Drawing.Rectangle($kx, 190, 195, 80)
    $g4.FillRectangle((Get-Brush 241 245 249), $kBox)
    $g4.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)), $kBox)
    $g4.DrawString($kpis[$k].T, $subFont, (Get-Brush 100 116 139), $kx+10, 200)
    $g4.DrawString($kpis[$k].V, $stepTitleFont, (Get-Brush 30 41 59), $kx+10, 222)
    $g4.DrawString($kpis[$k].S, $subFont, (Get-Brush 37 99 235), $kx+10, 248)
}

$chartBox = New-Object System.Drawing.Rectangle($contentX, 290, 880, 150)
$g4.FillRectangle((Get-Brush 248 250 252), $chartBox)
$g4.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)), $chartBox)
$g4.DrawString("7月每日达人带货 ROI 变化趋势 ( SimpleLineChart )", $subFont, (Get-Brush 30 41 59), $contentX + 15, 305)

$tableBox = New-Object System.Drawing.Rectangle($contentX, 460, 880, 185)
$g4.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)), $tableBox)
$g4.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 1)), $tableBox)
$g4.DrawString("ROI 异常达人跟进明细 ( DataTable )", $subFont, (Get-Brush 30 41 59), $contentX + 15, 475)

$thBox = New-Object System.Drawing.Rectangle($contentX, 500, 880, 30)
$g4.FillRectangle((Get-Brush 241 245 249), $thBox)
$g4.DrawString("达人名称       坑位费      实际GMV      ROI      状态       跟进操作", $subFont, (Get-Brush 71 85 105), $contentX + 15, 507)

$g4.DrawString("美妆小仙女     20,000      12,500       0.625    [严重低效]   [发送预警函]", $subFont, (Get-Brush 225 29 72), $contentX + 15, 540)
$g4.DrawString("穿搭阿杰       35,000      41,000       1.171    [警告预警]   [要求补播]", $subFont, (Get-Brush 217 119 6), $contentX + 15, 575)
$g4.DrawString("生活家小王     15,000      48,000       3.200    [正常达标]   [续约追加]", $subFont, (Get-Brush 22 163 74), $contentX + 15, 610)

$bmp4.Save("$assetsDir\first-cohort-example.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g4.Dispose()
$bmp4.Dispose()

Write-Host "SUCCESS: 4 张标准视觉 PNG 图片已更新生成在 $assetsDir"
