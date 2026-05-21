import { defineConfig, loadEnv } from "vite";
import uni from "@dcloudio/vite-plugin-uni";
import tailwindcss from "@tailwindcss/postcss";
import { fileURLToPath, URL } from "node:url";
import { UnifiedViteWeappTailwindcssPlugin } from "weapp-tailwindcss/vite";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  const viteEnv = loadEnv(mode, process.cwd(), "");

  return {
    define: {
      __APP_ENV__: JSON.stringify(mode),
      __API_BASE_URL__: JSON.stringify(viteEnv.VITE_API_BASE_URL || ""),
    },
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
    build: {
      minify: "terser",
    },
  };
});
