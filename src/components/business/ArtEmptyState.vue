<template>
  <div class="art-empty-state flex items-center justify-center py-12">
    <el-empty :description="description" :image-size="120">
      <template v-if="$slots.image" #image>
        <slot name="image" />
      </template>
      <template v-if="actionText" #default>
        <el-button type="primary" @click="$emit('action')">
          {{ actionText }}
        </el-button>
      </template>
    </el-empty>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: 'ArtEmptyState' })

interface Props {
  description?: string
  actionText?: string
}

withDefaults(defineProps<Props>(), {
  description: '暂无数据',
  actionText: ''
})

defineEmits<{
  action: []
}>()
</script>

<style scoped>
.art-empty-state {
  animation: empty-fade-in 0.5s ease-out both;
}
@keyframes empty-fade-in {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
