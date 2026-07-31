<template>
  <div class="relative flex flex-col min-w-0">
    <!-- 骨架屏 -->
    <Transition name="skeleton-fade">
      <div
        v-if="showSkeleton"
        class="absolute inset-0 z-10 bg-white dark:bg-gray-900 rounded-lg shadow-panel p-4 overflow-hidden"
      >
        <div class="skeleton-shine" />
        <div class="skeleton-bar h-4 w-1/3 mb-1" />
        <div class="skeleton-bar h-7 w-2/3 mb-3" />
        <div class="flex flex-col gap-1.5">
          <div class="skeleton-bar h-3.5 w-full" />
          <div class="skeleton-bar h-3.5 w-4/5" />
          <div class="skeleton-bar h-3.5 w-3/5" />
        </div>
      </div>
    </Transition>

    <!-- 卡片主体 -->
    <div
      class="flex-1 w-full p-4 bg-white dark:bg-gray-900 rounded-lg shadow-panel border border-gray-100 dark:border-gray-700/60 sales-card-gradient"
      :class="['border-t-4 border-t-solid']"
      :style="{ borderTopColor: borderColor }"
    >
      <h3
        class="text-sm font-semibold text-gray-500 dark:text-gray-400 mb-1 flex items-center gap-1.5"
      >
        {{ data.title }}
        <el-tooltip placement="bottom" effect="dark" :content="tip" :show-after="300">
          <span
            class="inline-flex items-center justify-center w-4 h-4 rounded-full border border-gray-300 text-blue-700 bg-blue-50 text-xs font-extrabold cursor-help"
            >?</span
          >
        </el-tooltip>
      </h3>
      <div class="text-2xl font-extrabold text-gray-900 dark:text-gray-100 mb-3 leading-tight">
        {{ animatedValue }}
      </div>

      <div class="flex flex-col gap-1.5 text-xs text-gray-500 dark:text-gray-400">
        <!-- 预算 -->
        <div class="flex justify-between items-center gap-2">
          <span>{{ budgetLabel }}</span>
          <strong class="text-gray-800 dark:text-gray-100 font-semibold">{{
            animatedTarget
          }}</strong>
        </div>

        <!-- 达成率 -->
        <div class="flex justify-between items-center gap-2">
          <span>{{ rateLabel }}</span>
          <strong
            :class="
              data.targetRate >= 100
                ? 'text-green-600 dark:text-green-400'
                : 'text-red-500 dark:text-red-400'
            "
          >
            {{ animatedTargetRate }}%
          </strong>
        </div>

        <!-- 缺口 -->
        <div class="flex justify-between items-center gap-2">
          <span>{{ gapLabel }}</span>
          <strong
            :class="
              diffVal >= 0 ? 'text-green-600 dark:text-green-400' : 'text-red-500 dark:text-red-400'
            "
          >
            {{ animatedGap }}
          </strong>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { SalesCardData } from '@/types/dashboard'
