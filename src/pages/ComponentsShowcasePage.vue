<template>
  <div class="showcase-page">
    <section class="showcase-intro prototype-card">
      <div>
        <el-tag
          type="info"
          effect="plain"
        >
          Component Showcase
        </el-tag>

        <h2>通用组件展示</h2>

        <p>
          本页面只用于验证培训底座中的通用组件，不代表任何具体业务系统。
        </p>
      </div>

      <StatusTag
        status="success"
        label="组件已挂载"
      />
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>01</span>

        <div>
          <h2>指标卡片</h2>
          <p>验证不同状态、单位、说明和趋势展示。</p>
        </div>
      </div>

      <div class="kpi-grid">
        <KpiCard
          title="示例指标 A"
          :value="1280"
          unit="项"
          description="普通状态示例"
          :trend="0"
          status="neutral"
        />

        <KpiCard
          title="示例指标 B"
          :value="856"
          unit="项"
          description="正向状态示例"
          :trend="12.6"
          status="success"
        />

        <KpiCard
          title="示例指标 C"
          value="74.5%"
          description="关注状态示例"
          :trend="-3.2"
          status="warning"
        />

        <KpiCard
          title="示例指标 D"
          :value="23"
          unit="项"
          description="风险状态示例"
          :trend="-18.4"
          status="danger"
        />
      </div>
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>02</span>

        <div>
          <h2>筛选组件</h2>
          <p>筛选字段由页面提供，FilterPanel只负责布局。</p>
        </div>
      </div>

      <FilterPanel
        title="示例筛选条件"
        description="以下内容不会请求接口，只用于验证控件和插槽。"
      >
        <div class="filter-field">
          <label>关键词</label>

          <el-input
            v-model="keyword"
            placeholder="输入示例关键词"
            clearable
          />
        </div>

        <div class="filter-field">
          <label>示例分类</label>

          <el-select
            v-model="selectedGroup"
            placeholder="请选择"
            clearable
          >
            <el-option
              label="示例分类 A"
              value="group-a"
            />

            <el-option
              label="示例分类 B"
              value="group-b"
            />

            <el-option
              label="示例分类 C"
              value="group-c"
            />
          </el-select>
        </div>

        <div class="filter-field filter-field-wide">
          <label>月份区间</label>

          <MonthRangePicker
            v-model="monthRange"
            size="large"
            start-placeholder="选择月份"
            @change="handleMonthChange"
          />
        </div>

        <template #actions>
          <el-button @click="handleReset">
            重置
          </el-button>

          <el-button
            type="primary"
            @click="handleQuery"
          >
            应用条件
          </el-button>
        </template>
      </FilterPanel>

      <p class="action-result">
        最近操作：{{ lastAction }}
      </p>
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>03</span>

        <div>
          <h2>状态标签</h2>
          <p>验证五类通用状态及自定义文字。</p>
        </div>
      </div>

      <div class="status-list prototype-card">
        <StatusTag status="neutral" />
        <StatusTag status="info" />
        <StatusTag status="success" />
        <StatusTag status="warning" />
        <StatusTag status="danger" />

        <StatusTag
          status="info"
          label="自定义状态"
        />
      </div>
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>04</span>

        <div>
          <h2>通用表格</h2>
          <p>验证文本、数字、金额、百分比和状态列。</p>
        </div>
      </div>

      <DataTable
        title="示例数据表"
        description="所有数据均为组件展示使用的虚构数据。"
        :columns="tableColumns"
        :rows="showEmptyTable ? [] : tableRows"
        :loading="tableLoading"
        empty-text="当前没有可展示的示例记录"
      >
        <template #actions>
          <el-button
            size="small"
            @click="showEmptyTable = !showEmptyTable"
          >
            {{ showEmptyTable ? '恢复示例数据' : '测试空状态' }}
          </el-button>

          <el-button
            size="small"
            @click="toggleTableLoading"
          >
            测试加载状态
          </el-button>
        </template>
      </DataTable>
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>05</span>

        <div>
          <h2>通用图表</h2>
          <p>验证折线图、柱状图和环形图的初始化及响应式调整。</p>
        </div>
      </div>

      <div class="chart-grid">
        <SimpleLineChart
          title="折线图示例"
          description="两组连续示例数据"
          :x-data="chartCategories"
          :series="lineSeries"
        />

        <SimpleBarChart
          title="柱状图示例"
          description="两组分类对比数据"
          :x-data="chartCategories"
          :series="barSeries"
        />

        <SimplePieChart
          title="环形图示例"
          description="四组构成示例数据"
          :data="pieData"
        />
      </div>
    </section>

    <section class="showcase-section">
      <div class="section-heading">
        <span>06</span>

        <div>
          <h2>独立空状态</h2>
          <p>验证ArtEmptyState可以脱离表格单独使用。</p>
        </div>
      </div>

      <div class="prototype-card empty-state-panel">
        <ArtEmptyState
          description="这里暂时没有内容"
          action-text="执行示例操作"
          @action="handleEmptyAction"
        />
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import {
  ref,
  type Ref
} from 'vue'

import { ElMessage } from 'element-plus'

import ArtEmptyState from '@/components/business/ArtEmptyState.vue'
import DataTable from '@/components/business/DataTable.vue'
import FilterPanel from '@/components/business/FilterPanel.vue'
import KpiCard from '@/components/business/KpiCard.vue'
import StatusTag from '@/components/business/StatusTag.vue'
import MonthRangePicker from '@/components/MonthRangePicker/index.vue'

