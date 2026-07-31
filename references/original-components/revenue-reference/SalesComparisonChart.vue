<template>
  <div
    class="chart-container w-full h-full p-6 max-sm:p-4 bg-white dark:bg-gray-900 rounded-xl shadow-panel border border-gray-100 dark:border-gray-700/60 relative"
  >
    <h2
      class="chart-title text-lg font-semibold text-gray-900 dark:text-gray-100 mb-5 flex items-center gap-1.5"
    >
      {{ labelText }}环同比对比表
      <el-tooltip placement="bottom" effect="dark" :show-after="300">
        <template #content>
          柱状图 = 实际{{ labelText }}。橙色折线 = 同比增长率（比去年同期）。蓝色折线 =
          环比增长率（比上月）。
        </template>
        <span
          class="inline-flex items-center justify-center w-4 h-4 rounded-full border border-gray-300 text-blue-700 bg-blue-50 text-xs font-extrabold cursor-help"
          >?</span
        >
      </el-tooltip>
    </h2>
    <!-- 外层包裹容器，用于数据过多时支持横向滚动 -->
    <div class="chart-wrapper w-full overflow-x-auto">
      <div ref="chartRef" class="echarts-box w-full h-[400px] min-h-[300px]"></div>
    </div>

    <!-- 🔥 优化：高端丝滑流光骨架屏 -->
    <Transition name="skeleton-fade">
      <div
        v-if="loading"
        class="absolute inset-0 z-10 bg-white dark:bg-gray-900 rounded-xl p-5 flex flex-col overflow-hidden"
      >
        <!-- 流光动画层 -->
        <div class="skeleton-shine"></div>

        <!-- 标题骨架 -->
        <div class="w-1/3 h-6 bg-gray-200 dark:bg-gray-700 rounded-xl mb-6"></div>
        <!-- 图表区域骨架 -->
        <div class="w-full h-[400px] bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
  import { ref, onMounted, onUnmounted, watch, computed } from 'vue'
  import * as echarts from 'echarts'
  import type { EChartsOption, SeriesOption } from 'echarts'

  // ==================== 1. 类型定义（严格TS标准） ====================
  interface ChartProps {
    /** X轴日期数据 */
    xData: string[]
    /** 净销售额数据（单位：w） */
    salesData: number[]
    /** 同比增长率（%） */
    yoyData: number[]
    /** 环比增长率（%） */
    momData: number[]
    /** 加载状态 */
    loading?: boolean
    /** 类型：amount=金额  quantity=数量 */
    type: 'amount' | 'quantity'
  }

  const props = defineProps<ChartProps>()

  // ==================== 🔥 动态文字切换 ====================
  const labelText = computed(() => (props.type === 'amount' ? '净销售额' : '净销售件数'))

  // ==================== 2. 响应式变量与工具函数 ====================
  const chartRef = ref<HTMLElement | null>(null)
  let chartInstance: echarts.ECharts | null = null
  const isDark = ref(false)
  const isMobile = ref(false)
  const isLargeData = ref(false)
  const LARGE_DATA_THRESHOLD = 12

  /** 检查设备与数据量状态 */
  const checkEnvStatus = () => {
    isMobile.value = window.innerWidth <= 768
    isLargeData.value = (props.xData?.length || 0) >= LARGE_DATA_THRESHOLD
  }

  /** 检查暗黑模式状态 */
  const checkDarkMode = (): void => {
    isDark.value = document.documentElement.classList.contains('dark')
  }

  /** 计算数组的绝对值最大值（带留白） */
  const getAbsMaxWithPadding = (data: number[], paddingRatio = 1.2): number => {
    if (!data.length) return 0
    const absMax = Math.max(...data.map(Math.abs))
    return Math.ceil(absMax * paddingRatio)
  }

  // ==================== ✅ 新增：节假日 & 周末判断工具 ====================
  /** 节假日列表（自行维护，格式：YYYY-MM-DD） */
  const HOLIDAY_LIST = [
    '2025-01-01',
    '2025-01-20',
    '2025-02-01',
    '2025-02-02',
    '2025-04-05',
    '2025-05-01',
    '2025-06-10',
    '2025-09-15',
    '2025-10-01'
  ]

  /** 判断是否为周末 */
  const isWeekend = (dateStr: string): boolean => {
    try {
      const day = new Date(dateStr).getDay()
      return day === 0 || day === 6 // 周日/周六
    } catch {
      return false
    }
  }

  /** 判断是否为节假日 */
  const isHoliday = (dateStr: string): boolean => {
    return HOLIDAY_LIST.includes(dateStr)
  }

  /**
   * ✅ 核心改动：判断 X 轴是不是【月份】
   * 匹配：YYYY-MM 或 MM 格式
   */
  const isMonthFormat = (dateStr: string): boolean => {
    // 正则匹配月份格式：YYYY-MM 或 01-12 的纯月份
    const monthReg = /^\d{4}-\d{1,2}$|^(0[1-9]|1[0-2])$/
    return monthReg.test(dateStr)
  }

  /** 判断是否需要特殊颜色（节假日 OR 周末），月份直接返回 false */
  const isSpecialDay = (dateStr: string): boolean => {
    // ✅ 如果是月份，直接不使用特殊颜色
    if (isMonthFormat(dateStr)) return false
    // 只有日期格式才判断周末/节假日
    return isWeekend(dateStr) || isHoliday(dateStr)
  }

  // ==================== 3. 计算属性（数据预处理） ====================
  const xData = computed(() => props.xData ?? [])
  const salesData = computed(() => props.salesData ?? [])
  const yoyData = computed(() => props.yoyData ?? [])
  const momData = computed(() => props.momData ?? [])

  // 左侧Y轴：净销售额最大值
  const leftYMax = computed(() => {
    const max = Math.max(...(salesData.value.length ? salesData.value : [0]))
    return Math.ceil((max * 1.1) / 1000) * 1000
  })

  // 同比/环比独立Y轴范围
  const yoyAbsMax = computed(() => getAbsMaxWithPadding(yoyData.value))
  const momAbsMax = computed(() => getAbsMaxWithPadding(momData.value))

  // 环比标记点
  const momMarkPoints = computed(() =>
    momData.value
      .filter((val) => val !== 0)
      .map((val, index) => ({
        coord: [index, val],
        value: val > 0 ? `+${val}%` : `${val}%`,
        itemStyle: {
          color: val > 0 ? '#4CAF50' : '#F44336',
          borderWidth: 2,
          borderColor: '#fff'
        }
      }))
  )

  // ==================== ✅ 颜色逻辑已自动适配月份 ====================
  const salesBarColors = computed(() => {
    const { value: dark } = isDark
    return xData.value.map((date) => {
      const special = isSpecialDay(date)
      // 节假日/周末颜色
      if (special) {
        return dark
          ? new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#FF8A00' },
              { offset: 1, color: '#FFB74D' }
            ])
          : new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#FF9800' },
              { offset: 1, color: '#FFCC80' }
            ])
      }
      // 正常工作日 + 月份展示：统一蓝色
      return dark
        ? new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#002780' },
            { offset: 1, color: '#004eff' }
          ])
        : new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#165DFF' },
            { offset: 1, color: '#99b8ff' }
          ])
    })
  })

  // ==================== 4. 图表核心配置 ====================
  const getChartOption = (): EChartsOption => {
    const { value: dark } = isDark
    const textColor = dark ? '#e5e7eb' : '#333'
    const axisColor = dark ? '#9ca3af' : '#666'
    const splitLineColor = dark ? '#374151' : '#e0e0e0'

    const seriesLabelHide = isMobile.value || isLargeData.value
    const xAxisRotate = isMobile.value ? 45 : 0
    const xAxisFontSize = isMobile.value ? 10 : 12

    return {
      animation: true,
      animationDuration: 800,
      animationEasing: 'cubicOut',
      animationDelay: (idx: number) => idx * 50,
      animationDurationUpdate: 500,
      animationEasingUpdate: 'cubicInOut',
      tooltip: {
        trigger: 'axis',
        axisPointer: { type: 'cross' },
        textStyle: { color: dark ? '#fff' : '#333' },
        backgroundColor: dark ? 'rgba(17,24,39,0.95)' : 'rgba(255,255,255,0.95)',
        formatter: (params: any) => {
          let str = `<div style="min-width: 120px">${params[0].axisValue}</div>`
          params.forEach((item: any) => {
            if (item.seriesName === labelText.value) {
              str += `${item.marker}${item.seriesName}：${item.value.toLocaleString()}<br/>`
            } else {
              str += `${item.marker}${item.seriesName}：${item.value > 0 ? '+' : ''}${item.value}%<br/>`
            }
          })
          return str
        }
      },
      legend: {
        data: [labelText.value, '同比', '环比'],
        top: 0,
        left: 'center',
        textStyle: { fontSize: 14, color: textColor },
        itemWidth: 16,
        itemHeight: 8,
        itemGap: 25
      },
      grid: { left: '1%', right: '1%', bottom: '3%', top: '18%', containLabel: true },
      dataZoom: isLargeData.value
        ? [
            { type: 'inside', start: 0, end: 70 },
            { start: 0, end: 70, height: 10, bottom: 5 }
          ]
        : [],
      xAxis: {
        type: 'category',
        data: xData.value,
        axisLabel: {
          fontSize: xAxisFontSize,
          color: axisColor,
          rotate: xAxisRotate,
          interval: 'auto',
          overflow: 'truncate',
          ellipsis: '...'
        },
        axisLine: { lineStyle: { color: axisColor } },
        axisTick: { show: false }
      },
      yAxis: [
        {
          type: 'value',
          name: labelText.value,
          position: 'left',
          min: 0,
          max: leftYMax.value,
          axisLabel: {
            formatter: (v: number) =>
              props.type === 'amount'
                ? v >= 10000
                  ? `${(v / 10000).toFixed(1)}w`
                  : `${v}`
                : `${v}`,
            color: '#165DFF',
            fontSize: 12
          },
          axisLine: { lineStyle: { color: '#165DFF' } },
          splitLine: { lineStyle: { type: 'dashed', color: splitLineColor } }
        },

        {
          type: 'value',
          name: '环比',
          position: 'right',
          offset: 0,
          min: -momAbsMax.value,
          max: momAbsMax.value,
          interval: (momAbsMax.value / 2) || 5,
          axisLabel: {
            formatter: '{value}%',
            color: '#6a35ff',
            fontSize: 12,
            margin: 8
          },
          axisLine: { lineStyle: { color: '#6a35ff' } },
          splitLine: { show: false },
          nameTextStyle: { color: '#6a35ff', fontSize: 12 }
        },

        {
          type: 'value',
          name: '同比',
          position: 'right',
          offset: 50,
          min: -yoyAbsMax.value,
          max: yoyAbsMax.value,
          interval: (yoyAbsMax.value / 2) || 5,
          axisLabel: {
            formatter: '{value}%',
            color: '#155da6',
            fontSize: 12,
            margin: 8
          },
          axisLine: { lineStyle: { color: '#155da6' } },
          splitLine: { show: false },
          nameTextStyle: { color: '#155da6', fontSize: 12 }
        }
      ],
      series: [
        // ✅ 净销售额/件数 柱状图：使用动态颜色
        {
          name: labelText.value,
          type: 'bar',
          yAxisIndex: 0,
          data: salesData.value,
          itemStyle: {
            // 直接使用数组，按项染色
            color: (params: any) => salesBarColors.value[params.dataIndex],
            borderRadius: [4, 4, 0, 0]
          },
          barWidth: isMobile.value ? '40%' : '60%'
        } as SeriesOption,

        {
          name: '环比',
          type: 'line',
          yAxisIndex: 1,
          data: momData.value,
          smooth: true,
          symbol: 'circle',
          symbolSize: seriesLabelHide ? 6 : 8,
          itemStyle: { color: '#6a35ff' },
          lineStyle: { width: seriesLabelHide ? 1.5 : 2 },
          label: {
            show: !seriesLabelHide,
            fontSize: 10,
            color: dark ? '#fff' : '#000',
            fontWeight: 'bold',
            position: 'bottom',
            distance: -20,
            formatter: (v: any) => `${v.data > 0 ? '+' : ''}${v.data}%`
          },
          markPoint: {
            data: momMarkPoints.value,
            symbol: 'circle',
            symbolSize: 10,
            label: { show: false }
          }
        } as SeriesOption,

        {
          name: '同比',
          type: 'line',
          yAxisIndex: 2,
          data: yoyData.value,
          smooth: true,
          symbol: 'circle',
          symbolSize: seriesLabelHide ? 6 : 8,
          itemStyle: { color: '#155da6' },
          lineStyle: { width: seriesLabelHide ? 2 : 3 },
          label: {
            show: !seriesLabelHide,
            fontSize: 10,
            color: dark ? '#fff' : '#000',
            fontWeight: 'bold',
            position: 'top',
            distance: 0,
            formatter: (v: any) => `${v.data > 0 ? '+' : ''}${v.data}%`
          }
        } as SeriesOption
      ]
    }
  }

  // ==================== 5. 生命周期与事件监听 ====================
  const initChart = (): void => {
    if (!chartRef.value) return
    chartInstance?.dispose()
    checkEnvStatus()
    checkDarkMode()
    chartInstance = echarts.init(chartRef.value)
    chartInstance.setOption(getChartOption())
  }

  const updateTheme = (): void => {
    checkDarkMode()
    chartInstance?.setOption(getChartOption(), true)
  }

  const resizeChart = (): void => {
    checkEnvStatus()
    chartInstance?.resize()
  }

  watch(() => [props.xData, props.salesData, yoyData.value, momData.value, props.type], initChart, {
    deep: true
  })

  onMounted(() => {
    initChart()
    window.addEventListener('resize', resizeChart)
    new MutationObserver(updateTheme).observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['class']
    })
  })

  onUnmounted(() => {
    window.removeEventListener('resize', resizeChart)
    chartInstance?.dispose()
  })
