<template>
  <view class="relative h-screen overflow-hidden bg-[#f9f9f9] text-[#1a1c1c]">
    <section
      class="absolute inset-0 flex flex-col items-center justify-center px-[48rpx] pb-[160rpx] transition-all duration-700 ease-in-out"
      :class="progressStateClass"
    >
      <view v-if="previewImage && taskState !== 'failed'" class="mb-[72rpx] w-full max-w-[560rpx]">
        <view class="overflow-hidden rounded-[56rpx] border border-[rgba(0,0,0,0.05)] bg-white p-[14rpx] shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
          <view class="relative aspect-square overflow-hidden rounded-[42rpx] bg-[#e2e2e2]">
            <image
              class="h-full w-full scale-[1.04] transition-opacity duration-500"
              mode="aspectFill"
              :src="previewImage"
            />
            <view class="absolute inset-x-0 bottom-0 bg-[linear-gradient(to_top,rgba(0,0,0,0.36),transparent)] px-[28rpx] pb-[28rpx] pt-[96rpx]">
              <text class="text-[22rpx] font-medium uppercase leading-[28rpx] tracking-[4rpx] text-white">PREVIEW IMAGE</text>
            </view>
          </view>
        </view>
      </view>

      <view v-else-if="taskState !== 'failed'" class="orbit-container mb-[96rpx]">
        <view class="orbit-ring h-[448rpx] w-[448rpx] animate-orbit-slow">
          <view class="orbit-particle bg-[rgba(0,0,0,0.2)]" />
        </view>
        <view class="orbit-ring h-[320rpx] w-[320rpx] animate-orbit-reverse">
          <view class="orbit-particle bg-[rgba(0,0,0,0.4)]" />
        </view>
        <view class="orbit-ring h-[192rpx] w-[192rpx] animate-orbit-fast">
          <view class="orbit-particle bg-black" />
        </view>
        <view class="absolute inset-0 flex items-center justify-center">
          <view class="ai-pulse h-[96rpx] w-[96rpx] rounded-full bg-black" />
        </view>
      </view>

      <view v-else class="mb-[72rpx] flex h-[180rpx] w-[180rpx] items-center justify-center rounded-full bg-[#e2e2e2]">
        <text class="text-[72rpx] font-light leading-none text-black">!</text>
      </view>

      <view class="max-w-[520rpx] text-center">
        <text class="block text-[48rpx] font-semibold leading-[64rpx] text-black">
          {{ progressTitle }}
        </text>
        <text class="mt-[16rpx] block text-[30rpx] font-normal leading-[48rpx] text-[rgba(76,69,70,0.7)]">
          {{ progressSubtitle }}
        </text>
      </view>

      <view v-if="taskState !== 'failed'" class="mt-[96rpx] w-full max-w-[560rpx] px-[64rpx]">
        <view class="mb-[16rpx] flex justify-between">
          <text class="text-[22rpx] font-medium uppercase leading-[28rpx] tracking-[6rpx] text-[#7e7576]">PROCESSING</text>
          <text class="text-[22rpx] font-bold leading-[28rpx] tracking-[6rpx] text-black">{{ roundedProgress }}%</text>
        </view>
        <view class="h-[8rpx] w-full overflow-hidden rounded-full bg-[#e8e8e8]">
          <view
            class="h-full rounded-full bg-black transition-all duration-300 ease-out"
            :style="{ width: `${roundedProgress}%` }"
          />
        </view>
      </view>

      <button
        v-if="taskState === 'failed'"
        class="mt-[72rpx] h-[88rpx] rounded-full bg-black px-[72rpx] text-[28rpx] font-semibold leading-[88rpx] text-white active:scale-95"
        @tap="goBack"
      >
        返回修改
      </button>
    </section>

    <section
      class="absolute inset-0 flex flex-col items-center justify-center px-[48rpx] pb-[260rpx] transition-all duration-1000 ease-in-out"
      :class="completedStateClass"
    >
      <view class="relative aspect-square w-full max-w-[640rpx] px-[0rpx]">
        <view class="h-full w-full overflow-hidden rounded-[64rpx] border border-[rgba(0,0,0,0.05)] bg-white p-[16rpx] shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
          <view class="relative h-full w-full overflow-hidden rounded-[48rpx]">
            <image
              v-if="generatedImage"
              class="h-full w-full scale-[1.05] transition-transform duration-1000"
              mode="aspectFill"
              :src="generatedImage"
              @tap="previewGeneratedImage"
            />
            <view v-else class="h-full w-full bg-[#e2e2e2]" />
            <view class="absolute right-[32rpx] top-[32rpx] flex items-center gap-[12rpx] rounded-full border border-[rgba(255,255,255,0.1)] bg-[rgba(0,0,0,0.8)] px-[24rpx] py-[12rpx] backdrop-blur-[24rpx]">
              <text class="iconfont icon-gou2x text-[22rpx] leading-none text-white" />
              <text class="text-[20rpx] font-medium uppercase leading-[28rpx] tracking-[2rpx] text-white">G Image 2</text>
            </view>
          </view>
        </view>

        <view
          class="mt-[64rpx] flex justify-center gap-[32rpx] transition-all delay-500 duration-700"
          :class="taskState === 'success' ? 'translate-y-0 opacity-100' : 'translate-y-[32rpx] opacity-0'"
        >
          <button class="grid justify-items-center gap-[16rpx] bg-transparent p-0 active:scale-95" open-type="share">
            <view class="flex h-[96rpx] w-[96rpx] items-center justify-center rounded-full border border-[#cfc4c5]">
              <text class="iconfont icon-a-huaban1fuben37 text-[38rpx] leading-none text-black" />
            </view>
            <text class="text-[22rpx] font-medium leading-[28rpx] tracking-[4rpx] text-[#4c4546]">分享</text>
          </button>
          <button class="grid justify-items-center gap-[16rpx] bg-transparent p-0 active:scale-95" @tap="goBack">
            <view class="flex h-[96rpx] w-[96rpx] items-center justify-center rounded-full border border-[#cfc4c5]">
              <text class="iconfont icon-shanshan text-[38rpx] leading-none text-black" />
            </view>
            <text class="text-[22rpx] font-medium leading-[28rpx] tracking-[4rpx] text-[#4c4546]">重新生成</text>
          </button>
          <button class="grid justify-items-center gap-[16rpx] bg-transparent p-0 active:scale-95" @tap="showUnsupported">
            <view class="flex h-[96rpx] w-[96rpx] items-center justify-center rounded-full border border-[#cfc4c5]">
              <text class="iconfont icon-MaterialSymbolsBrush text-[38rpx] leading-none text-black" />
            </view>
            <text class="text-[22rpx] font-medium leading-[28rpx] tracking-[4rpx] text-[#4c4546]">局部重绘</text>
          </button>
        </view>
      </view>
    </section>

    <view
      class="fixed inset-x-0 bottom-0 z-50 border-t border-[rgba(207,196,197,0.1)] bg-[rgba(255,255,255,0.9)] px-[48rpx] pt-[32rpx] backdrop-blur-[40rpx] transition-transform duration-700 ease-out"
      :class="taskState === 'success' ? 'translate-y-0' : 'translate-y-full'"
      :style="{ paddingBottom: `calc(40rpx + ${safeAreaBottom}px)` }"
    >
      <button
        class="mx-auto flex h-[104rpx] w-full max-w-[640rpx] items-center justify-center gap-[16rpx] rounded-full bg-black text-white shadow-[0_20rpx_40rpx_rgba(0,0,0,0.16)] active:scale-95"
        @tap="saveImage"
      >
        <text class="iconfont icon-images text-[36rpx] leading-none text-white" />
        <text class="text-[28rpx] font-semibold leading-[40rpx] tracking-[2rpx] text-white">保存到相册</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad, onUnload } from "@dcloudio/uni-app";
