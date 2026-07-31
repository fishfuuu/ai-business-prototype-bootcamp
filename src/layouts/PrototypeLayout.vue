<template>
  <div class="prototype-layout">
    <AppSidebar />

    <div class="layout-main">
      <AppHeader />

      <PageContainer>
        <RouterView />
      </PageContainer>
    </div>
  </div>
</template>

<script setup lang="ts">
import AppHeader from '@/components/layout/AppHeader.vue'
import AppSidebar from '@/components/layout/AppSidebar.vue'
import PageContainer from '@/components/layout/PageContainer.vue'

defineOptions({
  name: 'PrototypeLayout'
})
</script>

<style scoped>
/*
 * 对齐正式 .app-layout 背景与主区结构；
 * 不增加标签页/全局设置区域
 */
.prototype-layout {
  display: flex;
  width: 100%;
  min-height: 100vh;
  background: var(--art-page-bg);
}

.layout-main {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  min-height: 100vh;
  overflow: auto;
}

@media (width <= 640px) {
  .prototype-layout {
    flex-direction: column;
  }

  .layout-main {
    min-width: 0;
    min-height: auto;
    overflow: visible;
  }
}
</style>
