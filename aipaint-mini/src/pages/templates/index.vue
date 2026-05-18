<template>
  <view class="flex h-screen flex-col overflow-hidden bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <view class="shrink-0 px-[36rpx] pt-[36rpx]">
      <scroll-view class="w-full whitespace-nowrap" scroll-x enhanced :show-scrollbar="false">
        <view class="flex gap-[16rpx] pb-[24rpx]">
          <button
            v-for="chip in chips"
            :key="chip"
            class="inline-flex w-auto min-w-0 shrink-0 items-center justify-center rounded-full px-[24rpx] py-[12rpx] text-[26rpx] font-semibold leading-[34rpx] active:scale-95"
            :class="chip === activeChip ? 'bg-black text-white' : 'bg-[#e2e2e2] text-[#1a1c1c]'"
            @tap="handleChipChange(chip)"
          >
            {{ chip }}
          </button>
        </view>
      </scroll-view>
    </view>

    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[24rpx] pb-[224rpx]">
        <view class="grid grid-cols-2 gap-[24rpx] pb-[36rpx]">
          <view
            v-for="template in filteredTemplates"
            :key="template.templateId"
            class="overflow-hidden rounded-[32rpx] border border-[rgba(0,0,0,0.05)] bg-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)] active:scale-[0.98]"
            @tap="goDetail(template)"
          >
            <view class="h-[440rpx] overflow-hidden bg-[#eeeeee]">
              <image class="h-full w-full" mode="aspectFill" :src="template.coverUrl" />
            </view>
            <view class="px-[20rpx] py-[18rpx]">
              <text class="block text-[28rpx] font-semibold leading-[38rpx] text-black">
                {{ template.title }}
              </text>
              <text class="mt-[8rpx] block text-[24rpx] leading-[32rpx] text-[#8a8a8a]">
                {{ template.description || template.category }}
              </text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { navigateTo, routes } from "@/utils/router";
import { getTemplateCategories, listTemplates, type TemplateItem } from "@/api/template";

const chips = ref<string[]>(["全部"]);
const activeChip = ref("全部");
const templates = ref<TemplateItem[]>([]);

const filteredTemplates = computed(() => {
  if (activeChip.value === "全部") {
    return templates.value;
  }
  return templates.value.filter((item) => item.category === activeChip.value);
});

async function loadCategories() {
  const categories = await getTemplateCategories();
  chips.value = ["全部", ...categories];
}

async function loadTemplates() {
  const params = activeChip.value === "全部" ? undefined : { category: activeChip.value };
  templates.value = await listTemplates(params);
}

function goDetail(template: TemplateItem) {
  navigateTo(routes.templateDetail, {
    id: template.templateId,
  });
}

async function handleChipChange(chip: string) {
  activeChip.value = chip;
  await loadTemplates();
}

onMounted(async () => {
  await Promise.all([loadCategories(), loadTemplates()]);
});
</script>
