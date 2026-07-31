<template>
  <div class="home-page">
    <section class="prototype-card welcome-panel">
      <div class="welcome-tag">
        <el-tag type="primary">
          培训原型
        </el-tag>
      </div>

      <h2>
        欢迎开始创建你的业务系统
      </h2>

      <p class="welcome-description">
        当前项目已经准备好基础前端环境，但尚未创建具体业务页面。
      </p>

      <el-alert
        title="第一课任务"
        type="info"
        :closable="false"
        show-icon
      >
        告诉Claude Code：系统名称、主要使用者、业务问题、首页内容和第一版操作。
      </el-alert>
    </section>

    <section class="guidance-grid">
      <article class="prototype-card guidance-card">
        <span class="guidance-number">01</span>
        <h3>系统叫什么</h3>
        <p>使用具体、清楚的业务名称，不使用“智能平台”等空泛名称。</p>
      </article>

      <article class="prototype-card guidance-card">
        <span class="guidance-number">02</span>
        <h3>谁会使用</h3>
        <p>说明主要角色，例如运营人员、渠道主管或部门负责人。</p>
      </article>

      <article class="prototype-card guidance-card">
        <span class="guidance-number">03</span>
        <h3>解决什么问题</h3>
        <p>先描述当前工作中的具体困难，不要直接要求实现复杂功能。</p>
      </article>

      <article class="prototype-card guidance-card">
        <span class="guidance-number">04</span>
        <h3>首页看到什么</h3>
        <p>列出最重要的信息、异常、任务以及用户要执行的第一个动作。</p>
      </article>
    </section>
  </div>
</template>

<script setup lang="ts">
defineOptions({
  name: 'HomePage'
})
</script>

<style scoped>
.home-page {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.welcome-panel {
  padding: 24px;
}

.welcome-tag {
  margin-bottom: 16px;
}

.welcome-panel h2 {
  margin: 0 0 8px;
  color: var(--art-text-primary);
  font-size: 24px;
  font-weight: 700;
  line-height: 1.5;
}

.welcome-description {
  margin: 0 0 24px;
  color: var(--art-text-secondary);
  font-size: 14px;
  line-height: 1.75;
}

.guidance-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.guidance-card {
  min-height: 168px;
  padding: 16px;
}

.guidance-number {
  color: var(--art-primary);
  font-size: 12px;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
}

.guidance-card h3 {
  margin: 16px 0 8px;
  color: var(--art-text-primary);
  font-size: 14px;
  font-weight: 600;
  line-height: 1.5;
}

.guidance-card p {
  margin: 0;
  color: var(--art-text-secondary);
  font-size: 12px;
  line-height: 1.75;
}

@media (width <= 1024px) {
  .guidance-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (width <= 640px) {
  .welcome-panel {
    padding: 16px;
  }

  .welcome-panel h2 {
    font-size: 24px;
  }

  .guidance-grid {
    grid-template-columns: 1fr;
  }

  .guidance-card {
    min-height: auto;
  }
}
</style>

