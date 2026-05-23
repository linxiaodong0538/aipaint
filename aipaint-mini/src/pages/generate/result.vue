<template>
  <view class="fixed inset-0 h-screen overflow-hidden bg-[#f8f8f8] text-[#1a1c1c]">
    <section
      v-if="showProgressState"
      class="absolute inset-0 flex flex-col items-center justify-center px-[32rpx] pb-[160rpx] transition-all duration-700 ease-in-out"
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

      <view v-if="taskState !== 'failed'" class="mt-[78rpx] w-full max-w-[560rpx]">
        <view class="mb-[28rpx] flex justify-center">
          <view
            class="processing-hint-pill"
            :class="{ 'processing-hint-pill-long': longWaitHintVisible }"
          >
            <view class="processing-hint-dot" />
            <text class="processing-hint-text">{{ processingHintText }}</text>
          </view>
        </view>
        <view class="infinite-progress-track h-[8rpx] w-full rounded-full" />
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
      v-if="showCompletedState"
      class="absolute inset-0 transition-all duration-1000 ease-in-out"
      :class="completedStateClass"
    >
      <scroll-view
        scroll-y
        class="h-full w-full"
        :show-scrollbar="false"
      >
        <view class="relative aspect-square w-full bg-white p-[24rpx]">
          <swiper
            v-if="generatedImages.length"
            class="h-full w-full"
            :current="activeGeneratedImageIndex"
            :indicator-dots="false"
            @change="handleGeneratedImageChange"
          >
            <swiper-item
              v-for="(image, index) in generatedImages"
              :key="`${image}-${index}`"
            >
              <image
                class="h-full w-full"
                mode="aspectFill"
                :src="image"
                @tap="previewGeneratedImage"
              />
            </swiper-item>
          </swiper>
          <view v-else class="h-full w-full bg-[#e2e2e2]" />
          <view
            v-if="generatedImages.length > 1"
            class="absolute right-[40rpx] top-[40rpx] rounded-full bg-black/65 px-[18rpx] pb-[8rpx] backdrop-blur-[12rpx]"
          >
            <text class="font-mono text-[22rpx] font-semibold leading-[28rpx] text-white">
              {{ activeGeneratedImageIndex + 1 }}/{{ generatedImages.length }}
            </text>
          </view>
          <text class="font-mono absolute bottom-[32rpx] left-[32rpx] text-[20rpx] font-medium uppercase leading-[28rpx] tracking-[2rpx] text-white/50">
            LATENT_SPACE_PROJECTION_V2.4
          </text>
        </view>

        <view
          class="technical-grid border-t border-[#ddd] border-dashed bg-white px-[24rpx] pb-[260rpx] pt-[44rpx]"
     
        >
          <view class="mb-[16rpx] flex justify-between items-center">
            <view class="pl-[8rpx]">
              <text class="font-mono mb-[8rpx] block text-[20rpx] font-medium uppercase leading-[28rpx] tracking-[6rpx] text-[#7e7576]">
                真实性认证
              </text>
              <text class="block text-[32rpx] font-semibold uppercase leading-[48rpx] text-black">
                生成参数
              </text>
            </view>
            <text class="font-mono border border-black px-[16rpx] py-[4rpx] text-[20rpx] font-bold leading-[1.4] text-black">
              已验证
            </text>
          </view>

          <view class="grid grid-cols-2 border-l border-t border-[rgba(0,0,0,0.1)]">
            <view class="flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">模型</text>
              <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">{{ taskModelText }}</text>
            </view>
            <view class="flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">尺寸</text>
              <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">{{ taskSizeText }}</text>
            </view>
            <view class="flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">生成张数</text>
              <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">{{ taskImageCountText }}</text>
            </view>
            <view class="flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">积分</text>
              <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">{{ taskCreditText }}</text>
            </view>
            <!-- <view class="flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">状态</text>
              <view class="flex items-center gap-[12rpx]">
                <view class="h-[12rpx] w-[12rpx] rounded-full bg-black" />
                <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">已完成</text>
              </view>
            </view> -->
            <view class="col-span-2 flex flex-col gap-[8rpx] border-b border-r border-[rgba(0,0,0,0.1)] p-[32rpx]">
              <text class="font-mono text-[20rpx] font-medium uppercase leading-[24rpx] tracking-[4rpx] text-[#7e7576]">创建时间</text>
              <text class="font-mono text-[28rpx] font-medium leading-[40rpx] text-black">{{ taskCreateTimeText }}</text>
            </view>
          </view>

          <view class="mt-[64rpx] flex items-center gap-[32rpx] opacity-30">
            <view class="blueprint-line flex-1" />
            <text class="font-mono text-[20rpx] font-medium leading-[28rpx] text-black">技术数据结束</text>
            <view class="blueprint-line flex-1" />
          </view>

          <view class="result-action-grid mt-[64rpx] grid grid-cols-3 border border-[rgba(0,0,0,0.1)]">
            <button class="result-action-button flex flex-col items-center justify-center gap-[12rpx] bg-transparent py-[32rpx] active:bg-black/10" open-type="share">
              <text class="iconfont icon-a-huaban1fuben37 text-[40rpx] leading-none text-black" style="font-size: 40rpx;"/>
              <text class="font-mono text-[24rpx] font-medium uppercase leading-[28rpx] tracking-[4rpx] text-[#7e7576]">分享</text>
            </button>
            <button class="result-action-button flex flex-col items-center justify-center gap-[12rpx] bg-transparent py-[32rpx] active:bg-black/10" @tap="goBack">
              <text class="iconfont icon-shanshan text-[40rpx] leading-none text-black" style="font-size: 40rpx;"/>
              <text class="font-mono text-[24rpx] font-medium uppercase leading-[28rpx] tracking-[4rpx] text-[#7e7576]">重试</text>
            </button>
            <button class="result-action-button flex flex-col items-center justify-center gap-[12rpx] bg-transparent py-[32rpx] active:bg-black/10" @tap="showUnsupported">
              <text class="iconfont icon-tupian text-[40rpx] leading-none text-black" style="font-size: 40rpx;"/>
              <text class="font-mono text-[24rpx] font-medium uppercase leading-[28rpx] tracking-[4rpx] text-[#7e7576]">作品库</text>
            </button>
          </view>
        </view>
      </scroll-view>
    </section>

    <view
      v-if="bottomBarVisible"
      class="fixed inset-x-0 bottom-0 z-50 border-t border-[rgba(0,0,0,0.05)] bg-[rgba(255,255,255,0.95)] px-[48rpx] pt-[32rpx] shadow-[0_-20rpx_60rpx_rgba(0,0,0,0.03)] backdrop-blur-[24rpx]"
      :class="bottomBarClass"
      :style="{ height: `${bottomBarHeight}px`, paddingBottom: footerSafePadding }"
    >
      <button
        class="mx-auto flex h-[104rpx] w-full max-w-[640rpx] items-center justify-center gap-[16rpx] rounded-full bg-black text-white shadow-[0_20rpx_40rpx_rgba(0,0,0,0.16)] active:scale-95"
        @tap="saveImage"
      >
        <text class="iconfont icon-images text-[36rpx] leading-none text-white" />
        <text class="font-mono text-[28rpx] font-semibold uppercase leading-[40rpx] tracking-[4rpx] text-white">保存到相册</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad, onReady, onUnload } from "@dcloudio/uni-app";
