> ## Documentation Index
> Fetch the complete documentation index at: https://docs.toapis.com/llms.txt
> Use this file to discover all available pages before exploring further.

# GPT-Image-2 官方渠道 图像生成

> 使用 OpenAI 官方 gpt-image-2 模型生成图像，支持文生图 / 图生图 / 局部重绘（mask）三合一，1K / 2K / 4K 分辨率档位

* OpenAI 官方 `gpt-image-2` 模型，通过 `gpt-image-1.5-official` 模型名调用
* 异步处理模式，返回任务 ID 用于后续查询
* 支持文生图、多参考图图生图、遮罩局部重绘（inpainting）
* 支持 13 种宽高比，可选 1K / 2K / 4K 三档分辨率
* 单次最多生成 4 张图，参考图最多 16 张

<Warning>
  **注意**：`gpt-image-1.5-official` 不支持透明背景，传入 `background: "transparent"` 会被静默降级为 `auto`。
</Warning>

## Authorizations

<ParamField header="Authorization" type="string" required>
  所有接口均需要使用 Bearer Token 进行认证

  获取 API Key：访问 [API Key 管理页面](https://toapis.com/console/token) 获取您的 API Key

  使用时在请求头中添加：

  ```
  Authorization: Bearer YOUR_API_KEY
  ```
</ParamField>

## Body

<ParamField body="model" type="string" default="gpt-image-1.5-official" required>
  图像生成模型名称

  固定填写 `gpt-image-1.5-official`
</ParamField>

<ParamField body="prompt" type="string" required>
  图像生成的文本描述

  支持中英文，建议详细描述场景、风格和构图
</ParamField>

<ParamField body="size" type="string" default="1:1">
  画面宽高比

  支持以下比例，也可传 `auto` 由服务端根据 prompt 自动选择：

  `1:1` · `3:2` · `2:3` · `4:3` · `3:4` · `5:4` · `4:5` · `16:9` · `9:16` · `2:1` · `1:2` · `21:9` · `9:21`

  <Warning>
    4K 档仅支持 6 个比例：`16:9` / `9:16` / `2:1` / `1:2` / `21:9` / `9:21`，其余比例请使用 `2K`。
  </Warning>
</ParamField>

<ParamField body="resolution" type="string" default="1k">
  分辨率档位

  * `1k` — 1024 基准，速度快，日常够用（默认）
  * `2k` — 2048 基准，适合海报 / 高清需求
  * `4k` — 3840 基准，仅支持上述 6 个比例，`high` 质量下耗时可达 130s
</ParamField>

### 尺寸对照表

| size   | 1K          | 2K          | 4K          |
| ------ | ----------- | ----------- | ----------- |
| `1:1`  | `1024x1024` | `2048x2048` | 不支持         |
| `3:2`  | `1536x1024` | `2048x1360` | 不支持         |
| `2:3`  | `1024x1536` | `1360x2048` | 不支持         |
| `4:3`  | `1024x768`  | `2048x1536` | 不支持         |
| `3:4`  | `768x1024`  | `1536x2048` | 不支持         |
| `5:4`  | `1280x1024` | `2560x2048` | 不支持         |
| `4:5`  | `1024x1280` | `2048x2560` | 不支持         |
| `16:9` | `1536x864`  | `2048x1152` | `3840x2160` |
| `9:16` | `864x1536`  | `1152x2048` | `2160x3840` |
| `2:1`  | `2048x1024` | `2688x1344` | `3840x1920` |
| `1:2`  | `1024x2048` | `1344x2688` | `1920x3840` |
| `21:9` | `2016x864`  | `2688x1152` | `3840x1648` |
| `9:21` | `864x2016`  | `1152x2688` | `1648x3840` |

<ParamField body="quality" type="string" default="high">
  图片质量

  * `low` — 快速省钱，适合草稿/预览
  * `medium` — 平衡速度与质量
  * `high` — 最高精度，默认值（4K + high 耗时可达 120s+）
</ParamField>

<ParamField body="output_format" type="string" default="png">
  输出格式

  * `png` — 默认
  * `jpeg` — 文件更小（支持压缩）

  <Note>Azure OpenAI 不支持 `webp` 格式。</Note>
</ParamField>

<ParamField body="output_compression" type="integer" default={100}>
  JPEG 压缩强度，范围 `0–100`（`0` 不压缩，`100` 最大压缩，默认 `100`）

  仅对 `output_format: "jpeg"` 有效
</ParamField>

<ParamField body="n" type="integer" default={1}>
  生成图片张数

  取值范围：`1 ~ 10`
</ParamField>

<ParamField body="image_urls" type="string[]">
  参考图 URL 数组，用于图生图

  * 最多 **16 张**，须为公网可访问的稳定 URL
  * 可先使用 [上传图片接口](/docs/cn/api-reference/uploads/images) 获取 URL
</ParamField>

<ParamField body="mask_url" type="string">
  遮罩图 URL，用于局部重绘（inpainting）

  需搭配 `image_urls` 使用，遮罩图尺寸须与首张参考图一致，且需包含 Alpha 通道（透明区域为待重绘区域）
</ParamField>

## Response

<ResponseField name="id" type="string">
  任务唯一标识符，用于查询任务状态
</ResponseField>

<ResponseField name="object" type="string">
  对象类型，固定为 `generation.task`
</ResponseField>

<ResponseField name="model" type="string">
  使用的模型名称
</ResponseField>

<ResponseField name="status" type="string">
  任务状态

  * `queued` — 排队等待处理
  * `in_progress` — 处理中
  * `completed` — 成功完成
  * `failed` — 失败
</ResponseField>

<ResponseField name="progress" type="integer">
  任务进度百分比（0-100）
</ResponseField>

<ResponseField name="created_at" type="integer">
  任务创建时间戳（Unix 时间戳）
</ResponseField>

<RequestExample>
  ```bash 文生图 theme={null}
  curl --request POST \
    --url https://toapis.com/v1/images/generations \
    --header 'Authorization: Bearer <token>' \
    --header 'Content-Type: application/json' \
    --data '{
      "model": "gpt-image-1.5-official",
      "prompt": "星空下的古老城堡，电影感光影，超写实风格",
      "size": "16:9",
      "resolution": "2k",
      "quality": "high",
      "n": 1
    }'
  ```

  ```bash 4K 壁纸 theme={null}
  curl --request POST \
    --url https://toapis.com/v1/images/generations \
    --header 'Authorization: Bearer <token>' \
    --header 'Content-Type: application/json' \
    --data '{
      "model": "gpt-image-1.5-official",
      "prompt": "雪山日出全景，极致细节",
      "size": "16:9",
      "resolution": "4k",
      "quality": "high",
      "output_format": "jpeg",
      "output_compression": 90
    }'
  ```

  ```bash 图生图（多参考图） theme={null}
  curl --request POST \
    --url https://toapis.com/v1/images/generations \
    --header 'Authorization: Bearer <token>' \
    --header 'Content-Type: application/json' \
    --data '{
      "model": "gpt-image-1.5-official",
      "prompt": "将两张参考图融合成一张插画海报，保留主体轮廓",
      "size": "1:1",
      "quality": "high",
      "image_urls": [
        "https://example.com/input-a.png",
        "https://example.com/input-b.png"
      ]
    }'
  ```

  ```bash 局部重绘（mask） theme={null}
  curl --request POST \
    --url https://toapis.com/v1/images/generations \
    --header 'Authorization: Bearer <token>' \
    --header 'Content-Type: application/json' \
    --data '{
      "model": "gpt-image-1.5-official",
      "prompt": "把背景换成沙漠日落",
      "size": "1:1",
      "quality": "medium",
      "image_urls": ["https://example.com/photo.png"],
      "mask_url": "https://example.com/mask.png"
    }'
  ```

  ```javascript JavaScript theme={null}
  const response = await fetch('https://toapis.com/v1/images/generations', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer your-ToAPIs-key',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-image-1.5-official',
      prompt: '星空下的古老城堡，电影感光影，超写实风格',
      size: '16:9',
      resolution: '2k',
      quality: 'high',
      n: 1
    })
  });

  const task = await response.json();
  console.log(task.id, task.status);
  ```
</RequestExample>

<ResponseExample>
  ```json 200 theme={null}
  {
    "id": "tsk_img_01KPTXXXXXXXXXXXXXXX",
    "object": "generation.task",
    "model": "gpt-image-1.5-official",
    "status": "queued",
    "progress": 0,
    "created_at": 1703884800,
    "metadata": {}
  }
  ```
</ResponseExample>