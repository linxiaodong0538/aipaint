系统文档
这里按当前代码真实链路说明：六个入口都是协议适配层，不互相 HTTP 调用，最终统一进入同一套生成、扣费、调度和存储链路。

请求路由图
用户自接 API 目前仍保留最高优先级；没有可用的用户自接 API 时，才进入平台后端池。外接接口不会反向请求站内 /api/images/*。

入口
页面文生图
image_generation
POST /api/images/generate
页面图生图
image_edit
POST /api/images/edit
页面对话生图
chat
POST /api/images/chat
外部文生图 API
image_generation
POST /v1/images/generations
外部图生图 API
image_edit
POST /v1/images/edits
外部 Responses API
responses
POST /v1/responses
统一处理
1
校验登录态或外部 API Key
2
把页面表单或 OpenAI 兼容请求转换为统一运行参数
3
计算积分和审核成本
4
调用 runImageGenerationForUser 进入统一生成链路
分组选择
1
外部 API Key 绑定分组优先
2
其次使用用户在设置里选择的生图后端分组
3
没有显式选择时使用默认启用分组
4
分组会检查套餐权限、是否启用、内容安全开关
后端落点
用户自接 API
如果用户设置了自己的 OpenAI 兼容 API，会先直接使用它；这是过渡保留逻辑。

Web 账号池
通过 ChatGPT Web 链路承接页面文生图、图生图和对话生图。

Codex/Responses 账号池
通过 Responses 语义承接 responses，也能把 image generation/edit 转成 responses 请求。

外接 API 后端
管理员配置的 OpenAI 兼容 Base URL/API Key；按当前请求类型调用 images 或 responses 端点。

六个接口的关系
所以关系不是“外接 API 调页面 API”，而是“六个入口共享同一个 service 层”。

页面三接口
/api/images/generate、/api/images/edit、/api/images/chat
浏览器登录态入口，只负责页面表单、参考图和站内流式事件适配。
外接三接口
/v1/images/generations、/v1/images/edits、/v1/responses
/api/v1/* 是同一 handler 的别名；只负责 API Key、OpenAI 兼容请求和响应格式适配。
共同核心
runImageGenerationForUser
扣费、审核、排队、账号池选择、错误标记、冷却、失败退款和图片存储都在这一层。
后端执行
generateImage / editImage / generateChatImage
按命中的成员转换成 ChatGPT Web、Codex/Responses 或外接 API 请求。
外接 API 详细文档
以下按 OpenAI 官方接口形态整理本站当前支持范围。粗体字段为本站扩展或兼容增强，不属于标准 OpenAI 字段。

Base URL
https://gpt2image.superapi.buzz
通用规则
所有外接接口都需要 Authorization: Bearer <本站 API Key>。
图片生成和图片编辑接口需要入门版及以上；Responses 接口需要专业版及以上。
/api/v1/* 与 /v1/* 使用同一套 handler，只是路径别名。
response_format 控制返回 URL 或 base64；output_format 才控制图片文件格式，二者不是同一个字段。
错误响应采用 OpenAI 风格 error 对象；本站可能额外返回 generation_id、generationId、credits_consumed 方便排查和对账。
外接 API Key 绑定的后端分组优先；未绑定时使用用户默认分组，再回退默认启用分组。
官方参考
Images API
Responses API
Models API
GET
/v1/models
无请求体
List models
兼容 OpenAI List models，用于列出当前 API Key 所属用户可见的图片模型和 Responses 模型。

请求示例
curl https://gpt2image.superapi.buzz/v1/models \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY"
响应示例
{
  "object": "list",
  "data": [
    {
      "id": "gpt-image-2",
      "object": "model",
      "created": 0,
      "owned_by": "gpt2image"
    }
  ]
}
请求字段
字段
要求
说明
Authorization
必填 header
Bearer <本站 API Key>。
返回与流式
返回字段
说明
object
固定为 list。
data[].id
模型 ID。包含本站开放的图片模型以及当前套餐可用的 Responses 模型。
data[].object / created / owned_by
兼容 OpenAI model object 结构。
实现说明
本站当前只实现模型列表，不实现 /v1/models/{model} 详情。
返回模型会按套餐过滤；Ultra 用户可见更多 Responses 模型。
POST
/v1/images/generations
application/json
Create image
兼容 OpenAI Images generation。请求会转换成 image_generation 调度类型，进入统一生成链路。

请求示例
# 1. 官方 Images 风格，默认返回 b64_json
curl https://gpt2image.superapi.buzz/v1/images/generations \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2",
    "prompt": "A cute baby sea otter",
    "n": 1,
    "size": "1024x1024",
    "quality": "medium",
    "moderation": "auto"
  }'

# 2. 返回 URL，并关闭本站提示词优化
curl https://gpt2image.superapi.buzz/v1/images/generations \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-1.5",
    "prompt": "一张赛博朋克城市夜景，雨后霓虹反光",
    "n": 2,
    "size": "1024x1024",
    "quality": "high",
    "moderation": "low",
    "response_format": "url",
    "output_format": "webp",
    "output_compression": 85,
    "prompt_optimization": false
  }'

# 3. Codex/Responses 后端专用参数；普通 Images API 后端可能忽略
curl https://gpt2image.superapi.buzz/v1/images/generations \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2",
    "prompt": "生成一张 16:9 产品海报",
    "size": "1536x864",
    "response_format": "url",
    "output_format": "jpeg",
    "output_compression": 90,
    "gptModel": "gpt-5.4",
    "thinking": "high",
    "promptOptimization": false
  }'

# 4. 流式返回；也可用 Accept: text/event-stream 触发
curl -N https://gpt2image.superapi.buzz/v1/images/generations \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Accept: text/event-stream" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2",
    "prompt": "一张透明玻璃材质的未来感咖啡杯",
    "size": "1024x1024",
    "response_format": "url",
    "stream": true
  }'
响应示例
{
  "created": 1713833628,
  "data": [
    {
      "url": "https://gpt2image.superapi.buzz/api/storage/generations/...",
      "revised_prompt": "..."
    }
  ],
  "usage": null
}

# stream=true 时的 SSE 片段
event: image_generation.partial_image
data: {"type":"image_generation.partial_image","index":0,"partial_image_index":0,"url":"https://gpt2image.superapi.buzz/api/storage/generations/..."}

event: image_generation.completed
data: {"type":"image_generation.completed","index":0,"generation_id":"...","generationId":"...","model":"gpt-image-2","size":"1024x1024","credits_consumed":1.31,"url":"https://gpt2image.superapi.buzz/api/storage/generations/...","data":[{"url":"https://gpt2image.superapi.buzz/api/storage/generations/...","revised_prompt":"..."}]}
请求字段
字段
要求
说明
prompt
必填
图片提示词，最多 4000 字符。
model
可选
图片模型。本站只接受 gpt-image-* 类图片模型；Responses 对话模型请使用 /v1/responses。
n
可选
生成数量，1 到 10。
size
可选
目标尺寸。支持本站分辨率校验规则，非法尺寸会返回参数错误。
quality
可选
auto、low、medium、high。
moderation
可选
auto 或 low。
response_format
可选
url 或 b64_json。默认 b64_json；url 会返回本站存储 URL。
output_format
可选
png、jpeg、webp。控制实际输出图片格式；不同上游支持情况可能不同。
output_compression
可选
0 到 100，仅对 jpeg/webp 有意义；数值越高质量越高。
stream
可选
true 时返回 text/event-stream。
promptOptimization / prompt_optimization
本站扩展
可选
控制平台是否继续优化 prompt。若 prompt 已是优化后的最终提示词，建议传 false。
gptModel / gpt_model
本站扩展
可选
当命中 Codex/Responses 账号池时，作为 Responses 顶层 GPT 模型；普通 Images API 后端可能忽略。
thinking
本站扩展
可选
minimal、none、low、medium、high、xhigh。仅针对 Codex/Responses 后端；Web 或普通 Images API 后端可能忽略。
返回与流式
返回字段
说明
created
Unix 秒时间戳。
data[].b64_json / data[].url
按 response_format 返回 base64 或 URL。
data[].revised_prompt
上游返回的改写提示词，若有则返回。
SSE image_generation.partial_image
仅 stream=true 或 Accept: text/event-stream 时返回；表示一张局部图片。
SSE image_generation.completed
仅流式模式返回；表示单张图片已完成，事件 data 会带 generation_id、credits_consumed、model、size 和最终图片。
实现说明
该接口不会调用页面 /api/images/generate，而是直接进入共享 service 层。
如果命中 Responses 账号池，内部会把图片请求转换成 Responses image_generation tool 请求。
Web 后端无法严格控制输出格式；本站保存时会按实际图片头识别扩展名和 MIME。
如果实际生成尺寸与请求尺寸不一致，本站会按检测到的实际尺寸修正记录和计费。
官方 Images API 可能返回 usage；本站当前非流式 JSON 响应通常返回 usage: null，流式完成和错误事件会带 credits_consumed。
POST
/v1/images/edits
multipart/form-data 或 application/json
Create image edit
兼容 OpenAI Images edit。multipart 可上传图片；JSON 可使用公网图片 URL。

请求示例
# 1. multipart 上传参考图
curl https://gpt2image.superapi.buzz/v1/images/edits \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -F model="gpt-image-2" \
  -F prompt="把参考图改成电影海报风格" \
  -F n="1" \
  -F size="1024x1024" \
  -F quality="high" \
  -F moderation="auto" \
  -F response_format="url" \
  -F output_format="jpeg" \
  -F output_compression="90" \
  -F 'image[]=@/path/to/reference.png'

# 2. multipart 多参考图 + mask + Codex/Responses 参数
curl https://gpt2image.superapi.buzz/v1/images/edits \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -F model="gpt-image-2" \
  -F prompt="只重绘 mask 区域，保持人物脸部不变" \
  -F size="1536x1024" \
  -F quality="medium" \
  -F response_format="b64_json" \
  -F promptOptimization="false" \
  -F gpt_model="gpt-5.4" \
  -F thinking="medium" \
  -F 'image[]=@/path/to/person.png' \
  -F 'image_2=@/path/to/style.png' \
  -F mask="@/path/to/mask.png"

# 3. JSON 图片 URL；推荐 images，image_url/image_urls 只是兼容快捷字段
curl https://gpt2image.superapi.buzz/v1/images/edits \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-2",
    "prompt": "把参考图改成干净的电商主图",
    "images": [
      "https://example.com/reference.png",
      { "image_url": "https://example.com/detail.webp" }
    ],
    "image_url": "https://example.com/single-reference.png",
    "image_urls": ["https://example.com/extra.jpg"],
    "mask_url": "https://example.com/mask.png",
    "mask_image_url": "https://example.com/mask-alt.png",
    "n": 1,
    "size": "1024x1024",
    "quality": "auto",
    "moderation": "low",
    "response_format": "url",
    "output_format": "webp",
    "output_compression": 80,
    "prompt_optimization": false,
    "gptModel": "gpt-5.4-mini",
    "thinking": "low"
  }'

# 4. 流式图生图
curl -N https://gpt2image.superapi.buzz/v1/images/edits \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Accept: text/event-stream" \
  -F model="gpt-image-2" \
  -F prompt="保留构图，改成水彩插画风格" \
  -F size="1024x1024" \
  -F response_format="url" \
  -F stream="true" \
  -F 'image=@/path/to/reference.png'
响应示例
{
  "created": 1713833628,
  "data": [
    {
      "url": "https://gpt2image.superapi.buzz/api/storage/generations/...",
      "revised_prompt": "..."
    }
  ],
  "usage": null
}

# stream=true 时的 SSE 片段
event: image_edit.partial_image
data: {"type":"image_edit.partial_image","index":0,"partial_image_index":0,"url":"https://gpt2image.superapi.buzz/api/storage/generations/..."}

event: image_edit.completed
data: {"type":"image_edit.completed","index":0,"generation_id":"...","generationId":"...","model":"gpt-image-2","size":"1024x1024","credits_consumed":1.31,"url":"https://gpt2image.superapi.buzz/api/storage/generations/...","data":[{"url":"https://gpt2image.superapi.buzz/api/storage/generations/...","revised_prompt":"..."}]}
请求字段
字段
要求
说明
prompt
必填
编辑提示词，最多 4000 字符。
image / image[] / image_*
multipart 必填
参考图文件，最多 16 张。
images
JSON 可选
图片引用数组。本站支持字符串 URL 或 { image_url/url }；file_id 当前不支持。
mask
可选
PNG mask 文件；JSON 中可传 URL 形式的 mask 引用。
model
可选
图片模型，需为 gpt-image-* 类图片模型。
n
可选
生成数量，1 到 10。
size
可选
目标尺寸。
quality
可选
auto、low、medium、high。
moderation
可选
auto 或 low。
response_format
可选
url 或 b64_json。默认 b64_json。
output_format
可选
png、jpeg、webp。控制实际输出图片格式；不同上游支持情况可能不同。
output_compression
可选
0 到 100，仅对 jpeg/webp 有意义；数值越高质量越高。
stream
可选
true 时返回 text/event-stream。
image_url / image_urls
本站扩展
JSON 或表单可选
兼容快捷字段。推荐使用 images；若同时传入，本站会合并到同一参考图列表并按 URL 去重。
mask_url / mask_image_url
本站扩展
JSON 或表单可选
本站便捷写法：直接传 mask 图片 URL。
promptOptimization / prompt_optimization
本站扩展
可选
控制平台是否继续优化 prompt。若 prompt 已是优化后的最终提示词，建议传 false。
gptModel / gpt_model
本站扩展
可选
同文生图接口。
thinking
本站扩展
可选
minimal、none、low、medium、high、xhigh。仅针对 Codex/Responses 后端；Web 或普通 Images API 后端可能忽略。
返回与流式
返回字段
说明
created / data[]
与 /v1/images/generations 相同。
SSE image_edit.partial_image
仅 stream=true 或 Accept: text/event-stream 时返回；表示一张局部编辑图片。
SSE image_edit.completed
仅流式模式返回；表示单张编辑图片已完成，事件 data 会带 generation_id、credits_consumed、model、size 和最终图片。
实现说明
URL 图片会先由本站服务端下载并校验公网可访问性、类型和大小。
不支持私网、localhost、metadata/internal 域名或带用户名密码的 URL。
官方 JSON file_id 图片引用当前未实现，请使用公网 image_url 或 multipart 上传。
POST
/v1/responses
application/json
Create response
基于 OpenAI Responses API 的生图适配入口。它会按 responses 调度类型选择 Codex/Responses 账号池或外接 /responses API 后端。

请求示例
# 1. 最小 Responses 生图请求；需要 Pro 套餐
curl https://gpt2image.superapi.buzz/v1/responses \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.4",
    "input": "生成一张 1:1 的未来感产品渲染图",
    "size": "1024x1024",
    "quality": "high",
    "moderation": "auto"
  }'

# 2. 显式 image_generation tool，并指定图片模型
curl https://gpt2image.superapi.buzz/v1/responses \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.4",
    "input": "生成一张横版科技产品 KV",
    "tools": [{ "type": "image_generation", "model": "gpt-image-2" }],
    "tool_choice": { "type": "image_generation" },
    "size": "1536x864",
    "quality": "medium",
    "reasoning": { "effort": "low" },
    "store": true
  }'

# 3. 带参考图的 Responses 输入
curl https://gpt2image.superapi.buzz/v1/responses \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.4-mini",
    "input": [
      {
        "role": "user",
        "content": [
          { "type": "input_text", "text": "参考这张图，换成冬季海报风格" },
          { "type": "input_image", "image_url": "https://example.com/reference.png" }
        ]
      }
    ],
    "tools": [{ "type": "image_generation", "model": "gpt-image-2" }],
    "size": "1024x1024",
    "output_format": "webp",
    "output_compression": 85,
    "moderation": "low"
  }'

# 4. 续接上一轮，并使用流式返回
curl -N https://gpt2image.superapi.buzz/v1/responses \
  -H "Authorization: Bearer $GPT2IMAGE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.4",
    "previous_response_id": "resp_previous_id",
    "input": "在上一张图基础上加一个月亮",
    "tools": [{ "type": "image_generation", "model": "gpt-image-2" }],
    "size": "1024x1024",
    "reasoning": { "effort": "minimal" },
    "stream": true
  }'
响应示例
{
  "id": "resp_...",
  "object": "response",
  "created_at": 1713833628,
  "status": "completed",
  "model": "gpt-5.4",
  "output": [
    {
      "id": "ig_...",
      "type": "image_generation_call",
      "status": "completed",
      "result": "..."
    }
  ],
  "usage": null,
  "metadata": {
    "generation_id": "...",
    "credits_consumed": 1.31,
    "size": "1024x1024"
  }
}

# stream=true 时的 SSE 片段
event: response.output_item.done
data: {"type":"response.output_item.done","item":{"id":"ig_...","type":"image_generation_call","status":"completed","result":"..."}}

event: response.completed
data: {"type":"response.completed","response":{"id":"resp_...","object":"response","created_at":1713833628,"status":"completed","model":"gpt-5.4","output":[{"id":"ig_...","type":"image_generation_call","status":"completed","result":"..."}],"usage":null,"metadata":{"generation_id":"...","credits_consumed":1.31,"size":"1024x1024"}}}
请求字段
字段
要求
说明
model
可选
Responses 顶层模型。可用模型以 /v1/models 返回和套餐权限为准。
input
必填
字符串，或消息数组。消息 content 支持字符串、input_text/output_text，以及 input_image.image_url。
previous_response_id
可选
续接上一轮 response。本站会读取内部保存的 webConversation/fallbackHistory 延续上下文。
tools
可选
若显式传入，必须包含 { type: "image_generation" }；未传时本站会自动补 image_generation。图片模型请放在 image_generation tool 的 model 字段。
tool_choice
可选
兼容接收字段。本站调度只要求 tools 包含 image_generation；是否按 tool_choice 执行取决于命中的 Responses 上游。
stream
可选
true 时返回 Responses 风格 SSE 事件。
store
可选
兼容接收字段；本站内部会自行保存必要续聊状态，不保证按官方 store 语义透传。
reasoning.effort
可选
支持 minimal、none、low、medium、high、xhigh；最终是否生效取决于命中的后端。
size
本站扩展
可选
本站便捷字段：未在 image_generation tool 内指定尺寸时，作为本次生图 size 使用。
quality
本站扩展
可选
本站便捷字段：作为本次生图 quality 运行参数使用。
moderation
本站扩展
可选
本站便捷字段：作为本次生图 moderation 运行参数使用。
output_format
本站扩展
可选
本站便捷字段：未在 image_generation tool 内指定输出格式时，作为本次 output_format 使用。也可直接写在 image_generation tool 里。
output_compression
本站扩展
可选
本站便捷字段：未在 image_generation tool 内指定压缩率时，作为本次 output_compression 使用。
返回与流式
返回字段
说明
id / object / created_at / status / model / output
兼容 Responses response 对象的基本结构。
output[].type = image_generation_call
图片结果放在 result 字段，值为 b64_json。
output[].type = message
若上游返回文本，会以 output_text 返回。
metadata.generation_id / credits_consumed / size
本站扩展
本站生成记录、扣费和尺寸信息。
SSE response.output_item.done / response.completed
流式输出项完成和整体完成事件。
SSE response.output_text.delta / response.reasoning_summary_text.delta
文本和思考摘要增量事件。
实现说明
该接口需要专业版或更高套餐。
该接口不是通用 Chat Completions；/v1/chat/completions 当前仍不支持。
input_image 只支持 image_url/data URL；file_id/file 输入当前不会作为参考图使用。
显式传 tools 但不包含 image_generation 会返回错误，避免模型只产出文本而不生图。
入口到后端的映射
页面请求
入口
站内接口
调度类型
后端池行为
创作页文生图
/api/images/generate
image_generation
可命中用户自接 API、Web 账号、Codex/Responses 账号或外接 API 后端。
创作页图生图
/api/images/edit
image_edit
参考图先进入站内接口，再按选中的后端分组调度。
创作页对话生图
/api/images/chat
chat
按 chat 类型选择后端；可命中 Web 账号、Codex/Responses 账号或支持 /responses 的外接 API 后端。
外接 API 请求
入口
兼容接口
调度类型
后端池行为
OpenAI images generation
/v1/images/generations
image_generation
验证 API Key 和套餐后进入同一生成链路；默认返回 b64_json，可显式请求 url。
OpenAI images edit
/v1/images/edits
image_edit
multipart 图片会被转成统一图片输入，再按分组调度。
OpenAI Responses
/v1/responses
responses
无 tools 时平台补 image_generation；显式传 tools 时必须包含 image_generation。按 responses 类型只调度 Codex/Responses 分组或外接 /responses API。
OpenAI models
/v1/models
-
只返回当前套餐/API Key 可见模型，不触发后端池调度。