import { getGenerationTask, type GenerationTask } from "@/api/generate";
import { navigateBack } from "@/utils/router";

type TaskState = "processing" | "success" | "failed";

const taskId = ref<number | null>(null);
const taskState = ref<TaskState>("processing");
const generatedImages = ref<string[]>([]);
const activeGeneratedImageIndex = ref(0);
const previewImage = ref("");
const errorMessage = ref("");
const taskModel = ref("");
const taskSize = ref("");
const taskImageCount = ref<number | null>(null);
const taskCreditCost = ref<number | null>(null);
const taskCreateTime = ref("");
const safeAreaBottom = ref(0);
const windowWidth = ref(375);
const pageInitializing = ref(true);
const isHistoryDetail = ref(false);
const historyInitializing = ref(false);
const bottomBarVisible = ref(false);
const longWaitHintVisible = ref(false);
const resultDetailStorageKey = "generateResultDetailTask";

let pollTimer: ReturnType<typeof setInterval> | null = null;
let polling = false;
let pollAttempts = 0;

try {
  const info = uni.getSystemInfoSync();
  safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
  windowWidth.value = info.windowWidth || 375;
} catch {
  safeAreaBottom.value = 0;
  windowWidth.value = 375;
}

const footerSafePadding = computed(() => `${rpxToPx(40) + safeAreaBottom.value}px`);
const bottomBarHeight = computed(() => rpxToPx(176) + safeAreaBottom.value);
const showProgressState = computed(() => !pageInitializing.value && taskState.value !== "success");
const showCompletedState = computed(() => !pageInitializing.value && taskState.value === "success");
const taskSizeText = computed(() => taskSize.value.replace("x", " x ") || "未知");
const taskImageCountText = computed(() => `${taskImageCount.value ?? (generatedImages.value.length || 1)} 张`);
const taskCreditText = computed(() => `${taskCreditCost.value ?? "--"} CREDITS`);
const taskCreateTimeText = computed(() => formatCreateTime(taskCreateTime.value));
const taskModelText = computed(() => taskModel.value || "gpt-image-2");
const activeGeneratedImage = computed(() => generatedImages.value[activeGeneratedImageIndex.value] || "");