import { getGenerationTask } from "@/api/generate";
import { navigateBack } from "@/utils/router";

type TaskState = "processing" | "success" | "failed";

const taskId = ref<number | null>(null);
const taskState = ref<TaskState>("processing");
const progress = ref(0);
const generatedImage = ref("");
const previewImage = ref("");
const errorMessage = ref("");
const safeAreaBottom = ref(0);

let progressTimer: ReturnType<typeof setInterval> | null = null;
let pollTimer: ReturnType<typeof setInterval> | null = null;
let polling = false;
let pollAttempts = 0;

try {
  const info = uni.getSystemInfoSync();
  safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
} catch {
  safeAreaBottom.value = 0;
}

const roundedProgress = computed(() => Math.min(100, Math.floor(progress.value)));

const progressTitle = computed(() => {
  if (taskState.value === "failed") return "生成失败";
  if (previewImage.value && roundedProgress.value < 90) return "预览图生成中...";
  if (roundedProgress.value > 90) return "最后一步收尾...";
  if (roundedProgress.value > 60) return "优化光影细节...";
  if (roundedProgress.value > 30) return "正在编织像素...";
  return "灵感捕捉中...";
});

const progressSubtitle = computed(() => (
  taskState.value === "failed"
    ? errorMessage.value || "图片生成失败，请返回后重试"
    : "您的创意正在转化为现实，请稍候"
));

const progressStateClass = computed(() => (
  taskState.value === "success"
    ? "scale-95 -translate-y-[40rpx] opacity-0 pointer-events-none"
    : "scale-100 translate-y-0 opacity-100"
));

