export function useChartEmpty(options: {
  containerRef: () => HTMLElement | undefined;
  chart: () => any;
  isDestroyed: () => boolean;
}) {
  const { containerRef, chart, isDestroyed } = options
  let emptyStateDiv: HTMLElement | null = null

  const updateStyle = () => {
    if (!emptyStateDiv || isDestroyed?.()) return
    const isDark = document.documentElement.classList.contains('dark')
    emptyStateDiv.style.color = isDark ? '#999' : '#999'
  }

  const showEmpty = (text = '暂无数据') => {
    hideEmpty()
    const container = containerRef()
    if (!container || isDestroyed()) return

    emptyStateDiv = document.createElement('div')
    emptyStateDiv.style.cssText = `
      display:flex;align-items:center;justify-content:center;
      height:100%;min-height:200px;
      font-size:14px;color:#999;
      z-index:10;pointer-events:none;
      position:absolute;top:0;left:0;right:0;
    `
    emptyStateDiv.textContent = text
    updateStyle()
    container.appendChild(emptyStateDiv)
  }

  const hideEmpty = () => {
    if (emptyStateDiv) {
      emptyStateDiv.remove()
      emptyStateDiv = null
    }
  }

  const reset = () => {
    hideEmpty()
  }

  return { showEmpty, hideEmpty, updateStyle, reset }
}