const progressTitle = computed(() => {
  if (taskState.value === "failed") return "生成失败";
  if (previewImage.value) return "预览图生成中...";
  return "灵感捕捉中...";
});

const progressSubtitle = computed(() => (
  taskState.value === "failed"
    ? errorMessage.value || "图片生成失败，请返回后重试"
    : "您的创意正在转化为现实，请稍候"
));
const processingHintText = computed(() => (
  longWaitHintVisible.value
    ? "耗时较久，可稍后在作品中查看"
    : "PROCESSING"
));

const progressStateClass = computed(() => (
  historyInitializing.value
    ? "scale-100 translate-y-0 opacity-0 pointer-events-none"
    :
  taskState.value === "success"
    ? "scale-95 -translate-y-[40rpx] opacity-0 pointer-events-none"
    : "scale-100 translate-y-0 opacity-100"
));

const completedStateClass = computed(() => (
  taskState.value === "success"
    ? "translate-y-0 opacity-100"
    : "translate-y-[64rpx] opacity-0 pointer-events-none"
));
const bottomBarClass = computed(() => {
  if (taskState.value === "success" && isHistoryDetail.value) return "translate-y-0";
  return [
    "transition-transform duration-700 ease-out",
    taskState.value === "success" ? "translate-y-0" : "translate-y-full",
  ];
});

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

onLoad((query) => {
  const id = Number(query?.taskId);
  if (!Number.isFinite(id) || id <= 0) {
    failTask("生成任务不存在");
    return;
  }

  taskId.value = id;

  if (import.meta.env.DEV && query?.mockLongWait === "1") {
    pageInitializing.value = false;
    showLongWaitHint();
    return;
  }

  if (query?.from === "works") {
    void openFromWorks(id);
    return;
  }

  pageInitializing.value = false;
  void pollTask();
  pollTimer = setInterval(() => {
    void pollTask();
  }, 2000);
});

onReady(() => {
  if (taskState.value === "success") {
    showBottomBarAfterEnter();
  }
});

onUnload(() => {
  stopTimers();
});

