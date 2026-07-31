<template>
  <!-- 弹窗增加过渡动画 -->
  <el-popover
    v-model:visible="pickerVisible"
    placement="bottom-start"
    trigger="click"
    :width="300"
    popper-class="month-range-picker-popper"
    @show="onPickerShow"
    transition="fade-slide"
  >
    <div class="month-range-picker">
      <!-- 年份切换 -->
      <div class="month-range-header">
        <button class="month-range-btn" @click="currentYear--" :disabled="currentYear <= minYear">
          <el-icon><ArrowLeft /></el-icon>
        </button>
        <span class="month-range-year">{{ currentYear }} 年</span>
        <button class="month-range-btn" @click="currentYear++" :disabled="currentYear >= maxYear">
          <el-icon><ArrowRight /></el-icon>
        </button>
      </div>

      <!-- 12 个月选择 -->
      <div class="month-range-body">
        <div
          v-for="m in 12"
          :key="m"
          class="month-cell"
          :class="getMonthClass(m)"
          @click="selectMonth(m)"
        >
          {{ m }}月
        </div>
      </div>

      <!-- 底部按钮 -->
      <div class="month-range-footer">
        <el-button size="small" text @click="pickerVisible = false">取消</el-button>
        <el-button type="primary" size="small" @click="confirm">确定</el-button>
      </div>
    </div>

    <!-- 触发元素 -->
    <template #reference>
      <div
        class="el-input el-input--large el-date-picker"
        style="width: 100%"
        :class="[
          size === 'large' ? 'el-input--large' : size === 'small' ? 'el-input--small' : '',
          disabled ? 'is-disabled' : ''
        ]"
      >
        <div class="el-input__wrapper" :tabindex="disabled ? -1 : 0">
          <input
            readonly
            :placeholder="showStartPlaceholder ? startPlaceholder : endPlaceholder"
            v-model="displayText"
            class="el-input__inner"
            :disabled="disabled"
          />
          <span class="el-input__suffix">
            <span class="el-input__suffix-inner">
              <el-icon class="el-input__icon"><Calendar /></el-icon>
            </span>
          </span>
        </div>
      </div>
    </template>
  </el-popover>
</template>

