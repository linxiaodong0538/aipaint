<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
onLaunch((options) => {
  console.log("App Launch");
  captureInviteCode(options?.query);
});
onShow((options) => {
  console.log("App Show");
  captureInviteCode(options?.query);
});
onHide(() => {
  console.log("App Hide");
});

function captureInviteCode(query?: Record<string, unknown>) {
  const value = query?.inviteCode;
  const inviteCode = Array.isArray(value) ? value[0] : value;
  if (typeof inviteCode === "string" && inviteCode.trim()) {
    uni.setStorageSync("inviteCode", inviteCode.trim());
  }
}
</script>
<style>
@import "./styles/app.css";
@import "./styles/theme.css";
@import "./styles/base.css";
@import "./static/font/iconfont.css";
</style>
