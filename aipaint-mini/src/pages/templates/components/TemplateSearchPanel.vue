<template>
  <view
    v-if="visible"
    class="fixed inset-0 z-50 flex flex-col bg-[#f8f8f8]"
  >
    <AppNavBar title="搜索模板" />

    <view class="bg-white px-[32rpx] pb-[30rpx] pt-[24rpx] shadow-[0_10rpx_28rpx_rgba(0,0,0,0.04)]">
      <view class="flex items-center gap-[18rpx]">
        <view class="flex h-[80rpx] min-w-0 flex-1 items-center gap-[16rpx] rounded-full border border-[rgba(0,0,0,0.04)] bg-[#f2f2f2] px-[24rpx]">
          <text class="iconfont icon-sousuokuangsousuo" style="font-weight: 600; color: #777;padding-top: 6rpx;"></text>
          <input
            v-model="searchDraft"
            class="h-full min-w-0 flex-1 text-[28rpx] font-medium leading-[40rpx] text-black"
            type="text"
            confirm-type="search"
            placeholder="搜索模板、标签、描述"
            placeholder-class="text-[#9a9a9a]"
            :focus="visible"
            @confirm="commitSearch"
          />
          <button
            v-if="searchDraft"
            class="m-0 flex h-[44rpx] w-[44rpx] items-center justify-center rounded-full bg-[#dedede] p-0 text-[30rpx] leading-none text-[#777] active:bg-[#d4d4d4]"
            hover-class="none"
            aria-label="清空搜索"
            @tap="searchDraft = ''"
          >
            x
          </button>
        </view>
        <button
          class="m-0 h-[80rpx] shrink-0 p-0 text-[28rpx] font-semibold leading-[80rpx] text-black active:opacity-65"
          hover-class="none"
          @tap="handleClose"
        >
          取消
        </button>
      </view>
    </view>

    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[32rpx] pb-[56rpx] pt-[28rpx]">
        <view v-if="keyword" class="mb-[28rpx] rounded-[18rpx] bg-white px-[26rpx] py-[22rpx]">
          <text class="block text-[24rpx] leading-[32rpx] text-[#7a7a7a]">
            正在当前分类中筛选
          </text>
          <text class="mt-[8rpx] block text-[30rpx] font-semibold leading-[40rpx] text-black">
            "{{ keyword }}" · {{ resultCount }} 个结果
          </text>
        </view>

        <view v-if="recentSearches.length">
          <view class="mb-[18rpx] flex items-center justify-between">
            <text class="text-[26rpx] font-semibold leading-[36rpx] text-black">最近搜索</text>
            <button
              class="m-0 p-0 text-[24rpx] leading-[36rpx] text-[#7a7a7a] active:opacity-70"
              hover-class="none"
              @tap="emit('clear-recent')"
            >
              清空
            </button>
          </view>
          <view class="flex flex-wrap gap-[16rpx]">
            <button
              v-for="item in recentSearches"
              :key="item"
              class="m-0 rounded-full bg-white px-[24rpx] py-[12rpx] text-[26rpx] font-medium leading-[34rpx] text-black active:scale-95"
              hover-class="none"
              @tap="applyKeyword(item)"
            >
              {{ item }}
            </button>
          </view>
        </view>

        <view class="mt-[36rpx]">
          <text class="mb-[18rpx] block text-[26rpx] font-semibold leading-[36rpx] text-black">热门灵感标签</text>
          <view class="grid grid-cols-2 gap-[16rpx]">
            <button
              v-for="suggestion in suggestions"
              :key="suggestion"
              class="m-0 flex min-h-[82rpx] items-center justify-center rounded-[18rpx] bg-white px-[20rpx] py-[14rpx] text-center active:scale-[0.98]"
              hover-class="none"
              @tap="applyKeyword(suggestion)"
            >
              <text class="min-w-0 truncate text-[26rpx] font-semibold leading-[34rpx] text-black">
                {{ suggestion }}
              </text>
            </button>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import AppNavBar from "@/components/AppNavBar.vue";

const props = defineProps<{
  visible: boolean;
  keyword: string;
  recentSearches: string[];
  suggestions: string[];
  resultCount: number;
}>();

const emit = defineEmits<{
  (event: "close"): void;
  (event: "search", keyword: string): void;
  (event: "clear-recent"): void;
}>();

const searchDraft = ref("");

watch(
  () => props.visible,
  (visible) => {
    if (visible) {
      searchDraft.value = props.keyword;
    }
  },
);

watch(
  () => props.keyword,
  (keyword) => {
    if (!props.visible) {
      searchDraft.value = keyword;
    }
  },
);

function commitSearch() {
  emit("search", searchDraft.value);
}

function applyKeyword(keyword: string) {
  searchDraft.value = keyword;
  emit("search", keyword);
}

function handleClose() {
  searchDraft.value = props.keyword;
  emit("close");
}
</script>

<style scoped>
.search-mark {
  position: relative;
  width: 32rpx;
  height: 32rpx;
  flex: 0 0 32rpx;
}

.search-mark__ring {
  position: absolute;
  left: 2rpx;
  top: 1rpx;
  width: 22rpx;
  height: 22rpx;
  border: 4rpx solid currentColor;
  border-radius: 9999rpx;
}

.search-mark__handle {
  position: absolute;
  right: 2rpx;
  bottom: 3rpx;
  width: 14rpx;
  height: 4rpx;
  border-radius: 9999rpx;
  background: currentColor;
  transform: rotate(45deg);
  transform-origin: center;
}

.search-mark--input {
  color: #777;
}

</style>
