<template>
  <header class="app-header">
    <div>
      <p class="header-eyebrow">
        AI BUSINESS PROTOTYPE
      </p>

      <h1 class="header-title">
        {{ pageTitle }}
      </h1>
    </div>

    <el-tag
      type="info"
      effect="plain"
      round
    >
      培训原型 · 模拟数据
    </el-tag>
  </header>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

defineOptions({
  name: 'AppHeader'
})

const route = useRoute()

const pageTitle = computed(() => {
  return String(route.meta.title || '企业业务原型')
})
</script>

<style scoped>
/*
 * 视觉对齐正式 header（h-15 ≈ 60px）：
 * - 背景 --art-card-bg，边框 --art-border-card
 * - 标题 18px / 辅助 12px
 * - 保留 sticky；不复制搜索/通知/用户逻辑
 */
.app-header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  min-height: 60px;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 0 20px;
  border-bottom: 1px solid var(--art-border-card);
  background: var(--art-card-bg);
}

.header-eyebrow {
  margin: 0 0 2px;
  color: var(--art-primary);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.08em;
}

.header-title {
  margin: 0;
  color: var(--art-text-primary);
  font-size: 18px;
  font-weight: 600;
  line-height: 1.3;
}

@media (width <= 640px) {
  .app-header {
    position: static;
    min-height: 56px;
    padding: 0 16px;
  }

  .header-title {
    font-size: 18px;
  }
}
</style>