</script>

<style scoped>
  @reference "tailwindcss";

  /* 🔥 高端丝滑流光骨架屏动画 */
  .skeleton-shine {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1;
    width: 50%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgb(255 255 255 / 25%), transparent);
    animation: skeleton-flow 1.6s infinite linear;
  }

  @keyframes skeleton-flow {
    0% {
      transform: translateX(-150%) skewX(-20deg);
    }

    100% {
      transform: translateX(250%) skewX(-20deg);
    }
  }

  /* 深色模式适配 */
  :global(.dark) .skeleton-shine {
    background: linear-gradient(90deg, transparent, rgb(255 255 255 / 12%), transparent);
  }

  .chart-wrapper::-webkit-scrollbar {
    height: 6px;
  }

  .chart-wrapper::-webkit-scrollbar-thumb {
    @apply bg-gray-300 dark:bg-gray-600 rounded-xl;
  }

  .chart-wrapper::-webkit-scrollbar-track {
    @apply bg-gray-100 dark:bg-gray-800 rounded-xl;
  }

  @media (width <= 768px) {
    .chart-title {
      @apply text-base mb-3;
    }

    .echarts-box {
      @apply h-[350px] min-w-[600px];
    }
  }

  @media (width <= 480px) {
    .echarts-box {
      @apply h-[320px] min-w-[500px];
    }
  }
</style>