import SimpleBarChart from '@/components/charts/SimpleBarChart.vue'
import SimpleLineChart from '@/components/charts/SimpleLineChart.vue'
import SimplePieChart from '@/components/charts/SimplePieChart.vue'

defineOptions({
  name: 'ComponentsShowcasePage'
})

type ColumnType =
  | 'text'
  | 'number'
  | 'currency'
  | 'percent'
  | 'status'

interface ShowcaseColumn {
  prop: string
  label: string
  type?: ColumnType
  width?: number | string
  minWidth?: number | string
  align?: 'left' | 'center' | 'right'
}

const keyword = ref('')
const selectedGroup = ref('')
const monthRange: Ref<(string | Date)[]> = ref([
  '2026-01',
  '2026-03'
])

const lastAction = ref('尚未执行操作')

const showEmptyTable = ref(false)
const tableLoading = ref(false)

const tableColumns: ShowcaseColumn[] = [
  {
    prop: 'name',
    label: '示例名称',
    type: 'text',
    minWidth: 150
  },
  {
    prop: 'quantity',
    label: '数量',
    type: 'number',
    minWidth: 100,
    align: 'right'
  },
  {
    prop: 'amount',
    label: '金额格式',
    type: 'currency',
    minWidth: 140,
    align: 'right'
  },
  {
    prop: 'progress',
    label: '百分比',
    type: 'percent',
    minWidth: 110,
    align: 'right'
  },
  {
    prop: 'status',
    label: '状态',
    type: 'status',
    minWidth: 110,
    align: 'center'
  }
]

const tableRows: Record<string, unknown>[] = [
  {
    name: '示例记录 A',
    quantity: 128,
    amount: 46800,
    progress: 82.5,
    status: 'success'
  },
  {
    name: '示例记录 B',
    quantity: 76,
    amount: 23500,
    progress: 61.2,
    status: 'warning'
  },
  {
    name: '示例记录 C',
    quantity: 34,
    amount: 12800,
    progress: 38.4,
    status: 'danger'
  },
  {
    name: '示例记录 D',
    quantity: 95,
    amount: 31200,
    progress: 70,
    status: 'info'
  }
]

const chartCategories = [
  '阶段一',
  '阶段二',
  '阶段三',
  '阶段四',
  '阶段五',
  '阶段六'
]

const lineSeries = [
  {
    name: '示例序列 A',
    data: [12, 18, 16, 25, 29, 36]
  },
  {
    name: '示例序列 B',
    data: [8, 11, 19, 17, 24, 28]
  }
]

const barSeries = [
  {
    name: '示例序列 A',
    data: [24, 18, 31, 27, 35, 42]
  },
  {
    name: '示例序列 B',
    data: [16, 22, 20, 30, 26, 34]
  }
]

const pieData = [
  {
    name: '示例分类 A',
    value: 36
  },
  {
    name: '示例分类 B',
    value: 28
  },
  {
    name: '示例分类 C',
    value: 22
  },
  {
    name: '示例分类 D',
    value: 14
  }
]

function handleMonthChange(value: [string, string]) {
  lastAction.value = `月份已调整为 ${value[0]} 至 ${value[1]}`
}

function handleReset() {
  keyword.value = ''
  selectedGroup.value = ''
  monthRange.value = ['2026-01', '2026-03']
  lastAction.value = '已重置示例条件'
}

function handleQuery() {
  lastAction.value = '已应用当前示例条件'
  ElMessage.success('示例条件已应用，本页面不会请求接口')
}

function toggleTableLoading() {
  tableLoading.value = true

  window.setTimeout(() => {
    tableLoading.value = false
  }, 800)
}

function handleEmptyAction() {
  ElMessage.info('已触发空状态示例操作')
}
</script>

<style scoped>
.showcase-page {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.showcase-intro {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 24px;
  padding: 24px;
}

.showcase-intro h2 {
  margin: 16px 0 8px;
  color: var(--art-text-primary);
  font-size: 24px;
  font-weight: 700;
  line-height: 1.5;
}

.showcase-intro p {
  margin: 0;
  color: var(--art-text-secondary);
  font-size: 14px;
  line-height: 1.75;
}

.showcase-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.section-heading {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.section-heading > span {
  padding-top: 4px;
  color: var(--art-primary);
  font-size: 12px;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
}

.section-heading h2 {
  margin: 0;
  color: var(--art-text-primary);
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
}

.section-heading p {
  margin: 8px 0 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.kpi-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.filter-field {
  display: flex;
  width: 192px;
  flex-direction: column;
  gap: 8px;
}

.filter-field-wide {
  width: 256px;
}

.filter-field label {
  color: var(--art-text-primary);
  font-size: 14px;
  font-weight: 600;
  line-height: 1.5;
}

.action-result {
  margin: -8px 0 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.5;
}

.status-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  padding: 24px;
}

.chart-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.chart-grid > :last-child {
  grid-column: span 2;
}

.empty-state-panel {
  padding: 24px;
}

@media (width <= 1024px) {
  .kpi-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .chart-grid {
    grid-template-columns: 1fr;
  }

  .chart-grid > :last-child {
    grid-column: auto;
  }
}

@media (width <= 640px) {
  .showcase-intro {
    flex-direction: column;
    padding: 16px;
  }

  .kpi-grid {
    grid-template-columns: 1fr;
  }

  .filter-field,
  .filter-field-wide {
    width: 100%;
  }

  .status-list,
  .empty-state-panel {
    padding: 16px;
  }
}
</style>

