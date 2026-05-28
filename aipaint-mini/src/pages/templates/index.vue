<template>
  <view class="flex h-screen flex-col overflow-hidden bg-[#f8f8f8] font-sans text-[#1a1c1c]">
    <view
      class="relative shrink-0 overflow-hidden bg-black text-white"
      :style="{
        paddingTop: `${navLayout.menuButtonTop}px`,
        paddingBottom: `${navLayout.navContentHeight - navLayout.menuButtonHeight}px`,
      }"
    >
      <view
        class="relative flex items-center px-[24rpx]"
        :style="{
          height: `${navLayout.menuButtonHeight}px`,
          paddingRight: `${navLayout.menuButtonRight + navLayout.menuButtonGap}px`,
        }"
      >
        <button
          class="m-0 flex h-[36px] w-[36px] shrink-0 items-center justify-center rounded-full bg-white/12 p-0 text-white active:scale-95 active:bg-white/22"
          hover-class="none"
          aria-label="搜索模板"
          @tap="openSearch"
        >
          <view class="search-mark search-mark--nav">
            <view class="search-mark__ring" />
            <view class="search-mark__handle" />
          </view>
        </button>

        <text
          class="pointer-events-none absolute left-1/2 top-1/2 max-w-[220rpx] -translate-x-1/2 -translate-y-1/2 truncate text-[16px] font-medium leading-[22px]"
        >
          生图模板
        </text>
      </view>
    </view>

    <view class="shrink-0 px-[36rpx] pt-[36rpx]">
      <scroll-view class="w-full whitespace-nowrap" scroll-x enhanced :show-scrollbar="false">
        <view class="flex gap-[16rpx] pb-[24rpx]">
          <button
            v-for="chip in chips"
            :key="chip.categoryCode"
            class="inline-flex w-auto min-w-0 shrink-0 items-center justify-center rounded-full px-[24rpx] py-[12rpx] text-[26rpx] font-semibold leading-[34rpx] active:scale-95"
            :class="chip.categoryName === activeChip ? 'bg-black text-white' : 'bg-[#e2e2e2] text-[#1a1c1c]'"
            @tap="handleChipChange(chip)"
          >
            {{ chip.categoryName }}
          </button>
        </view>
      </scroll-view>
    </view>

    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[16rpx] pb-[224rpx]">
        <view v-if="filteredTemplates.length" class="columns-2 gap-[16rpx] pb-[36rpx]">
          <view
            v-for="template in filteredTemplates"
            :key="template.templateId"
            class="mb-[24rpx] break-inside-avoid border border-gray-100 overflow-hidden rounded-[8rpx] bg-white active:scale-[0.98]"
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
                  class="rounded-full bg-[#f0f0f0] px-[18rpx] py-[6rpx] text-[22rpx] font-semibold leading-[30rpx] text-[#1a1c1c]"
                >
                  {{ tag }}
                </text>
              </view>
            </view>
          </view>
        </view>

        <view v-else class="flex min-h-[420rpx] flex-col items-center justify-center px-[48rpx] text-center">
          <view class="flex h-[112rpx] w-[112rpx] items-center justify-center rounded-full bg-white shadow-[0_12rpx_36rpx_rgba(0,0,0,0.06)]">
            <view class="search-mark search-mark--empty">
              <view class="search-mark__ring" />
              <view class="search-mark__handle" />
            </view>
          </view>
          <text class="mt-[28rpx] text-[30rpx] font-semibold leading-[40rpx] text-black">
            没找到相关模板
          </text>
          <text class="mt-[10rpx] text-[24rpx] leading-[34rpx] text-[#7a7a7a]">
            换个关键词，或切回全部分类看看
          </text>
          <button
            v-if="searchKeyword"
            class="mt-[28rpx] m-0 rounded-full bg-black px-[34rpx] py-[14rpx] text-[24rpx] font-semibold leading-[32rpx] text-white active:scale-95"
            hover-class="none"
            @tap="clearSearch"
          >
            清除搜索
          </button>
        </view>
      </view>
    </scroll-view>

    <view
      v-if="showSearchPanel"
      class="fixed inset-0 z-50 flex flex-col bg-[#f8f8f8]"
    >
      <view
        class="bg-black"
        :style="{
          paddingTop: `${navLayout.menuButtonTop}px`,
          paddingBottom: `${navLayout.navContentHeight - navLayout.menuButtonHeight}px`,
        }"
      >
        <view
          class="relative flex items-center px-[24rpx]"
          :style="{
            height: `${navLayout.menuButtonHeight}px`,
            paddingRight: `${navLayout.menuButtonRight + navLayout.menuButtonGap}px`,
          }"
        >
          <text
            class="pointer-events-none absolute left-1/2 top-1/2 max-w-[220rpx] -translate-x-1/2 -translate-y-1/2 truncate text-[16px] font-medium leading-[22px] text-white"
          >
            搜索模板
          </text>
        </view>
      </view>

      <view class="bg-white px-[32rpx] pb-[30rpx] pt-[24rpx] shadow-[0_10rpx_28rpx_rgba(0,0,0,0.04)]">
        <view class="flex items-center gap-[18rpx]">
          <view class="flex h-[76rpx] min-w-0 flex-1 items-center gap-[16rpx] rounded-full bg-[#f2f2f2] px-[24rpx]">
            <view class="search-mark search-mark--input">
              <view class="search-mark__ring" />
              <view class="search-mark__handle" />
            </view>
            <input
              v-model="searchDraft"
              class="h-full min-w-0 flex-1 text-[28rpx] font-medium leading-[40rpx] text-black"
              type="text"
              confirm-type="search"
              placeholder="搜索模板、风格、描述"
              placeholder-class="text-[#9a9a9a]"
              :focus="showSearchPanel"
              @confirm="commitSearch"
            />
            <button
              v-if="searchDraft"
              class="m-0 flex h-[44rpx] w-[44rpx] items-center justify-center rounded-full bg-[#dedede] p-0 text-[30rpx] leading-none text-[#777] active:bg-[#d4d4d4]"
              hover-class="none"
              aria-label="清空搜索"
              @tap="searchDraft = ''"
            >
              ×
            </button>
          </view>
          <button
            class="m-0 h-[76rpx] shrink-0 p-0 text-[28rpx] font-semibold leading-[76rpx] text-black active:opacity-65"
            hover-class="none"
            @tap="closeSearch"
          >
            取消
          </button>
        </view>
      </view>

      <view class="px-[32rpx] py-[28rpx]">
        <view v-if="searchKeyword" class="mb-[28rpx] rounded-[18rpx] bg-white px-[26rpx] py-[22rpx]">
          <text class="block text-[24rpx] leading-[32rpx] text-[#7a7a7a]">
            正在当前分类中筛选
          </text>
          <text class="mt-[6rpx] block text-[30rpx] font-semibold leading-[40rpx] text-black">
            “{{ searchKeyword }}” · {{ filteredTemplates.length }} 个结果
          </text>
        </view>

        <view v-if="recentSearches.length">
          <view class="mb-[18rpx] flex items-center justify-between">
            <text class="text-[26rpx] font-semibold leading-[36rpx] text-black">最近搜索</text>
            <button
              class="m-0 p-0 text-[24rpx] leading-[36rpx] text-[#7a7a7a] active:opacity-70"
              hover-class="none"
              @tap="recentSearches = []"
            >
              清空
            </button>
          </view>
          <view class="flex flex-wrap gap-[16rpx]">
            <button
              v-for="keyword in recentSearches"
              :key="keyword"
              class="m-0 rounded-full bg-white px-[24rpx] py-[12rpx] text-[26rpx] font-medium leading-[34rpx] text-black active:scale-95"
              hover-class="none"
              @tap="applyRecentSearch(keyword)"
            >
              {{ keyword }}
            </button>
          </view>
        </view>

        <view class="mt-[36rpx]">
          <text class="mb-[18rpx] block text-[26rpx] font-semibold leading-[36rpx] text-black">按风格找灵感</text>
          <view class="grid grid-cols-2 gap-[16rpx]">
            <button
              v-for="suggestion in searchSuggestions"
              :key="suggestion"
              class="m-0 flex min-h-[76rpx] items-center justify-center rounded-[18rpx] bg-white px-[18rpx] py-[14rpx] text-[26rpx] font-semibold leading-[34rpx] text-black active:scale-[0.98]"
              hover-class="none"
              @tap="applyRecentSearch(suggestion)"
            >
              {{ suggestion }}
            </button>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { navigateTo, routes } from "@/utils/router";
