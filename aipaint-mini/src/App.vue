<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
onLaunch(() => {
  console.log("App Launch");
});
onShow(() => {
  console.log("App Show");
});
onHide(() => {
  console.log("App Hide");
});
</script>
<style>
@import "./styles/app.css";
@import "./styles/theme.css";
@import "./styles/base.css";
@import "./static/font/iconfont.css";
</style>
