<template>
  <view class="min-h-screen bg-[#f7f7f7] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto max-w-[750rpx] px-[32rpx] pb-[80rpx] pt-[36rpx]">
        <view class="mb-[28rpx] rounded-[32rpx] bg-black px-[34rpx] py-[34rpx] text-white">
          <text class="block text-[40rpx] font-bold leading-[52rpx] text-white">用户服务协议</text>
          <text class="mt-[10rpx] block text-[22rpx] leading-[32rpx] text-white/55">生效日期：2026年5月31日</text>
        </view>

        <view class="legal-card">
          <text class="legal-p">欢迎使用 AI智绘 小程序。请你在使用本服务前仔细阅读本协议。你点击同意、登录、上传图片、提交提示词、生成图片、充值或继续使用本服务，即表示你已阅读并同意本协议。</text>

          <text class="legal-h">1. 服务内容</text>
          <text class="legal-p">AI智绘向用户提供 AI 图片生成、提示词润色、参考图上传、模板使用、作品保存、积分充值、邀请奖励等服务。具体功能以小程序实际展示为准。</text>
          <text class="legal-p">我们可能根据运营需要调整、升级、暂停或下线部分功能、模型、模板、积分规则或服务入口。</text>

          <text class="legal-h">2. 账号与登录</text>
          <text class="legal-p">你可通过微信授权登录使用本服务。你应妥善保管账号及登录状态，因你主动分享、转让、泄露账号导致的损失，由你自行承担。</text>
          <text class="legal-p">如发现账号存在异常使用、违规生成、恶意刷取积分等行为，我们有权限制、暂停或终止相关账号的使用。</text>

          <text class="legal-h">3. AI 生成内容规则</text>
          <text class="legal-p">你承诺不会使用本服务生成、上传、发布或传播违法违规、侵犯他人权益、涉及暴力色情、恐怖赌博、诈骗仇恨、歧视侮辱、误导公众或其他不适宜的内容。</text>
          <text class="legal-p">AI 生成结果具有不确定性。我们不保证生成内容完全符合你的预期，也不保证生成内容的真实性、准确性、合法性、适商用性或不侵权。你将生成内容用于商业、发布或传播前，应自行确认相关权利和合规风险。</text>

          <text class="legal-h">4. 用户上传内容</text>
          <text class="legal-p">你上传的提示词、参考图片及其他素材，应当由你本人合法拥有或已获得合法授权。因你上传内容或使用生成结果引发的投诉、纠纷、索赔或损失，由你自行承担。</text>
          <text class="legal-p">为提供 AI 生图、提示词润色、作品展示、违规识别、故障排查等服务，我们可能会对你提交的提示词、参考图和生成结果进行必要处理。</text>

          <text class="legal-h">5. 积分、会员与支付</text>
          <text class="legal-p">本服务部分功能可能消耗积分。不同模型、清晰度、生成数量可能对应不同积分消耗，具体以提交生成前页面展示为准。</text>
          <text class="legal-p">你通过微信支付购买会员或积分包后，积分到账、有效期、会员权益、加赠规则等以购买页面展示及后台记录为准。</text>
          <text class="legal-p">因网络异常、支付回调延迟、模型服务失败等原因导致订单或积分状态异常的，你可以联系我们处理。若生成失败且符合退还规则，我们将按实际规则处理积分退还。</text>

          <text class="legal-h">6. 服务限制与风险</text>
          <text class="legal-p">AI 生图服务依赖第三方模型、网络、存储、支付等服务。因第三方服务异常、模型响应失败、网络波动、系统维护等原因，可能出现生成失败、排队、延迟、结果异常等情况。</text>

          <text class="legal-h">7. 知识产权</text>
          <text class="legal-p">小程序中的界面、模板、文字、图标、程序代码、运营内容等归我们或相关权利人所有。</text>
          <text class="legal-p">你通过本服务生成的图片，在不违反法律法规、本协议、第三方模型服务规则及他人合法权益的前提下，可按页面说明进行保存和使用。</text>

          <text class="legal-h">8. 违规处理</text>
          <text class="legal-p">如你违反本协议或相关法律法规，我们有权拒绝生成或展示相关内容、删除相关作品或记录、限制部分功能、冻结或终止账号，并依法配合有关部门处理。</text>

          <text class="legal-h">9. 协议变更</text>
          <text class="legal-p">我们可能根据法律法规、平台规则或业务变化更新本协议。更新后会通过小程序页面、弹窗或其他合理方式提示。你继续使用本服务，视为接受更新后的协议。</text>

          <text class="legal-h">10. 联系我们</text>
          <text class="legal-p">开发者/运营主体：请补充正式主体名称</text>
          <text class="legal-p">联系方式：请补充客服电话或邮箱</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<style scoped>
.legal-card {
  display: flex;
  flex-direction: column;
  gap: 18rpx;
  border-radius: 28rpx;
  background: #ffffff;
  padding: 34rpx;
  box-shadow: 0 12rpx 34rpx rgba(0, 0, 0, 0.05);
}

.legal-h {
  margin-top: 10rpx;
  color: #111111;
  font-size: 30rpx;
  font-weight: 800;
  line-height: 42rpx;
}

.legal-p {
  color: #4f5555;
  font-size: 25rpx;
  line-height: 42rpx;
}
</style>
