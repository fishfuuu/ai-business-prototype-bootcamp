import { createRouter, createWebHashHistory } from 'vue-router'

const router = createRouter({
  history: createWebHashHistory(),

  routes: [
    {
      path: '/',
      component: () => import('@/layouts/PrototypeLayout.vue'),
      children: [
        {
          path: '',
          name: 'Home',
          component: () => import('@/pages/HomePage.vue'),
          meta: {
            title: '开始创建'
          }
        },
        {
          path: 'components',
          name: 'ComponentsShowcase',
          component: () => import('@/pages/ComponentsShowcasePage.vue'),
          meta: {
            title: '组件展示'
          }
        }
      ]
    }
  ]
})

export default router
