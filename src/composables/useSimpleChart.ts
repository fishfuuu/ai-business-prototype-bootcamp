import {
  nextTick,
  onBeforeUnmount,
  onMounted,
  watch,
  type ComputedRef,
  type Ref
} from 'vue'

import {
  echarts,
  type ECharts,
  type EChartsOption
} from '@/plugins/echarts'

interface UseSimpleChartOptions {
  containerRef: Ref<HTMLElement | null>
  chartOptions: ComputedRef<EChartsOption>
  enabled: ComputedRef<boolean>
}

export function useSimpleChart({
  containerRef,
  chartOptions,
  enabled
}: UseSimpleChartOptions) {
  let chartInstance: ECharts | null = null
  let resizeObserver: ResizeObserver | null = null

  function disposeChart() {
    resizeObserver?.disconnect()
    resizeObserver = null

    chartInstance?.dispose()
    chartInstance = null
  }

  async function renderChart() {
    await nextTick()

    const container = containerRef.value

    if (!container || !enabled.value) {
      chartInstance?.clear()
      return
    }

    if (!chartInstance) {
      chartInstance = echarts.init(container)

      resizeObserver = new ResizeObserver(() => {
        chartInstance?.resize()
      })

      resizeObserver.observe(container)
    }

    chartInstance.setOption(
      chartOptions.value,
      {
        notMerge: true,
        lazyUpdate: true
      }
    )
  }

  function resizeChart() {
    chartInstance?.resize()
  }

  onMounted(() => {
    void renderChart()
  })

  watch(
    [chartOptions, enabled],
    () => {
      void renderChart()
    },
    {
      deep: true
    }
  )

  onBeforeUnmount(() => {
    disposeChart()
  })

  return {
    renderChart,
    resizeChart
  }
}
