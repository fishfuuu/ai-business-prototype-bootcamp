<template>
  <section class="data-table-card">
    <div
      v-if="title || description || $slots.actions"
      class="data-table-header"
    >
      <div>
        <h2 v-if="title">
          {{ title }}
        </h2>

        <p v-if="description">
          {{ description }}
        </p>
      </div>

      <div
        v-if="$slots.actions"
        class="data-table-actions"
      >
        <slot name="actions" />
      </div>
    </div>

    <el-table
      :data="rows"
      :loading="loading"
      :height="height"
      stripe
      table-layout="fixed"
      style="width: 100%"
    >
      <el-table-column
        v-for="column in columns"
        :key="column.prop"
        :prop="column.prop"
        :label="column.label"
        :width="column.width"
        :min-width="column.minWidth"
        :align="column.align || 'left'"
      >
        <template #default="{ row }">
          <StatusTag
            v-if="column.type === 'status'"
            :status="normalizeStatus(row[column.prop])"
          />

          <span
            v-else
            :class="{
              'financial-value':
                column.type === 'number' ||
                column.type === 'currency' ||
                column.type === 'percent'
            }"
          >
            {{ formatCell(row[column.prop], column.type) }}
          </span>
        </template>
      </el-table-column>

      <template #empty>
        <ArtEmptyState :description="emptyText" />
      </template>
    </el-table>
  </section>
</template>

<script setup lang="ts">
import ArtEmptyState from '@/components/business/ArtEmptyState.vue'
import StatusTag from '@/components/business/StatusTag.vue'

type ColumnType =
  | 'text'
  | 'number'
  | 'currency'
  | 'percent'
  | 'status'

type StatusType =
  | 'neutral'
  | 'info'
  | 'success'
  | 'warning'
  | 'danger'

interface TableColumn {
  prop: string
  label: string
  type?: ColumnType
  width?: number | string
  minWidth?: number | string
  align?: 'left' | 'center' | 'right'
}

interface Props {
  title?: string
  description?: string
  columns: TableColumn[]
  rows: Record<string, unknown>[]
  loading?: boolean
  emptyText?: string
  height?: number | string
}

withDefaults(defineProps<Props>(), {
  title: '',
  description: '',
  loading: false,
  emptyText: '暂无数据',
  height: undefined
})

const allowedStatuses: StatusType[] = [
  'neutral',
  'info',
  'success',
  'warning',
  'danger'
]

function normalizeStatus(value: unknown): StatusType {
  if (
    typeof value === 'string' &&
    allowedStatuses.includes(value as StatusType)
  ) {
    return value as StatusType
  }

  return 'neutral'
}

function toSafeNumber(value: unknown): number | null {
  const numberValue = Number(value)

  return Number.isFinite(numberValue)
    ? numberValue
    : null
}

function formatCell(
  value: unknown,
  type: ColumnType = 'text'
): string {
  if (value === null || value === undefined || value === '') {
    return '--'
  }

  if (type === 'number') {
    const numberValue = toSafeNumber(value)
    return numberValue === null
      ? String(value)
      : numberValue.toLocaleString('zh-CN')
  }

  if (type === 'currency') {
    const numberValue = toSafeNumber(value)

    if (numberValue === null) {
      return String(value)
    }

    return new Intl.NumberFormat('zh-CN', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2
    }).format(numberValue)
  }

  if (type === 'percent') {
    const numberValue = toSafeNumber(value)
    return numberValue === null
      ? String(value)
      : `${numberValue.toFixed(1)}%`
  }

  return String(value)
}
</script>

<style scoped>
.data-table-card {
  overflow: hidden;
  border: 1px solid var(--art-border-card);
  border-radius: var(--art-radius-card);
  background: var(--art-card-bg);
  box-shadow: var(--art-shadow-panel);
}

.data-table-header {
  display: flex;
  min-height: 64px;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 16px;
  border-bottom: 1px solid var(--art-border-default);
}

.data-table-header h2 {
  margin: 0;
  color: var(--art-text-primary);
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
}

.data-table-header p {
  margin: 8px 0 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.data-table-actions {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  gap: 8px;
}

:deep(.el-table) {
  --el-table-border-color: var(--art-border-default);
  --el-table-header-bg-color: var(--art-gray-50);
  --el-table-row-hover-bg-color: color-mix(
    in oklch,
    var(--art-primary) 4%,
    var(--art-card-bg)
  );
  --el-table-text-color: var(--art-text-primary);
  --el-table-header-text-color: var(--art-text-secondary);
}

:deep(.el-table th.el-table__cell) {
  height: 44px;
  padding: 8px 0;
  color: var(--art-text-secondary);
  font-size: 14px;
  font-weight: 600;
}

:deep(.el-table td.el-table__cell) {
  height: 44px;
  padding: 8px 0;
  color: var(--art-text-primary);
  font-size: 14px;
}

:deep(.el-table .cell) {
  line-height: 1.5;
}

:deep(.el-table__empty-block) {
  min-height: 180px;
}

@media (width <= 640px) {
  .data-table-header {
    align-items: flex-start;
    flex-direction: column;
  }

  .data-table-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style>

