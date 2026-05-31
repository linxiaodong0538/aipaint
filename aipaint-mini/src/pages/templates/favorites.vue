<template>
  <view class="flex h-screen flex-col overflow-hidden bg-[#f8f8f8] font-sans text-[#1a1c1c]">
    <z-paging
      ref="paging"
      v-model="favoriteTemplates"
      :fixed="true"
      :default-page-size="pageSize"
      :auto="userStore.isLogin"
      loading-more-default-text="上滑加载更多"
      loading-more-loading-text="加载中..."
      loading-more-no-more-text="没有更多收藏了"
      :loading-more-title-custom-style="{ fontSize: '24rpx', heigth: '160rpx' }"
      :show-loading-more-no-more-line="true"
      :refresher-enabled="false"
      :empty-view-center="false"
      empty-view-text="暂无收藏模板"
      @query="queryFavorites"
    >
      <view class="px-[16rpx] pb-[48rpx] pt-[24rpx]">
        <view
          v-if="!userStore.isLogin"
          class="pt-[132rpx] flex flex-col items-center px-[32rpx] text-center"
        >
          <view class="relative flex h-[188rpx] w-[188rpx] items-center justify-center">
            <view class="absolute h-[164rpx] w-[164rpx] rounded-full bg-[#eeeeee]" />
            <view class="relative flex h-[136rpx] w-[136rpx] items-center justify-center rounded-[32rpx] border border-[#ebebeb] bg-white shadow-[0_20rpx_48rpx_rgba(0,0,0,0.06)]">
              <text class="iconfont icon-images leading-none text-[#c8c8c8]" style="font-size: 54rpx;" />
            </view>
          </view>
          <text class="mt-[36rpx] block text-[36rpx] font-bold leading-[50rpx] text-black">
            登录后查看收藏
          </text>
          <text class="mt-[20rpx] block max-w-[600rpx] text-[26rpx] leading-[40rpx] text-[#8e8e8e]">
            收藏喜欢的模板，之后可以从这里快速找回
          </text>
          <button
            class="mt-[56rpx] flex h-[88rpx] w-full max-w-[520rpx] items-center justify-center rounded-full bg-black px-[48rpx] text-[30rpx] font-bold leading-none text-white"
            :loading="userStore.loggingIn"
            @tap="handleLogin"
          >
            立即登录
          </button>
        </view>

        <view v-else-if="favoriteTemplates.length" class="columns-2 gap-[16rpx] pb-[36rpx]">
          <view
            v-for="template in favoriteTemplates"
            :key="template.templateId"
            class="mb-[24rpx] break-inside-avoid overflow-hidden rounded-[12rpx] border border-[rgba(0,0,0,0.04)] bg-white shadow-[0_10rpx_28rpx_rgba(0,0,0,0.04)] active:scale-[0.98]"
            @tap="goDetail(template)"
          >
            <image class="block w-full" mode="widthFix" :src="template.coverUrl" />
            <view class="px-[20rpx] py-[18rpx]">
              <view class="mb-[10rpx] flex items-center gap-[10rpx]">
                <text class="iconfont icon-images text-[22rpx] leading-none text-[#767676]" />
                <text class="text-[24rpx] font-medium leading-[32rpx] text-[#767676]">
                  {{ getTemplateModelName(template) }}
                </text>
              </view>
              <text class="block truncate text-[28rpx] font-semibold leading-[38rpx] text-black">
                {{ template.title }}
              </text>
              <view class="mt-[12rpx] flex flex-wrap gap-[8rpx]">
                <text
                  v-for="tag in getTemplateTags(template)"
                  :key="tag"
                  class="min-h-[44rpx] rounded-full bg-[#f0f0f0] px-[18rpx] py-[7rpx] text-[22rpx] font-semibold leading-[30rpx] text-[#1a1c1c]"
                >
                  {{ tag }}
                </text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <template #empty>
        <view
          v-if="userStore.isLogin"
          class="pt-[132rpx] flex flex-col items-center px-[48rpx] text-center"
        >
          <view class="relative flex h-[188rpx] w-[188rpx] items-center justify-center">
            <view class="absolute h-[164rpx] w-[164rpx] rounded-full bg-[#eeeeee]" />
            <view class="relative flex h-[136rpx] w-[136rpx] items-center justify-center rounded-[32rpx] border border-[#ebebeb] bg-white shadow-[0_20rpx_48rpx_rgba(0,0,0,0.06)]">
              <text class="iconfont icon-images leading-none text-[#c8c8c8]" style="font-size: 54rpx;" />
            </view>
          </view>
          <text class="mt-[36rpx] block text-[32rpx] font-bold leading-[44rpx] text-black">
            暂无收藏模板
          </text>
          <text class="mt-[16rpx] block max-w-[600rpx] text-[26rpx] leading-[40rpx] text-[#8e8e8e]">
            在模板详情页点击收藏，喜欢的灵感会出现在这里
          </text>
        </view>
      </template>
    </z-paging>
  </view>
</template>

<script setup lang="ts">
import { getCurrentInstance, nextTick, ref } from "vue";
import { onShow } from "@dcloudio/uni-app";
import ZPaging from "z-paging/components/z-paging/z-paging.vue";
import { listFavoriteTemplates, type TemplateItem } from "@/api/template";
import { useUserStore } from "@/store/modules/user";
import { navigateTo, routes } from "@/utils/router";

interface PagingRef {
  completeByTotal(data: TemplateItem[], total: number): Promise<unknown>;
  completeByError(cause: string): Promise<unknown>;
  reload(animate?: boolean): Promise<unknown>;
}

const userStore = useUserStore();
const favoriteTemplates = ref<TemplateItem[]>([]);
const pageSize = 20;
const instance = getCurrentInstance();

function getPaging() {
  return instance?.proxy?.$refs?.paging as PagingRef | undefined;
}

async function queryFavorites(pageNo: number, pageSize: number) {
  if (!userStore.isLogin) {
    await getPaging()?.completeByTotal([], 0);
    return;
  }

  try {
    const result = await listFavoriteTemplates({
      pageNum: pageNo,
      pageSize,
    });
    await getPaging()?.completeByTotal(result.rows || [], result.total || 0);
  } catch (error) {
    const message = error instanceof Error ? error.message : "收藏模板加载失败";
    await getPaging()?.completeByError(message);
  }
}

function getTemplateModelName(_template: TemplateItem) {
  return "OpenAI · ChatGPT";
}

function getTemplateTags(template: TemplateItem) {
  const tags = (template.tags || []).map((tag) => tag.tagName).filter(Boolean);
  return tags.length ? tags.slice(0, 2) : [template.categoryName || "模板"];
}

function goDetail(template: TemplateItem) {
  navigateTo(routes.templateDetail, {
    id: template.templateId,
  });
}

async function handleLogin() {
  try {
    await userStore.loginWithWechat();
    await nextTick();
    await getPaging()?.reload();
  } catch {
    // 登录失败时登录流程已经提示。
  }
}

onShow(async () => {
  if (userStore.isLogin) {
    await nextTick();
    await getPaging()?.reload();
  }
});
</script>
