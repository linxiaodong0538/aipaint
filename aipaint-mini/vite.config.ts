import { defineConfig } from "vite";
import uni from "@dcloudio/vite-plugin-uni";
import tailwindcss from "@tailwindcss/postcss";
import { fileURLToPath, URL } from "node:url";
import { UnifiedViteWeappTailwindcssPlugin } from "weapp-tailwindcss/vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    uni(),
    UnifiedViteWeappTailwindcssPlugin({
      rem2rpx: true,
      cssEntries: [fileURLToPath(new URL("./src/styles/app.css", import.meta.url))],
    }),
  ],
  css: {
    postcss: {
      plugins: [tailwindcss()],
    },
  },
});
