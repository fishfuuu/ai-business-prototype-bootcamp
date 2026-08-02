// 备用包路由注册片段
export const orderWarningRoute = {
  path: '/order-warning',
  name: 'OrderWarning',
  component: () => import('@/pages/OrderWarningPage.vue'),
  meta: { title: '供应商履约预警' }
}
