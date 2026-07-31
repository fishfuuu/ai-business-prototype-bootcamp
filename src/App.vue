<template>
  <ElConfigProvider
    :locale="zhCn"
    size="default"
    :z-index="3000"
  >
    <RouterView />
  </ElConfigProvider>
</template>

<script setup lang="ts">
import zhCn from 'element-plus/es/locale/lang/zh-cn'
</script>