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
        :to="{ name: 'OrderWarning' }"
        class="nav-item"
        exact-active-class="nav-item-active"
      >
        <span class="nav-index">02</span>
        <span>履约预警台</span>
      </RouterLink>

      <RouterLink
        :to="{ name: 'ComponentsShowcase' }"
        class="nav-item"
        exact-active-class="nav-item-active"
      >
        <span class="nav-index">03</span>
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
  color: var(--art-text-primary);
  font-size: 14px;
  font-weight: 600;
  line-height: 1.2;
}

.brand-copy span {
  color: var(--art-text-tertiary);
  font-size: 11px;
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
  align-items: center;
  gap: 10px;
  height: 42px;
  padding: 0 12px;
  border-radius: var(--art-radius-control);
  color: var(--art-text-secondary);
  font-size: 14px;
  text-decoration: none;
  transition: background-color 0.15s ease, color 0.15s ease;
}

.nav-item:hover {
  color: var(--art-text-primary);
  background-color: var(--art-gray-200);
}

.nav-item-active {
  color: var(--art-primary);
  background-color: color-mix(in oklch, var(--art-primary) 10%, transparent);
  font-weight: 600;
}

.nav-index {
  font-size: 12px;
  font-weight: 500;
  opacity: 0.7;
}

.sidebar-note {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  border-top: 1px solid var(--art-border-card);
  color: var(--art-text-tertiary);
  font-size: 12px;
}

.note-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--art-success);
}
</style>
