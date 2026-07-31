<template>
  <article
    class="kpi-card"
    :class="`kpi-card-${status}`"
  >
    <el-skeleton
      v-if="loading"
      :rows="2"
      animated
    />

    <template v-else>
      <div class="kpi-card-header">
        <span class="kpi-title">
          {{ title }}
        </span>

        <span
          class="kpi-status-dot"
          aria-hidden="true"
        ></span>
      </div>

      <div class="kpi-value-row">
        <strong class="kpi-value financial-value">
          {{ displayValue }}
        </strong>

        <span
          v-if="unit"
          class="kpi-unit"
        >
          {{ unit }}
        </span>
      </div>

      <div
        v-if="description || trend !== null"
        class="kpi-footer"
      >
        <span class="kpi-description">
          {{ description }}
        </span>

        <span
          v-if="trend !== null"
          class="kpi-trend financial-value"
          :class="trendClass"
        >
          {{ trendText }}
        </span>
      </div>
    </template>
  </article>
</template>

<script setup lang="ts">
import { computed } from 'vue'

type KpiStatus = 'neutral' | 'success' | 'warning' | 'danger'

interface Props {
  title: string
  value: string | number
  unit?: string
  description?: string
  trend?: number | null
  status?: KpiStatus
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  unit: '',
  description: '',
  trend: null,
  status: 'neutral',
  loading: false
})

const displayValue = computed(() => {
  if (typeof props.value === 'number') {
    return props.value.toLocaleString('zh-CN')
  }

  return props.value
})

const trendText = computed(() => {
  if (props.trend === null) {
    return ''
  }

  const prefix = props.trend > 0 ? '+' : ''
  return `${prefix}${props.trend.toFixed(1)}%`
})

const trendClass = computed(() => {
  if (props.trend === null || props.trend === 0) {
    return 'trend-neutral'
  }

  return props.trend > 0 ? 'trend-positive' : 'trend-negative'
})
</script>

<style scoped>
.kpi-card {
  position: relative;
  min-height: 144px;
  padding: 16px;
  overflow: hidden;
  border: 1px solid var(--art-border-card);
  border-radius: var(--art-radius-panel);
  background: var(--art-card-bg);
  box-shadow: var(--art-shadow-panel);
}

.kpi-card::before {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  height: 4px;
  content: "";
  background: var(--art-gray-200);
}

.kpi-card-success::before {
  background: var(--art-success);
}

.kpi-card-warning::before {
  background: var(--art-warning);
}

.kpi-card-danger::before {
  background: var(--art-danger);
}

.kpi-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.kpi-title {
  color: var(--art-text-secondary);
  font-size: 14px;
  font-weight: 600;
  line-height: 1.5;
}

.kpi-status-dot {
  width: 8px;
  height: 8px;
  flex-shrink: 0;
  border-radius: 50%;
  background: var(--art-gray-200);
}

.kpi-card-success .kpi-status-dot {
  background: var(--art-success);
}

.kpi-card-warning .kpi-status-dot {
  background: var(--art-warning);
}

.kpi-card-danger .kpi-status-dot {
  background: var(--art-danger);
}

.kpi-value-row {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-top: 16px;
}

.kpi-value {
  color: var(--art-text-primary);
  font-size: 24px;
  font-weight: 800;
  line-height: 1.25;
}

.kpi-unit {
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.kpi-footer {
  display: flex;
  min-height: 24px;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
  margin-top: 16px;
}

.kpi-description {
  overflow: hidden;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.kpi-trend {
  flex-shrink: 0;
  font-size: 12px;
  font-weight: 700;
  line-height: 1.5;
}

.trend-neutral {
  color: var(--art-text-secondary);
}

.trend-positive {
  color: var(--art-success);
}

.trend-negative {
  color: var(--art-danger);
}
</style>

