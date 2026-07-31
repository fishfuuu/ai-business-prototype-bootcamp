import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import ElementPlus from 'unplugin-element-plus/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({
  server: {
    host: '127.0.0.1',
    port: 8888
  },

  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '@styles': fileURLToPath(new URL('./src/assets/styles', import.meta.url))
    }
  },

  plugins: [
    vue(),
    tailwindcss(),

    AutoImport({
      imports: ['vue', 'vue-router', 'pinia', '@vueuse/core'],
      resolvers: [ElementPlusResolver()],
      dts: 'src/auto-imports.d.ts'
    }),

    Components({
      resolvers: [ElementPlusResolver()],
      dts: 'src/components.d.ts'
    }),

    ElementPlus({
      useSource: true
    })
  ],

  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `
          @use "@styles/el-light.scss" as *;
          @use "@styles/mixin.scss" as *;
        `
      }
    }
  }
})