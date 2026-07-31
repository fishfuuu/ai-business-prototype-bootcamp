<template>
  <section
    class="filter-panel"
    :class="{ 'filter-panel-sticky': sticky }"
  >
    <div
      v-if="title || description"
      class="filter-panel-heading"
    >
      <div>
        <h2 v-if="title">
          {{ title }}
        </h2>

        <p v-if="description">
          {{ description }}
        </p>
      </div>
    </div>

    <div class="filter-panel-content">
      <div class="filter-fields">
        <slot />
      </div>

      <div
        v-if="$slots.actions"
        class="filter-actions"
      >
        <slot name="actions" />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
interface Props {
  title?: string
  description?: string
  sticky?: boolean
}

withDefaults(defineProps<Props>(), {
  title: '',
  description: '',
  sticky: false
})

defineOptions({
  name: 'FilterPanel'
})
</script>

<style scoped>
.filter-panel {
  padding: 16px;
  border: 1px solid var(--art-border-card);
  border-radius: var(--art-radius-panel);
  background: var(--art-card-bg);
  box-shadow: var(--art-shadow-panel);
}

.filter-panel-sticky {
  position: sticky;
  top: 92px;
  z-index: 10;
}

.filter-panel-heading {
  margin-bottom: 16px;
}

.filter-panel-heading h2 {
  margin: 0;
  color: var(--art-text-primary);
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
}

.filter-panel-heading p {
  margin: 8px 0 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.filter-panel-content {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
}

.filter-fields {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-wrap: wrap;
  align-items: flex-end;
  gap: 12px;
}

.filter-actions {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  gap: 8px;
}

:deep(.el-input__wrapper),
:deep(.el-select__wrapper) {
  min-height: 40px;
  border-radius: var(--art-radius-control);
}

:deep(.el-button) {
  min-height: 40px;
  border-radius: var(--art-radius-control);
}

@media (width <= 640px) {
  .filter-panel-sticky {
    position: static;
  }

  .filter-panel-content {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-fields,
  .filter-actions {
    width: 100%;
  }

  .filter-fields {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-actions {
    justify-content: flex-end;
  }
}
</style>

