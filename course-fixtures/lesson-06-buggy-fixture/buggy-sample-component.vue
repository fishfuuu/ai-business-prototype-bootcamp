<template>
  <div class="buggy-sandbox">
    <h3>第 6 课故障沙箱演练组件</h3>
    
    <!-- 场景 B: 筛选按钮未更新 filteredData -->
    <div class="filter-bar">
      <input v-model="searchKey" placeholder="输入搜索关键词..." />
      <button @click="handleFilter">执行筛选</button>
    </div>

    <!-- 数据列表 -->
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>名称</th>
          <th>状态 (场景A)</th>
          <th>操作人 (场景C)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in filteredList" :key="item.id">
          <td>{{ item.id }}</td>
          <td>{{ item.name }}</td>
          <!-- 故障 1：契约字段写错为 status_name (契约定义为 status) -->
          <td><span class="badge">{{ item.status_name }}</span></td>
          <!-- 故障 2：未防护 null 空指针风险 (operator 可能为 null) -->
          <td>{{ item.operator.toUpperCase() }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const searchKey = ref('')
const originalList = ref([
  { id: 1, name: '订单 001', status: 'COMPLETED', operator: 'admin' },
  // 故障数据源：operator 故意设为 null
  { id: 2, name: '订单 002', status: 'PENDING', operator: null }
])

const filteredList = ref([...originalList.value])

function handleFilter() {
  // 故障 3：漏掉了数据过滤与响应式更新逻辑，点击无效果
  console.log('Filter clicked, key:', searchKey.value)
}
</script>
