<template>
  <span
    class="status-tag"
    :class="config.className"
  >
    <span
      class="status-dot"
      aria-hidden="true"
    ></span>

    {{ label || config.label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

type StatusType =
  | 'neutral'
  | 'info'
  | 'success'
  | 'warning'
  | 'danger'

interface Props {
  status?: StatusType
  label?: string
}

const props = withDefaults(defineProps<Props>(), {
  status: 'neutral',
  label: ''
})

const configs: Record<
  StatusType,
  {
    label: string
    className: string
  }
> = {
  neutral: {
    label: '未开始',
    className: 'status-neutral'
  },
  info: {
    label: '进行中',
    className: 'status-info'
  },
  success: {
    label: '已完成',
    className: 'status-success'
  },
  warning: {
    label: '需关注',
    className: 'status-warning'
  },
  danger: {
    label: '有风险',
    className: 'status-danger'
  }
}

const config = computed(() => configs[props.status])
</script>

<style scoped>
.status-tag {
  display: inline-flex;
  min-height: 24px;
  align-items: center;
  gap: 8px;
  padding: 4px 8px;
  border: 1px solid transparent;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  line-height: 1;
  white-space: nowrap;
}

.status-dot {
  width: 6px;
  height: 6px;
  flex-shrink: 0;
  border-radius: 50%;
  background: currentColor;
}

.status-neutral {
  border-color: var(--art-border-default);
  color: var(--art-text-secondary);
  background: var(--art-gray-50);
}

.status-info {
  border-color: color-mix(
    in oklch,
    var(--art-primary) 24%,
    var(--art-card-bg)
  );
  color: var(--art-primary);
  background: color-mix(
    in oklch,
    var(--art-primary) 8%,
    var(--art-card-bg)
  );
}

.status-success {
  border-color: color-mix(
    in srgb,
    var(--art-success) 24%,
    var(--art-card-bg)
  );
  color: var(--art-success);
  background: color-mix(
    in srgb,
    var(--art-success) 8%,
    var(--art-card-bg)
  );
}

.status-warning {
  border-color: color-mix(
    in srgb,
    var(--art-warning) 28%,
    var(--art-card-bg)
  );
  color: var(--art-warning);
  background: color-mix(
    in srgb,
    var(--art-warning) 9%,
    var(--art-card-bg)
  );
}

.status-danger {
  border-color: color-mix(
    in srgb,
    var(--art-danger) 24%,
    var(--art-card-bg)
  );
  color: var(--art-danger);
  background: color-mix(
    in srgb,
    var(--art-danger) 8%,
    var(--art-card-bg)
  );
}
</style>

