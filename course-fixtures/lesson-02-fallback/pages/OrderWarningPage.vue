<template>
  <div class="order-warning-page">
    <div class="header-section">
      <h2>供应商履约预警工作台 (第二课备用美化起点)</h2>
      <p class="subtitle">使用者：采购主管 | 状态：模拟数据未排版基线</p>
    </div>

    <!-- 粗糙 KPI 区域 -->
    <div class="kpi-area">
      <div class="kpi-box red">
        <span>超时未交货采购单: 14 笔</span>
      </div>
      <div class="kpi-box amber">
        <span>高风险供应商数: 5 家</span>
      </div>
      <div class="kpi-box green">
        <span>本周按时履约率: 92.4%</span>
      </div>
    </div>

    <!-- 粗糙表格与筛选区域 -->
    <div class="table-area">
      <div class="filter-row">
        <label>状态筛选：</label>
        <select v-model="selectedStatus">
          <option value="">全部状态</option>
          <option value="OVERDUE">严重超时</option>
          <option value="WARNING">预警跟进</option>
        </select>
        <input type="text" v-model="searchKey" placeholder="搜索供应商..." />
      </div>

      <table class="raw-table">
        <thead>
          <tr>
            <th>采购单号</th>
            <th>供应商名称</th>
            <th>应交货日期</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in filteredList" :key="row.id">
            <td>{{ row.code }}</td>
            <td>{{ row.supplier }}</td>
            <td>{{ row.dueDate }}</td>
            <td>
              <span :class="['raw-tag', row.status.toLowerCase()]">
                {{ row.statusText }}
              </span>
            </td>
            <td>
              <button class="raw-btn" @click="handleRemind(row)">发送催单提醒</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const selectedStatus = ref('')
const searchKey = ref('')

const rawList = ref([
  { id: 1, code: 'PO-2026-0801', supplier: '华南电子器件厂', dueDate: '2026-07-30', status: 'OVERDUE', statusText: '严重超时' },
  { id: 2, code: 'PO-2026-0805', supplier: '极速物流有限公司', dueDate: '2026-08-02', status: 'WARNING', statusText: '预警跟进' },
  { id: 3, code: 'PO-2026-0809', supplier: '联创精密机械', dueDate: '2026-08-04', status: 'OVERDUE', statusText: '严重超时' }
])

const filteredList = computed(() => {
  return rawList.value.filter(item => {
    const matchStatus = !selectedStatus.value || item.status === selectedStatus.value
    const matchKey = !searchKey.value || item.supplier.includes(searchKey.value)
    return matchStatus && matchKey
  })
})

function handleRemind(row: any) {
  alert(`已向供应商【${row.supplier}】发送催单提醒！`)
}
</script>

<style scoped>
.order-warning-page {
  padding: 20px;
}
.header-section {
  margin-bottom: 20px;
}
.subtitle {
  color: #666;
  font-size: 14px;
}
.kpi-area {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}
.kpi-box {
  padding: 15px 20px;
  border-radius: 4px;
  font-weight: bold;
}
.kpi-box.red { background: #fee2e2; color: #dc2626; }
.kpi-box.amber { background: #fef3c7; color: #d97706; }
.kpi-box.green { background: #d1fae5; color: #059669; }

.table-area {
  background: #fff;
  padding: 15px;
  border: 1px solid #e2e8f0;
}
.filter-row {
  margin-bottom: 15px;
  display: flex;
  gap: 10px;
  align-items: center;
}
.raw-table {
  width: 100%;
  border-collapse: collapse;
}
.raw-table th, .raw-table td {
  border: 1px solid #e2e8f0;
  padding: 10px;
  text-align: left;
}
.raw-tag {
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 12px;
}
.raw-tag.overdue { background: #fee2e2; color: #dc2626; }
.raw-tag.warning { background: #fef3c7; color: #d97706; }
.raw-btn {
  background: #2563eb;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 3px;
  cursor: pointer;
}
</style>