import { getTemplateCategories, listTemplates, type TemplateCategory, type TemplateItem } from "@/api/template";
import { getNavBarLayout } from "@/utils/nav-bar";

const chips = ref<TemplateCategory[]>([{ categoryName: "全部", categoryId: 0, categoryCode: "all" }]);
const activeChip = ref("全部");
const templates = ref<TemplateItem[]>([]);
const navLayout = getNavBarLayout();
const showSearchPanel = ref(false);
const searchDraft = ref("");
const searchKeyword = ref("");
const recentSearches = ref<string[]>([]);
const searchSuggestions = ["极简主义", "水墨艺术", "超现实", "海报营销"];

const filteredTemplates = computed(() => {
  const keyword = normalizeSearchText(searchKeyword.value);
  const source = activeChip.value === "全部"
    ? templates.value
    : templates.value.filter((item) => item.categoryName === activeChip.value);

  if (!keyword) {
    return source;
  }

  return source.filter((item) => getTemplateSearchText(item).includes(keyword));
});

async function loadCategories() {
  const categories = await getTemplateCategories();
  chips.value = [{ categoryName: "全部", categoryId: 0, categoryCode: "all" }, ...categories];
}

async function loadTemplates() {
  const selected = chips.value.find((item) => item.categoryName === activeChip.value);
  const params = !selected || selected.categoryCode === "all"
    ? { pageNum: 1, pageSize: 1000 }
    : { categoryId: String(selected.categoryId), pageNum: 1, pageSize: 1000 };
  const result = await listTemplates(params);
  templates.value = result.rows || [];
}

