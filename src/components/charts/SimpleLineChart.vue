<template>
  <section class="chart-card">
    <div class="chart-heading">
      <div>
        <h2>{{ title }}</h2>

        <p v-if="description">
          {{ description }}
        </p>
      </div>
    </div>

    <div
      v-if="loading"
      class="chart-loading"
      :style="{ height: chartHeight }"
    >
      <el-skeleton
        :rows="5"
        animated
      />
    </div>

    <ArtEmptyState
      v-else-if="!hasData"
      :description="emptyText"
    />

    <div
      v-show="!loading && hasData"
      ref="chartRef"
      class="chart-canvas"
      :style="{ height: chartHeight }"
    ></div>
  </section>
</template>

<script setup lang="ts">
import {
  computed,
  ref
} from 'vue'

import type { EChartsOption } from '@/plugins/echarts'
import { useSimpleChart } from '@/composables/useSimpleChart'
import ArtEmptyState from '@/components/business/ArtEmptyState.vue'
import {
  chartColors,
  chartFontFamily,
  chartSeriesPalette,
  chartTooltipStyle
} from '@/components/charts/chartTheme'

interface LineSeries {
  name: string
  data: number[]
}

interface Props {
  title: string
  description?: string
  xData: string[]
  series: LineSeries[]
  height?: number | string
  loading?: boolean
  emptyText?: string
  smooth?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  description: '',
  height: 320,
  loading: false,
  emptyText: '暂无图表数据',
  smooth: true
})

const chartRef = ref<HTMLElement | null>(null)

const chartHeight = computed(() => {
  return typeof props.height === 'number'
    ? `${props.height}px`
    : props.height
})

const hasData = computed(() => {
  return (
    props.xData.length > 0 &&
    props.series.some((item) => item.data.length > 0)
  )
})

const enabled = computed(() => {
  return !props.loading && hasData.value
})

const chartOptions = computed<EChartsOption>(() => ({
  color: chartSeriesPalette,

  textStyle: {
    color: chartColors.textPrimary,
    fontFamily: chartFontFamily,
    fontSize: 12
  },

  animationDuration: 500,
  animationEasing: 'cubicOut',

  tooltip: {
    trigger: 'axis',
    ...chartTooltipStyle,
    axisPointer: {
      lineStyle: {
        color: chartColors.seriesPrimary,
        width: 1
      }
    }
  },

  legend: {
    show: props.series.length > 1,
    top: 0,
    right: 0,
    itemWidth: 16,
    itemHeight: 8,
    textStyle: {
      color: chartColors.axisLabel,
      fontSize: 12,
      fontFamily: chartFontFamily
    }
  },

  grid: {
    top: props.series.length > 1 ? 48 : 24,
    right: 24,
    bottom: 24,
    left: 24,
    containLabel: true
  },

  xAxis: {
    type: 'category',
    data: props.xData,
    boundaryGap: false,
    axisTick: {
      show: false
    },
    axisLine: {
      lineStyle: {
        color: chartColors.splitLine
      }
    },
    axisLabel: {
      color: chartColors.axisLabel,
      fontSize: 12,
      fontFamily: chartFontFamily
    }
  },

  yAxis: {
    type: 'value',
    axisTick: {
      show: false
    },
    axisLine: {
      show: false
    },
    axisLabel: {
      color: chartColors.axisLabel,
      fontSize: 12,
      fontFamily: chartFontFamily
    },
    splitLine: {
      lineStyle: {
        color: chartColors.splitLine,
        type: 'dashed'
      }
    }
  },

  series: props.series.map((item) => ({
    name: item.name,
    type: 'line',
    data: item.data,
    smooth: props.smooth,
    symbol: 'circle',
    symbolSize: 6,
    showSymbol: true,
    lineStyle: {
      width: 2
    },
    emphasis: {
      focus: 'series'
    }
  }))
}))

useSimpleChart({
  containerRef: chartRef,
  chartOptions,
  enabled
})
</script>

<style scoped>
.chart-card {
  padding: 24px;
  border: 1px solid var(--art-border-card);
  border-radius: var(--art-radius-panel);
  background: var(--art-card-bg);
  box-shadow: var(--art-shadow-panel);
}

.chart-heading {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.chart-heading h2 {
  margin: 0;
  color: var(--art-text-primary);
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
}

.chart-heading p {
  margin: 8px 0 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.chart-loading {
  padding: 16px 0;
}

.chart-canvas {
  width: 100%;
  min-height: 240px;
}

@media (width <= 640px) {
  .chart-card {
    padding: 16px;
  }
}
</style>

