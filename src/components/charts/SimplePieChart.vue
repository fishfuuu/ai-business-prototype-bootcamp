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

interface PieItem {
  name: string
  value: number
}

interface Props {
  title: string
  description?: string
  data: PieItem[]
  height?: number | string
  loading?: boolean
  emptyText?: string
  donut?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  description: '',
  height: 320,
  loading: false,
  emptyText: '暂无图表数据',
  donut: true
})

const chartRef = ref<HTMLElement | null>(null)

const chartHeight = computed(() => {
  return typeof props.height === 'number'
    ? `${props.height}px`
    : props.height
})

const hasData = computed(() => {
  return props.data.some((item) => item.value !== 0)
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
    trigger: 'item',
    ...chartTooltipStyle,
    valueFormatter: (value) => {
      const numberValue = Number(value)

      return Number.isFinite(numberValue)
        ? numberValue.toLocaleString('zh-CN')
        : String(value)
    }
  },

  legend: {
    type: 'scroll',
    orient: 'horizontal',
    left: 'center',
    bottom: 0,
    itemWidth: 12,
    itemHeight: 8,
    textStyle: {
      color: chartColors.axisLabel,
      fontSize: 12,
      fontFamily: chartFontFamily
    }
  },

  series: [
    {
      type: 'pie',
      radius: props.donut
        ? ['40%', '62%']
        : '62%',
      center: ['50%', '43%'],
      data: props.data,
      avoidLabelOverlap: true,

      label: {
        show: true,
        position: 'outside',
        formatter: '{b}\n{d}%',
        color: chartColors.axisLabel,
        fontSize: 12,
        fontFamily: chartFontFamily,
        lineHeight: 16
      },

      labelLine: {
        show: true,
        length: 12,
        length2: 8,
        lineStyle: {
          color: chartColors.splitLine
        }
      },

      emphasis: {
        scale: true,
        scaleSize: 4,
        label: {
          show: true,
          color: chartColors.textPrimary,
          fontSize: 12,
          fontWeight: 600
        },
        itemStyle: {
          shadowBlur: 12,
          shadowOffsetY: 4,
          shadowColor: 'rgba(26, 37, 64, 0.14)'
        }
      }
    }
  ]
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