import { computed } from 'vue'
import { useTransition } from '@vueuse/core'
  // 类型定义：新增 loading 父组件控制参数
  interface Props {
    data: SalesCardData
    borderColor?: string
    loading?: boolean
  }

  const props = withDefaults(defineProps<Props>(), {
    borderColor: '#2563eb',
    loading: false
  })

  // ==================== 智能判断 ====================
  const isSalesTitle = computed(() => {
    return props.data?.title?.includes('销售额') ?? false
  })

  const isCumulative = computed(() => {
    return props.data?.title?.includes('累计') ?? false
  })

  const showSkeleton = computed(() => {
    return props.loading || !props.data || props.data.value == null
  })

  // 帮助提示
  const tip = computed(() => {
    const prefix = isSalesTitle.value
      ? '净销售额 = 各平台销售额合计，已扣除退款和刷单。'
      : '净销售件数 = 各平台销售件数合计，已扣除退货。'
    const scope = isCumulative.value ? '累计口径：1月至所选月份末。' : '当月口径：所选月份整月。'
    return `${prefix}${scope}达成率 = 实际 ÷ 预算 × 100%。缺口 = 实际 − 预算，负数表示未达预算目标。`
  })

  // 动态标签：当月 / 累计
  const budgetLabel = computed(() => (isCumulative.value ? '累计预算' : '预算'))
  const rateLabel = computed(() => (isCumulative.value ? '累计达成率' : '达成率'))
  const gapLabel = computed(() => {
    if (isCumulative.value) return '累计缺口'
    return isSalesTitle.value ? '缺口' : '件数缺口'
  })

  // 差异额
  const diffVal = computed(() => (props.data?.value || 0) - (props.data?.target || 0))

  // 主数值格式化（销售额保留2位小数，数量不保留）
  const formatValue = (num: number) => {
    if (isSalesTitle.value) {
      return new Intl.NumberFormat('zh-CN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      }).format(num)
    } else {
      return Math.floor(num).toLocaleString('zh-CN')
    }
  }

  // 辅助数值格式化（销售额显示 w，数量直接显示）
  const formatNormal = (num: number) => {
    if (isSalesTitle.value) {
      return `${(num / 10000).toFixed(2)}w`
    } else {
      return Math.floor(num).toLocaleString('zh-CN')
    }
  }

  // 缺口格式化（带正负号）
  const formatGap = (num: number) => {
    const sign = num >= 0 ? '+' : ''
    if (isSalesTitle.value) {
      return `${sign}¥${(Math.abs(num) / 10000).toFixed(2)}w`
    } else {
      return `${sign}${Math.floor(num).toLocaleString('zh-CN')}`
    }
  }

  // useTransition 数字动画
  const animValueRaw = useTransition(computed(() => props.data?.value || 0), { duration: 600, delay: 50 })
  const animTargetRaw = useTransition(computed(() => props.data?.target || 0), { duration: 600, delay: 100 })
  const animGapRaw = useTransition(computed(() => diffVal.value), { duration: 600, delay: 200 })
  const animTargetRateRaw = useTransition(computed(() => props.data?.targetRate || 0), { duration: 600, delay: 150 })

  const animatedValue = computed(() => formatValue(animValueRaw.value))
  const animatedTarget = computed(() => formatNormal(animTargetRaw.value))
  const animatedGap = computed(() => formatGap(animGapRaw.value))
  const animatedTargetRate = computed(() => Math.round(animTargetRateRaw.value))
</script>

<style scoped>
  .skeleton-shine {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1;
    width: 50%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgb(255 255 255 / 25%), transparent);
    animation: sk-wave 1.6s cubic-bezier(0.4, 0, 0.2, 1) infinite;
  }

  .skeleton-bar {
    border-radius: 4px;
    margin-bottom: 4px;
    background: linear-gradient(90deg, #e5e7eb 25%, #d1d5db 50%, #e5e7eb 75%);
    background-size: 200% 100%;
    animation: sk-pulse 1.2s ease-in-out infinite;
  }

  .skeleton-fade-leave-active {
    transition: opacity 0.3s ease-out;
  }

  .skeleton-fade-leave-to {
    opacity: 0;
  }
</style>

<style>
  .dark .skeleton-bar {
    background: linear-gradient(90deg, #374151 25%, #4b5563 50%, #374151 75%);
    background-size: 200% 100%;
  }

  .sales-card-gradient {
    position: relative;
  }

  .sales-card-gradient::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(180deg, rgba(37, 99, 235, 0.03) 0%, rgba(255, 255, 255, 0) 60%);
    pointer-events: none;
    z-index: 0;
  }

  .dark .sales-card-gradient::before {
    background: linear-gradient(180deg, rgba(59, 130, 246, 0.06) 0%, rgba(24, 24, 28, 0) 60%);
  }
</style>
