<template>
  <div class="page-container">
    <slot />
  </div>
</template>

<script setup lang="ts">
defineOptions({
  name: 'PageContainer'
})
</script>

<style scoped>
/*
 * DESIGN 间距：桌面 p-6(24px)，移动 p-4(16px)
 * 最大宽度保持 1440px；无卡片背景/阴影
 */
.page-container {
  box-sizing: border-box;
  width: 100%;
  max-width: 1440px;
  margin: 0 auto;
  padding: 24px 24px 24px;
  background: transparent;
}

@media (width <= 640px) {
  .page-container {
    padding: 16px 16px 24px;
  }
}
</style>