const completedStateClass = computed(() => (
  taskState.value === "success"
    ? "translate-y-0 opacity-100"
    : "translate-y-[64rpx] opacity-0 pointer-events-none"
));

onLoad((query) => {
  const id = Number(query?.taskId);
  if (!Number.isFinite(id) || id <= 0) {
    failTask("生成任务不存在");
    return;
  }

  taskId.value = id;
  startProgress();
  void pollTask();
  pollTimer = setInterval(() => {
    void pollTask();
  }, 2000);
});

onUnload(() => {
  stopTimers();
});

function startProgress() {
  stopProgressTimer();
  progressTimer = setInterval(() => {
    if (taskState.value !== "processing") return;
    const next = progress.value + 2 + Math.random() * 7;
    progress.value = Math.min(96, next);
  }, 700);
}

async function pollTask() {
  if (!taskId.value || polling || taskState.value !== "processing") return;

  polling = true;
  pollAttempts += 1;

  try {
    const task = await getGenerationTask(taskId.value);

    if (task.previewImageUrl && task.previewImageUrl !== previewImage.value) {
      previewImage.value = task.previewImageUrl;
      progress.value = Math.max(progress.value, 45 + Math.min(40, pollAttempts * 8));
    }

    if (task.status === "success") {
      completeTask(task.resultImageUrl || "");
      return;
    }

    if (task.status === "failed") {
      failTask(task.errorMessage || "图片生成失败");
      return;
    }

    if (pollAttempts >= 45) {
      failTask("生成耗时较久，请稍后到作品库查看");
    }
  } catch (error) {
    if (pollAttempts >= 45) {
      const message = error instanceof Error ? error.message : "图片生成失败";
      failTask(message);
    }
  } finally {
    polling = false;
  }
}

function completeTask(imageUrl: string) {
  generatedImage.value = imageUrl;
  progress.value = 100;
  stopTimers();
  setTimeout(() => {
    taskState.value = "success";
    uni.showToast({ title: "生成完成", icon: "success" });
  }, 500);
}

function failTask(message: string) {
  errorMessage.value = message;
  stopTimers();
  taskState.value = "failed";
  uni.showToast({ title: message, icon: "none" });
}

function stopTimers() {
  stopProgressTimer();
  if (pollTimer) {
    clearInterval(pollTimer);
    pollTimer = null;
  }
}

function stopProgressTimer() {
  if (progressTimer) {
    clearInterval(progressTimer);
    progressTimer = null;
  }
}

function previewGeneratedImage() {
  if (!generatedImage.value) return;
  uni.previewImage({
    urls: [generatedImage.value],
    current: generatedImage.value,
  });
}

function saveImage() {
  if (!generatedImage.value) return;

  uni.downloadFile({
    url: generatedImage.value,
    success(result) {
      if (result.statusCode !== 200 || !result.tempFilePath) {
        uni.showToast({ title: "图片下载失败", icon: "none" });
        return;
      }

      uni.saveImageToPhotosAlbum({
        filePath: result.tempFilePath,
        success() {
          uni.showToast({ title: "已保存", icon: "success" });
        },
        fail() {
          uni.showToast({ title: "保存失败，请检查相册权限", icon: "none" });
        },
      });
    },
    fail() {
      uni.showToast({ title: "图片下载失败", icon: "none" });
    },
  });
}

function goBack() {
  navigateBack();
}

function showUnsupported() {
  uni.showToast({ title: "局部重绘暂未接入", icon: "none" });
}
</script>

<style>
page {
  background-color: #f9f9f9;
}

.orbit-container {
  position: relative;
  width: 480rpx;
  height: 480rpx;
}

.orbit-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  border: 2rpx solid rgba(0, 0, 0, 0.05);
  border-radius: 9999px;
  transform: translate(-50%, -50%);
}

.orbit-particle {
  position: absolute;
  top: -8rpx;
  left: 50%;
  width: 16rpx;
  height: 16rpx;
  margin-left: -8rpx;
  border-radius: 9999px;
}

.ai-pulse {
  animation: ai-pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-orbit-slow {
  animation: orbit-spin 12s linear infinite;
}

.animate-orbit-reverse {
  animation: orbit-spin 6s linear infinite reverse;
}

.animate-orbit-fast {
  animation: orbit-spin 4s linear infinite;
}

@keyframes ai-pulse {
  0%,
  100% {
    opacity: 1;
    transform: scale(1);
    filter: blur(0);
  }

  50% {
    opacity: 0.5;
    transform: scale(1.1);
    filter: blur(4rpx);
  }
}

@keyframes orbit-spin {
  from {
    transform: translate(-50%, -50%) rotate(0deg);
  }

  to {
    transform: translate(-50%, -50%) rotate(360deg);
  }
}
</style>
