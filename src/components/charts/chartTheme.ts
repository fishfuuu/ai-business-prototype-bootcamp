export const chartColors = {
  seriesPrimary: '#1f78d1',
  seriesSecondary: '#2563eb',

  good: '#18a058',
  warn: '#f59e0b',
  bad: '#dc2626',
  noData: '#9ca3af',

  axisLabel: '#687385',
  splitLine: '#edf0f5',

  textPrimary: '#323251',
  cardBackground: '#ffffff'
} as const

export const chartSeriesPalette: string[] = [
  chartColors.seriesPrimary,
  chartColors.seriesSecondary,
  chartColors.good,
  chartColors.warn,
  chartColors.bad,
  chartColors.noData
]

export const chartFontFamily = [
  '"Fira Sans"',
  '"Microsoft YaHei"',
  '"PingFang SC"',
  'ui-sans-serif',
  'system-ui',
  'sans-serif'
].join(', ')

export const chartTooltipStyle = {
  backgroundColor: chartColors.cardBackground,
  borderColor: chartColors.splitLine,
  borderWidth: 1,
  textStyle: {
    color: chartColors.textPrimary,
    fontSize: 12,
    fontFamily: chartFontFamily
  }
}