<script setup lang="ts">
  import { ref, computed, watch } from 'vue'
  import { ElMessage } from 'element-plus'
  import { ArrowLeft, ArrowRight, Calendar } from '@element-plus/icons-vue'

  const props = withDefaults(
    defineProps<{
      modelValue?: [string | Date, string | Date] | (string | Date)[]
      type?: 'monthrange'
      rangeSeparator?: string
      startPlaceholder?: string
      endPlaceholder?: string
      size?: 'default' | 'large' | 'small'
      disabled?: boolean
    }>(),
    {
      modelValue: () => ['', ''],
      type: 'monthrange',
      rangeSeparator: '至',
      startPlaceholder: '开始月份',
      endPlaceholder: '结束月份',
      size: 'default',
      disabled: false
    }
  )

  const emit = defineEmits<{
    'update:modelValue': [val: [string, string]]
    change: [val: [string, string]]
  }>()

  // 弹窗状态
  const pickerVisible = ref(false)

  // 当前展示年份
  const currentYear = ref(new Date().getFullYear())
  const minYear = ref(2020)
  const maxYear = ref(2030)

  // 临时选择（弹窗内）
  const tempStart = ref<number | null>(null)
  const tempEnd = ref<number | null>(null)

  // 真实选中
  const realStart = ref<string>('')
  const realEnd = ref<string>('')

  // 同步外部 v-model
  watch(
    () => props.modelValue,
    (val) => {
      if (!val || val.length !== 2) {
        realStart.value = ''
        realEnd.value = ''
        return
      }
      try {
        const [s, e] = val
        const sDate = new Date(s)
        const eDate = new Date(e)

        if (sDate.toString() !== 'Invalid Date') {
          realStart.value = `${sDate.getFullYear()}-${String(sDate.getMonth() + 1).padStart(2, '0')}`
        }
        if (eDate.toString() !== 'Invalid Date') {
          realEnd.value = `${eDate.getFullYear()}-${String(eDate.getMonth() + 1).padStart(2, '0')}`
        }
      } catch {
        /* empty */
      }
    },
    { immediate: true }
  )

  // 显示文字
  const displayText = computed(() => {
    if (!realStart.value || !realEnd.value) return ''
    return `${realStart.value} ${props.rangeSeparator} ${realEnd.value}`
  })

  // 占位符显示逻辑
  const showStartPlaceholder = computed(() => {
    return !realStart.value && !realEnd.value
  })

  // 打开弹窗时 只同步年份，不清空选择，允许重新选择
  const onPickerShow = () => {
    // 只同步年份到选中的开始年份
    if (realStart.value) {
      const y = +realStart.value.split('-')[0]
      currentYear.value = y
    }
    // ✅ 修复点：打开弹窗时，重置临时选择为 null，允许重新选开始月份
    tempStart.value = null
    tempEnd.value = null
  }

  // 月份样式
  const getMonthClass = (m: number) => {
    const isStart = tempStart.value === m
    const isEnd = tempEnd.value === m
    const inRange = tempStart.value && tempEnd.value && m >= tempStart.value && m <= tempEnd.value

    return {
      'is-active': isStart || isEnd,
      'is-in-range': inRange && !isStart && !isEnd,
      'is-start': isStart,
      'is-end': isEnd
    }
  }

  // ====================
  // 🔥 最终完美逻辑：单选 + 区间 双支持
  // ====================
  const selectMonth = (m: number) => {
    // 1. 还没选 → 设置开始，自动把结束也设为当前月（支持单选）
    if (tempStart.value === null) {
      tempStart.value = m
      tempEnd.value = m
    }
    // 2. 已经选了一个月 → 进入区间选择模式
    else {
      // 如果点击的是比开始小的月 → 重选区间
      if (m < tempStart.value) {
        tempEnd.value = tempStart.value
        tempStart.value = m
      }
      // 点击同一个月 → 保持单选
      else if (m === tempStart.value) {
        tempEnd.value = m
      }
      // 点击更大的月 → 正常区间
      else {
        tempEnd.value = m
      }
    }
  }

  // 确定：只要选了月份就能提交（单月/区间都支持）
  const confirm = () => {
    if (tempStart.value === null) {
      ElMessage.warning('请选择月份')
      return
    }

    const startMonth = tempStart.value!
    const endMonth = tempEnd.value ?? startMonth

    const start = `${currentYear.value}-${String(startMonth).padStart(2, '0')}`
    const end = `${currentYear.value}-${String(endMonth).padStart(2, '0')}`

    realStart.value = start
    realEnd.value = end

    emit('update:modelValue', [start, end])
    emit('change', [start, end])
    pickerVisible.value = false
  }
</script>

<style scoped>
  /* 基础面板 + 动画 */
  .month-range-picker {
    box-sizing: border-box;
    width: 280px;
    padding: 12px;
    animation: panel-fade 0.25s ease forwards;
  }

  @keyframes panel-fade {
    from {
      opacity: 0;
      transform: translateY(-6px);
    }

    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .month-range-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
  }

  /* 按钮平滑过渡 */
  .month-range-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    cursor: pointer;
    background: transparent;
    border: none;
    border-radius: 4px;
    transition: all 0.2s ease;
  }

  .month-range-btn:hover:not(:disabled) {
    background: var(--el-fill-color-light);
    transform: scale(1.05);
  }

  .month-range-btn:disabled {
    cursor: not-allowed;
    opacity: 0.6;
  }

  .month-range-year {
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s ease;
  }

  .month-range-body {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
    margin-bottom: 12px;
  }

  /* 月份卡片丝滑动画 */
  .month-cell {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 36px;
    font-size: 14px;
    cursor: pointer;
    border-radius: 4px;
    transition: all 0.22s cubic-bezier(0.25, 0.8, 0.25, 1);
  }

  .month-cell:hover {
    background: var(--el-fill-color-light);
    transform: scale(1.03);
  }

  .month-cell.is-active {
    color: #fff;
    background: var(--el-color-primary);
    transform: scale(0.96);
  }

  .month-cell.is-in-range {
    color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
  }

  .month-range-footer {
    display: flex;
    gap: 8px;
    justify-content: flex-end;
    padding-top: 8px;
    border-top: 1px solid var(--el-border-color-lighter);
    transition: all 0.2s ease;
  }

  /* 弹窗动画 */
  :deep(.fade-slide-enter-active),
  :deep(.fade-slide-leave-active) {
    transition: all 0.26s ease;
  }

  :deep(.fade-slide-enter-from) {
    opacity: 0;
    transform: translateY(-8px);
  }

  :deep(.fade-slide-leave-to) {
    opacity: 0;
    transform: translateY(4px);
  }
</style>
