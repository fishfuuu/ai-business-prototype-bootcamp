<template>
  <div class="order-warning-page">
    <header class="page-header">
      <div class="header-content">
        <h1>供应商履约超时预警台 (粗糙雏形)</h1>
        <p class="subtitle">第一课创建的原型雏形页面 - 待第二课视觉美化与结构重构</p>
      </div>
      <div class="header-actions">
        <el-button type="danger" @click="handleBatchRemind">批量催单提醒</el-button>
      </div>
    </header>

    <section class="kpi-section">
      <div class="kpi-card danger">
        <span class="kpi-label">严重超时订单</span>
        <span class="kpi-value">12</span>
        <span class="kpi-trend">需立即处理</span>
      </div>
      <div class="kpi-card warning">
        <span class="kpi-label">即将到期订单</span>
        <span class="kpi-value">28</span>
        <span class="kpi-trend">未来24h到期</span>
      </div>
      <div class="kpi-card normal">
        <span class="kpi-label">正常履约率</span>
        <span class="kpi-value">94.2%</span>
        <span class="kpi-trend">本周目标 95%</span>
      </div>
    </section>

    <section class="table-section">
      <h2>履约风险订单明细 (Mock Data)</h2>
      <el-table :data="tableData" border style="width: 100%">
        <el-table-column prop="orderNo" label="采购单号" width="140" />
        <el-table-column prop="supplier" label="供应商名称" min-width="160" />
        <el-table-column prop="promisedDate" label="承诺交货日期" width="130" />
        <el-table-column prop="delayDays" label="延期天数" width="100">
          <template #default="scope">
            <el-tag :type="(scope.row as WarningRecord).delayDays > 3 ? 'danger' : 'warning'">
              延期 {{ (scope.row as WarningRecord).delayDays }} 天
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="当前状态" width="120" />
        <el-table-column label="操作" width="140">
          <template #default="scope">
            <el-button size="small" type="primary" link @click="handleRemind(scope.row as WarningRecord)">
              发送催单
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

defineOptions({
  name: 'OrderWarningPage'
})

interface WarningRecord {
  id: string
  orderNo: string
  supplier: string
  promisedDate: string
  delayDays: number
  status: string
}

const tableData = ref<WarningRecord[]>([
  { id: '1', orderNo: 'PO-20260801-01', supplier: '华东精密电子有限公司', promisedDate: '2026-07-28', delayDays: 5, status: '严重超时' },
  { id: '2', orderNo: 'PO-20260801-04', supplier: '南方金属塑料制品厂', promisedDate: '2026-07-30', delayDays: 3, status: '轻度延期' },
  { id: '3', orderNo: 'PO-20260801-09', supplier: '博元智能包装科技', promisedDate: '2026-07-31', delayDays: 2, status: '轻度延期' },
  { id: '4', orderNo: 'PO-20260802-02', supplier: '极光传感器制造部', promisedDate: '2026-08-01', delayDays: 1, status: '即将超期' }
])

const handleRemind = (row: WarningRecord) => {
  ElMessage.success(`已向供应商【${row.supplier}】发送催单提醒！`)
}

const handleBatchRemind = () => {
  ElMessage.success('已批量向所有超时供应商发送催单提醒通知！')
}
</script>

<style scoped>
.order-warning-page {
  padding: 24px;
}
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.kpi-section {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}
.kpi-card {
  padding: 16px;
  border-radius: var(--art-radius-panel);
  background: var(--art-card-bg);
  border: 1px solid var(--art-border-card);

  display: flex;
  flex-direction: column;
}
.kpi-value {
  font-size: 28px;
  font-weight: 700;
  margin: 8px 0;
}
.table-section {
  background: var(--art-card-bg);
  padding: 20px;
  border-radius: var(--art-radius-panel);
  border: 1px solid var(--art-border-card);
}
</style>