async function pollTask() {
  if (!taskId.value || polling || taskState.value !== "processing") return;

  polling = true;
  pollAttempts += 1;

  try {
    const task = await getGenerationTask(taskId.value);
    applyTaskDetails(task);

    if (task.previewImageUrl && task.previewImageUrl !== previewImage.value) {
      previewImage.value = task.previewImageUrl;
    }

    if (task.status === "success") {
      completeTask(getTaskResultImages(task));
      return;
    }

    if (task.status === "failed") {
      failTask(task.errorMessage || "图片生成失败");
      return;
    }

    if (shouldShowLaterCheckHint(task)) {
      showLongWaitHint();
    }

    if (pollAttempts >= 45) {
      showLongWaitHint();
    }
  } catch (error) {
    if (pollAttempts >= 45) {
      showLongWaitHint();
    }
  } finally {
    polling = false;
  }
}

async function openFromWorks(id: number) {
  isHistoryDetail.value = true;
  historyInitializing.value = true;

  if (hydrateCompletedTaskFromStorage(id)) {
    historyInitializing.value = false;
    pageInitializing.value = false;
    return;
  }

  try {
    const task = await getGenerationTask(id);
    applyTaskDetails(task);

    const taskImages = getTaskResultImages(task);
    if (task.status === "success" && taskImages.length > 0) {
      completeTask(taskImages, { instant: true, toast: false });
      pageInitializing.value = false;
      return;
    }

    if (task.status === "failed") {
      failTask(task.errorMessage || "图片生成失败");
      pageInitializing.value = false;
      return;
    }

    isHistoryDetail.value = false;
    if (shouldShowLaterCheckHint(task)) {
      showLongWaitHint();
    }
    if (task.previewImageUrl) {
      previewImage.value = task.previewImageUrl;
    }
    pageInitializing.value = false;
    void pollTask();
    pollTimer = setInterval(() => {
      void pollTask();
    }, 2000);
  } catch (error) {
    const message = error instanceof Error ? error.message : "任务加载失败";
    failTask(message);
    pageInitializing.value = false;
  } finally {
    historyInitializing.value = false;
  }
}

function completeTask(imageUrls: string[], options: { instant?: boolean; toast?: boolean } = {}) {
  generatedImages.value = imageUrls;
  activeGeneratedImageIndex.value = 0;
  stopTimers();
  if (options.instant) {
    taskState.value = "success";
    pageInitializing.value = false;
    showBottomBarAfterEnter();
    return;
  }

  setTimeout(() => {
    taskState.value = "success";
    pageInitializing.value = false;
    bottomBarVisible.value = true;
    if (options.toast !== false) {
      uni.showToast({ title: "生成完成", icon: "success" });
    }
  }, 500);
}

function applyTaskDetails(task: GenerationTask) {
  taskModel.value = task.model || "";
  taskSize.value = task.size || "";
  taskImageCount.value = typeof task.imageCount === "number" ? task.imageCount : null;
  taskCreditCost.value = typeof task.creditCost === "number" ? task.creditCost : null;
  taskCreateTime.value = task.createTime || task.finishTime || "";
}

function hydrateCompletedTaskFromStorage(expectedTaskId: number) {
  const task = uni.getStorageSync(resultDetailStorageKey) as GenerationTask | "";
  uni.removeStorageSync(resultDetailStorageKey);

  const taskImages = task ? getTaskResultImages(task) : [];
  if (!task || task.taskId !== expectedTaskId || task.status !== "success" || taskImages.length === 0) {
    return false;
  }

  isHistoryDetail.value = true;
  applyTaskDetails(task);
  completeTask(taskImages, { instant: true, toast: false });
  return true;
}

function formatCreateTime(value: string) {
  if (!value) return "";
  const timestamp = new Date(value.replace(/-/g, "/")).getTime();
  if (!Number.isFinite(timestamp)) return value.slice(0, 16);
  const date = new Date(timestamp);
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  return `${date.getFullYear()}年${month}月${day}日 ${hours}:${minutes}`;
}

function failTask(message: string) {
  errorMessage.value = message;
  stopTimers();
  bottomBarVisible.value = false;
  taskState.value = "failed";
  pageInitializing.value = false;
  uni.showToast({ title: message, icon: "none" });
}

