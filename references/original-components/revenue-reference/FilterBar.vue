<template>
  <div
    class="sticky top-23 z-50 max-sm:static bg-white dark:bg-gray-900 rounded-xl shadow-panel border border-gray-100 dark:border-gray-700/60 p-4 mb-4 transition-shadow duration-300"
  >
    <div class="flex max-sm:grid max-sm:grid-cols-2 items-end gap-3 w-full">
      <div class="flex-1 min-w-[100px] max-sm:col-span-2">
        <div class="text-xs text-gray-500 mb-1.5 block sm:hidden">查询月份</div>
        <MonthRangePicker
          v-model="monthRange"
          type="monthrange"
          start-placeholder="查询月份"
          size="large"
          class="!w-full !min-w-0"
          @change="handleMonthRangeChange"
        />
      </div>

      <div class="flex-1 min-w-[80px]">
        <div class="text-xs text-gray-500 mb-1.5 block sm:hidden">品类</div>
        <el-select
          v-model="selectedCategory"
          placeholder="品类"
          size="large"
          class="!w-full"
          @change="emitSearch"
        >
          <el-option
            v-for="item in categoryOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </div>

      <div class="flex-1 min-w-[80px]">
        <div class="text-xs text-gray-500 mb-1.5 block sm:hidden">平台</div>
        <el-select
          v-model="selectedChannel"
          placeholder="平台"
          size="large"
          class="!w-full"
          @change="emitSearch"
        >
          <el-option
            v-for="item in channelOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </div>

      <div class="flex-1 min-w-[80px] max-sm:col-span-2">
        <div class="text-xs text-gray-500 mb-1.5 block sm:hidden">指标</div>
        <el-select
          v-model="selectedStat"
          placeholder="指标"
          size="large"
          class="!w-full"
          @change="emitSearch"
        >
          <el-option label="净销售额" value="amount" />
          <el-option label="净销售件数" value="quantity" />
        </el-select>
      </div>

      <div class="flex items-center gap-2 shrink-0 max-sm:col-span-2 max-sm:mt-2 ml-auto">
        <el-button
          type="primary"
          size="large"
          @click="handleEnterAttainment"
          class="max-sm:flex-1 !ml-0"
          >进入收入达成分析</el-button
        >

        <div class="flex items-center gap-0 shrink-0 max-sm:flex-1">
          <el-button
            :type="currentTab === 'month' ? 'primary' : ''"
            size="large"
            @click="handleTab('month')"
            class="max-sm:flex-1 !ml-0"
            >本月</el-button
          >
          <el-button
            :type="currentTab === 'year' ? 'primary' : ''"
            size="large"
            @click="handleTab('year')"
            class="max-sm:flex-1 !ml-0"
            >本年</el-button
          >
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, onMounted, computed } from 'vue'
  import moment from 'moment'
  import MonthRangePicker from '@/components/MonthRangePicker/index.vue'

  // 定义 props（下拉选项从父页面传入）
  interface OptionItem {
    label: string
    value: string | number
  }

  const props = defineProps<{
    categoryOptions: OptionItem[]
    channelOptions: OptionItem[]
    exporting?: boolean
  }>()

  // 定义 emit 事件
  const emit = defineEmits<{
    search: [
      params: {
        category: string
        platform: string
        type: string
        startDate: string
        endDate: string
      }
    ]
    export: [
      params: {
        category: string
        platform: string
        type: string
        startDate: string
        endDate: string
      }
    ]
    enterAttainment: []
  }>()

  // ==================== 常量 ====================
  const DATE_FORMAT = 'YYYY-MM-DD'

  // ==================== 类型 ====================
  type TimeTabType = 'month' | 'year' | ''

  // ==================== 筛选状态 ====================
  const selectedCategory = ref<string>('')
  const selectedChannel = ref<string>('')
  const selectedStat = ref<string>('amount')

  const categoryOptions = computed(() => props.categoryOptions)
  const channelOptions = computed(() => props.channelOptions)

  // ==================== 时间控制 ====================
  const currentTab = ref<TimeTabType>('month')
  const monthRange = ref<(string | Date)[]>([]) // 月份区间
  const dateRange = ref<string[]>([]) // 最终传给接口的日期范围

  // ==================== 方法 ====================

  /**
   * 切换快捷时间（不触发 emit）
   */
  const setTabDate = (type: 'month' | 'year') => {
    currentTab.value = type
    monthRange.value = [] // 清空自定义区间

    const today = moment().format(DATE_FORMAT)
    const start =
      type === 'month'
        ? moment().startOf('month').format(DATE_FORMAT)
        : moment().startOf('year').format(DATE_FORMAT)

    dateRange.value = [start, today]
  }

  /**
   * 点击 tab 切换并触发搜索
   */
  const handleTab = (type: 'month' | 'year') => {
    setTabDate(type)
    emitSearch()
  }

  /**
   * 自定义月份区间选择
   */
  const handleMonthRangeChange = (val: string[]) => {
    if (!val || val.length !== 2) return
    currentTab.value = '' // 清空快捷tab

    const start = moment(val[0]).startOf('month').format(DATE_FORMAT)
    const end = moment(val[1]).endOf('month').format(DATE_FORMAT)
    dateRange.value = [start, end]

    emitSearch()
  }

  /**
   * 触发父组件搜索
   */
  const emitSearch = () => {
    const [startDate, endDate] = dateRange.value
    if (!startDate || !endDate) return

    emit('search', {
      category: selectedCategory.value || '',
      platform: selectedChannel.value || '',
      type: selectedStat.value,
      startDate,
      endDate
    })
  }

  /**
   * 初始化（设置默认时间 + 触发首次搜索）
   */
  const initFilter = () => {
    setTabDate('month')
    emitSearch()
  }

  // ==================== 生命周期 ====================
  onMounted(() => {
    initFilter()
  })

  const handleEnterAttainment = () => {
    emit('enterAttainment')
  }
</script>

<style scoped>
  @reference "tailwindcss";
</style>
