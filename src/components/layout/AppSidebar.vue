<template>
  <aside class="app-sidebar">
    <div class="sidebar-brand">
      <div class="brand-mark">
        AI
      </div>

      <div class="brand-copy">
        <strong>业务原型训练营</strong>
        <span>Prototype Workspace</span>
      </div>
    </div>

    <nav
      class="sidebar-nav"
      aria-label="系统导航"
    >
      <RouterLink
        :to="{ name: 'Home' }"
        class="nav-item"
        exact-active-class="nav-item-active"
      >
        <span class="nav-index">01</span>
        <span>开始创建</span>
      </RouterLink>

      <RouterLink
        :to="{ name: 'ComponentsShowcase' }"
        class="nav-item"
        exact-active-class="nav-item-active"
      >
        <span class="nav-index">02</span>
        <span>组件展示</span>
      </RouterLink>
    </nav>

    <div class="sidebar-note">
      <span class="note-dot"></span>
      <span>当前使用模拟环境</span>
    </div>
  </aside>
</template>

<script setup lang="ts">
defineOptions({
  name: 'AppSidebar'
})
</script>

<style scoped>
/*
 * 视觉对齐正式侧栏（只读提取，不复制组件逻辑）：
 * - 默认展开宽度：setting 默认 menuOpenWidth = 230
 * - 菜单项高 42px、字号 14px、圆角 6px（theme.scss）
 * - 悬停底：--art-gray-200；选中：primary + light 浅底（正式为 --el-color-primary-light-9）
 * - 选中浅底用 color-mix(oklch) 映射，避免依赖 EP 运行时变量与硬编码蓝
 */
.app-sidebar {
  position: sticky;
  top: 0;
  display: flex;
  width: 230px;
  height: 100vh;
  flex-shrink: 0;
  flex-direction: column;
  border-right: 1px solid var(--art-border-card);
  background: var(--art-card-bg);
}

.sidebar-brand {
  display: flex;
  min-height: 60px;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border-bottom: 1px solid var(--art-border-card);
}

.brand-mark {
  display: flex;
  width: 36px;
  height: 36px;
  flex-shrink: 0;
  align-items: center;
  justify-content: center;
  border-radius: var(--art-radius-control);
  color: var(--art-card-bg);
  background: var(--art-primary);
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.brand-copy {
  display: flex;
  min-width: 0;
  flex-direction: column;
}

.brand-copy strong {
  overflow: hidden;
  color: var(--art-text-primary);
  font-size: 14px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.brand-copy span {
  margin-top: 2px;
  color: var(--art-text-secondary);
  font-size: 12px;
}

.sidebar-nav {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 4px;
  padding: 12px 8px;
}

.nav-item {
  display: flex;
  width: calc(100% - 16px);
  min-height: 42px;
  margin-left: 8px;
  align-items: center;
  gap: 12px;
  padding: 0 12px;
  border-radius: var(--art-radius-control);
  color: var(--art-text-secondary);
  font-size: 14px;
  font-weight: 400;
  text-decoration: none;
  transition:
    color 0.2s ease,
    background-color 0.2s ease;
}

.nav-item:hover {
  color: var(--art-primary);
  background: var(--art-gray-200);
}

.nav-item-active {
  color: var(--art-primary);
  background: color-mix(
    in oklch,
    var(--art-primary) 10%,
    var(--art-card-bg)
  );
  font-weight: 600;
}

.nav-item-active:hover {
  color: var(--art-primary);
  background: color-mix(
    in oklch,
    var(--art-primary) 10%,
    var(--art-card-bg)
  );
}

.nav-index {
  min-width: 1.5em;
  color: inherit;
  font-size: 12px;
  font-variant-numeric: tabular-nums;
  opacity: 0.72;
}

.sidebar-note {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 12px;
  padding: 8px 12px;
  border: 1px solid var(--art-border-default);
  border-radius: var(--art-radius-control);
  color: var(--art-text-secondary);
  background: var(--art-gray-50);
  font-size: 12px;
  opacity: 0.9;
}

.note-dot {
  width: 6px;
  height: 6px;
  flex-shrink: 0;
  border-radius: 50%;
  background: var(--art-success);
}

@media (width <= 640px) {
  .app-sidebar {
    position: static;
    width: 100%;
    height: auto;
    border-right: 0;
    border-bottom: 1px solid var(--art-border-card);
  }

  .sidebar-brand {
    min-height: 56px;
  }

  .sidebar-nav {
    flex: none;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 6px;
    padding: 12px;
  }

  .nav-item {
    width: auto;
    min-height: 40px;
    margin-left: 0;
  }

  .sidebar-note {
    display: none;
  }
}
</style>


