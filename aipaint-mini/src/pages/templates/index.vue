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
            @tap="activeChip = chip"
          >
            {{ chip }}
          </button>
        </view>
      </scroll-view>
    </view>

    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[36rpx] pb-[224rpx]">
        <view class="grid grid-cols-2 gap-[36rpx] pb-[36rpx]">
          <view
            v-for="template in templates"
            :key="template.title"
            class="overflow-hidden rounded-[48rpx] border border-[rgba(0,0,0,0.05)] bg-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)] active:scale-[0.98]"
          >
            <view class="h-[318rpx] overflow-hidden bg-[#eeeeee]">
              <image class="h-full w-full" mode="aspectFill" :src="template.image" />
            </view>
            <view class="p-[32rpx]">
              <text class="block text-[28rpx] font-semibold leading-[40rpx] text-black">
                {{ template.title }}
              </text>
              <text class="mt-[4rpx] block text-[24rpx] font-medium leading-[32rpx] text-[#636262]">
                {{ template.desc }}
              </text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

const chips = ["全部", "极简主义", "超现实", "赛博朋克", "水墨艺术", "抽象表现"];
const activeChip = ref("全部");

const templates = [
  {
    title: "构图几何",
    desc: "几何建筑风格",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuD3axI89PCaiyYvOKhN1Y0L8rUP_5dYHguX_E2SQedMqDNMqel_SuhSzcPMEirrfdFSNyFYpOFGNpPrcK8f-ok_5iZKhv5iZ0Pk0oK1JW0wFuLphL6F9FlzalGmvDLVyVshEGX3dGfxiVKI0Uj-IbHycZS82hs6rCIOUcLyqlAAYaoJi0S6B6Rm3iFGGxI-1b1Q5oBbJ0hHjROU53UyBOlWdKCQvH2j685HqF4oKl_42lyyxHBDbxzTs7T95AWoeBLiQW0KBe-CzJ6Q",
  },
  {
    title: "深墨之妙",
    desc: "有机水墨质感",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuBy4Q9qzhm5vU8r8SAi7IiqgHBba2f1v9frjXOycyfWXX6vCQc4OZgvCJVa8uRoqk_wBWQB1jEe-TP7w1qna1bo_nmz51GR9DyemGINyF8YWag-aKtwur1m5QjuojukeXFL3yKVD_bSs9Gw9WURfyY2WQ3pgIp2u0NHtFZc7bBpG22O-KUhWxhvapU72CV4OlqbFLilBazCO3u0ZoJC0cCD09ggyxU1QgMn2rFE8QvDS_dPMgawbYdKGa7Cyt9RSyvOpC4KNcQpKj4_",
  },
  {
    title: "孤寂雪原",
    desc: "极简自然景观",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuC-9Tqzn7ZcHRvuGnjFaB3GnIBcWMOm0fn-qWTnBR3BAUAp6McsCn7asVqoYbbE-joxK64KiFVQccmXVRnzSY0sGxOpDu6hHjzrxmdo-wcKQkZu2esDg80MEAbyOUXo3wMbzI6sdwVnbRtgXkR6KHsxCHlO-FtxK5kIxU9tWmQUSh1XBTZ1ZmO5Vb27SAYcxvNe874iFiMBreUTW0nmTwoJo8YyCtJqWRPJhAfNKcdmnn_hHdwXT8NmZEOTZt-Po2auaCMKvhrf3P9p",
  },
  {
    title: "未来结构",
    desc: "3D 超现实主义",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuDg1wfvmjr27Z35iMy0xuxdbO88ziI23TJdPT0cf-4dN0__IH1OurtM4pHdBJbYSeACOYz_YzyVxKCFixJIbhkbHkUntzOzu_dglucTVxnTideDIwlzDCRqptOf9i1AIWhQ2mJ2DkEjIc53u_3j7CREdvyLtnfzgm5u9F7UBS_QEK_6dPIULaOBMeG53jLzNU2B-SvWUniKhxBrB2b1_eQuYpRIA75Sx2BC0enE66CXtergZNJwS0BIWhczTRqOoCpCexFlPywMIkKN",
  },
  {
    title: "构图几何",
    desc: "几何建筑风格",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuD3axI89PCaiyYvOKhN1Y0L8rUP_5dYHguX_E2SQedMqDNMqel_SuhSzcPMEirrfdFSNyFYpOFGNpPrcK8f-ok_5iZKhv5iZ0Pk0oK1JW0wFuLphL6F9FlzalGmvDLVyVshEGX3dGfxiVKI0Uj-IbHycZS82hs6rCIOUcLyqlAAYaoJi0S6B6Rm3iFGGxI-1b1Q5oBbJ0hHjROU53UyBOlWdKCQvH2j685HqF4oKl_42lyyxHBDbxzTs7T95AWoeBLiQW0KBe-CzJ6Q",
  },
  {
    title: "深墨之妙",
    desc: "有机水墨质感",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuBy4Q9qzhm5vU8r8SAi7IiqgHBba2f1v9frjXOycyfWXX6vCQc4OZgvCJVa8uRoqk_wBWQB1jEe-TP7w1qna1bo_nmz51GR9DyemGINyF8YWag-aKtwur1m5QjuojukeXFL3yKVD_bSs9Gw9WURfyY2WQ3pgIp2u0NHtFZc7bBpG22O-KUhWxhvapU72CV4OlqbFLilBazCO3u0ZoJC0cCD09ggyxU1QgMn2rFE8QvDS_dPMgawbYdKGa7Cyt9RSyvOpC4KNcQpKj4_",
  },
  {
    title: "孤寂雪原",
    desc: "极简自然景观",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuC-9Tqzn7ZcHRvuGnjFaB3GnIBcWMOm0fn-qWTnBR3BAUAp6McsCn7asVqoYbbE-joxK64KiFVQccmXVRnzSY0sGxOpDu6hHjzrxmdo-wcKQkZu2esDg80MEAbyOUXo3wMbzI6sdwVnbRtgXkR6KHsxCHlO-FtxK5kIxU9tWmQUSh1XBTZ1ZmO5Vb27SAYcxvNe874iFiMBreUTW0nmTwoJo8YyCtJqWRPJhAfNKcdmnn_hHdwXT8NmZEOTZt-Po2auaCMKvhrf3P9p",
  },
  {
    title: "未来结构",
    desc: "3D 超现实主义",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuDg1wfvmjr27Z35iMy0xuxdbO88ziI23TJdPT0cf-4dN0__IH1OurtM4pHdBJbYSeACOYz_YzyVxKCFixJIbhkbHkUntzOzu_dglucTVxnTideDIwlzDCRqptOf9i1AIWhQ2mJ2DkEjIc53u_3j7CREdvyLtnfzgm5u9F7UBS_QEK_6dPIULaOBMeG53jLzNU2B-SvWUniKhxBrB2b1_eQuYpRIA75Sx2BC0enE66CXtergZNJwS0BIWhczTRqOoCpCexFlPywMIkKN",
  },
];

</script>