function getTemplateModelName(_template: TemplateItem) {
  return "OpenAI · ChatGPT";
}

function getTemplateTags(template: TemplateItem) {
  return [template.categoryName || "电影感"];
}

function getTemplateSearchText(template: TemplateItem) {
  return normalizeSearchText([
    template.title,
    template.categoryName,
    template.description,
    template.prompt,
    template.aiEngine,
    template.ratio,
  ].filter(Boolean).join(" "));
}

function normalizeSearchText(value: string) {
  return value.trim().toLowerCase();
}

function goDetail(template: TemplateItem) {
  navigateTo(routes.templateDetail, {
    id: template.templateId,
  });
}

async function handleChipChange(chip: TemplateCategory) {
  activeChip.value = chip.categoryName;
  searchKeyword.value = "";
  searchDraft.value = "";
  await loadTemplates();
}

function openSearch() {
  searchDraft.value = searchKeyword.value;
  showSearchPanel.value = true;
}

function closeSearch() {
  showSearchPanel.value = false;
  searchDraft.value = searchKeyword.value;
}

function commitSearch() {
  const keyword = normalizeSearchText(searchDraft.value);
  searchKeyword.value = keyword;
  searchDraft.value = keyword;
  if (keyword) {
    recentSearches.value = [keyword, ...recentSearches.value.filter((item) => item !== keyword)].slice(0, 6);
  }
  showSearchPanel.value = false;
}

function applyRecentSearch(keyword: string) {
  searchDraft.value = keyword;
  commitSearch();
}

function clearSearch() {
  searchDraft.value = "";
  searchKeyword.value = "";
}

onMounted(async () => {
  await Promise.all([loadCategories(), loadTemplates()]);
});
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

.search-mark--nav {
  color: #fff;
  transform: scale(1.08);
}

.search-mark--nav .search-mark__ring {
  border-width: 5rpx;
}

.search-mark--nav .search-mark__handle {
  height: 5rpx;
}

.search-mark--empty {
  color: #111;
  transform: scale(1.18);
}
</style>