function showLongWaitHint() {
  if (longWaitHintVisible.value) {
    return;
  }
  longWaitHintVisible.value = true;
}

function shouldShowLaterCheckHint(task: GenerationTask) {
  const message = task.errorMessage || "";
  return task.status === "processing" && message.includes("稍后到作品中查看");
}

function showBottomBarAfterEnter() {
  if (!isHistoryDetail.value) {
    bottomBarVisible.value = true;
    return;
  }

  setTimeout(() => {
    if (taskState.value === "success") {
      bottomBarVisible.value = true;
    }
  }, 350);
}

function stopTimers() {
  if (pollTimer) {
    clearInterval(pollTimer);
    pollTimer = null;
  }
}

function getTaskResultImages(task: GenerationTask) {
  return task.resultImageUrls?.length ? task.resultImageUrls : task.resultImageUrl ? [task.resultImageUrl] : [];
}

function handleGeneratedImageChange(event: { detail?: { current?: number } }) {
  const current = event.detail?.current;
  if (typeof current !== "number") {
    return;
  }
  activeGeneratedImageIndex.value = Math.max(0, Math.min(generatedImages.value.length - 1, current));
}

function previewGeneratedImage() {
  if (!activeGeneratedImage.value) return;
  uni.previewImage({
    urls: generatedImages.value,
    current: activeGeneratedImage.value,
  });
}

function saveImage() {
  if (!activeGeneratedImage.value) return;

  uni.downloadFile({
    url: activeGeneratedImage.value,
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
  background-color: #f8f8f8;
  height: 100%;
  overflow: hidden;
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

.infinite-progress-track {
  background-image: linear-gradient(90deg, #e8e8e8 0%, #e8e8e8 38%, #000 46%, #000 54%, #e8e8e8 62%, #e8e8e8 100%);
  background-size: 260% 100%;
  background-position: 100% 0;
  animation: infinite-progress-slide 1.2s linear infinite;
}

.processing-hint-pill {
  display: inline-flex;
  box-sizing: border-box;
  max-width: 100%;
  min-height: 52rpx;
  align-items: center;
  gap: 12rpx;
  padding: 12rpx 22rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.08);
  border-radius: 9999rpx;
  background: rgba(255, 255, 255, 0.78);
  box-shadow: 0 14rpx 40rpx rgba(0, 0, 0, 0.06);
  backdrop-filter: blur(20rpx);
}

.processing-hint-pill-long {
  padding-right: 24rpx;
  padding-left: 24rpx;
}

.processing-hint-dot {
  flex: 0 0 auto;
  width: 10rpx;
  height: 10rpx;
  border-radius: 9999rpx;
  background: #1a1c1c;
  box-shadow: 0 0 0 8rpx rgba(0, 0, 0, 0.06);
}

.processing-hint-text {
  display: block;
  min-width: 0;
  overflow: hidden;
  color: rgba(76, 69, 70, 0.74);
  font-size: 22rpx;
  font-weight: 500;
  line-height: 28rpx;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.font-mono {
  font-family: "JetBrains Mono", "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
}

.technical-grid {
  background-image: radial-gradient(rgba(0, 0, 0, 0.05) 2rpx, transparent 0);
  background-size: 40rpx 40rpx;
}

.blueprint-line {
  width: 100%;
  height: 2rpx;
  background: linear-gradient(90deg, transparent 0%, #1a1c1c 50%, transparent 100%);
  opacity: 0.1;
}

.result-action-button {
  margin: 0;
  border-radius: 0;
  line-height: 1;
}

.result-action-button::after {
  border: 0;
}

.result-action-grid .result-action-button + .result-action-button {
  border-left: 2rpx solid rgba(0, 0, 0, 0.1);
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

@keyframes infinite-progress-slide {
  0% {
    background-position: 100% 0;
  }

  100% {
    background-position: 0 0;
  }
}
</style>
