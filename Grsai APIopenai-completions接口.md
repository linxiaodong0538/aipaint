# /v1/chat/completions

## OpenAPI Specification

```yaml
openapi: 3.0.1
info:
  title: ''
  description: ''
  version: 1.0.0
paths:
  /v1/chat/completions:
    post:
      summary: /v1/chat/completions
      deprecated: false
      description: |-
        基础节点：
        https://grsaiapi.com                (全球节点)
        https://grsai.dakka.com.cn     (国内节点)

        例子：
        https://grsaiapi.com/v1/chat/completions
        https://grsai.dakka.com.cn/v1/chat/completions
      tags:
        - openai-completions接口
      parameters:
        - name: base_url
          in: path
          description: ''
          required: true
          schema:
            type: string
        - name: Authorization
          in: header
          description: 请前往以下页面获取APIKEY：https://grsai.ai/zh/dashboard/api-keys
          required: false
          example: Bearer sk-xxxxxxxxxxx
          schema:
            type: string
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                model:
                  type: string
                  title: 模型名称
                  description: 支持所有模型
                stream:
                  type: boolean
                  title: stream流
                  default: true
                messages:
                  type: array
                  items:
                    type: object
                    properties:
                      role:
                        type: string
                        title: user
                      content:
                        type: string
                        title: 提示词内容
                    x-apifox-orders:
                      - role
                      - content
              required:
                - model
                - messages
                - stream
              x-apifox-orders:
                - model
                - stream
                - messages
            examples:
              '1':
                value:
                  model: gemini-3.1-pro
                  stream: false
                  messages:
                    - role: user
                      content: 你好
                summary: 文字提问
              '2':
                value:
                  model: gemini-3.1-pro
                  stream: false
                  messages:
                    - role: user
                      content:
                        - type: text
                          text: 这张图片内容是什么
                        - type: image_url
                          image_url:
                            url: https://xxxxxxx.png
                summary: 传递图片提问
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  object:
                    type: string
                  created:
                    type: integer
                  model:
                    type: string
                  choices:
                    type: array
                    items:
                      type: object
                      properties:
                        index:
                          type: integer
                        message:
                          type: object
                          properties:
                            role:
                              type: string
                            content:
                              type: string
                          required:
                            - role
                            - content
                          x-apifox-orders:
                            - role
                            - content
                        finish_reason:
                          type: string
                        content_filter_results:
                          type: object
                          properties:
                            hate:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            self_harm:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            sexual:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            violence:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            jailbreak:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                                detected:
                                  type: boolean
                              required:
                                - filtered
                                - detected
                              x-apifox-orders:
                                - filtered
                                - detected
                            profanity:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                                detected:
                                  type: boolean
                              required:
                                - filtered
                                - detected
                              x-apifox-orders:
                                - filtered
                                - detected
                          required:
                            - hate
                            - self_harm
                            - sexual
                            - violence
                            - jailbreak
                            - profanity
                          x-apifox-orders:
                            - hate
                            - self_harm
                            - sexual
                            - violence
                            - jailbreak
                            - profanity
                      x-apifox-orders:
                        - index
                        - message
                        - finish_reason
                        - content_filter_results
                  usage:
                    type: object
                    properties:
                      prompt_tokens:
                        type: integer
                      completion_tokens:
                        type: integer
                      total_tokens:
                        type: integer
                      prompt_tokens_details:
                        type: 'null'
                      completion_tokens_details:
                        type: 'null'
                    required:
                      - prompt_tokens
                      - completion_tokens
                      - total_tokens
                      - prompt_tokens_details
                      - completion_tokens_details
                    x-apifox-orders:
                      - prompt_tokens
                      - completion_tokens
                      - total_tokens
                      - prompt_tokens_details
                      - completion_tokens_details
                  system_fingerprint:
                    type: string
                required:
                  - id
                  - object
                  - created
                  - model
                  - choices
                  - usage
                  - system_fingerprint
                x-apifox-orders:
                  - id
                  - object
                  - created
                  - model
                  - choices
                  - usage
                  - system_fingerprint
              example:
                id: 1-2ede12b5-77cc-48f9-b1d0-7ae35ee8d444
                object: ''
                created: 1777897048
                model: gemini-3.1-pro
                choices:
                  - index: 0
                    message:
                      role: assistant
                      content: 你好！请问有什么我可以帮您的吗？
                    finish_reason: stop
                    content_filter_results:
                      hate:
                        filtered: false
                      self_harm:
                        filtered: false
                      sexual:
                        filtered: false
                      violence:
                        filtered: false
                      jailbreak:
                        filtered: false
                        detected: false
                      profanity:
                        filtered: false
                        detected: false
                usage:
                  prompt_tokens: 2
                  completion_tokens: 261
                  total_tokens: 263
                  prompt_tokens_details: null
                  completion_tokens_details: null
                system_fingerprint: ''
          headers: {}
          x-apifox-name: json响应
        '400':
          description: ''
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: object
                    properties:
                      message:
                        type: string
                        title: 报错信息
                    required:
                      - message
                    x-apifox-orders:
                      - message
                required:
                  - error
                x-apifox-orders:
                  - error
              example:
                error:
                  message: generation failed
          headers: {}
          x-apifox-name: 报错
        x-200:stream流响应:
          description: ''
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  object:
                    type: string
                  created:
                    type: integer
                  model:
                    type: string
                  choices:
                    type: array
                    items:
                      type: object
                      properties:
                        index:
                          type: integer
                        delta:
                          type: object
                          properties:
                            content:
                              type: string
                            role:
                              type: string
                          required:
                            - content
                            - role
                          x-apifox-orders:
                            - content
                            - role
                        finish_reason:
                          type: 'null'
                        content_filter_results:
                          type: object
                          properties:
                            hate:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            self_harm:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            sexual:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            violence:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                              required:
                                - filtered
                              x-apifox-orders:
                                - filtered
                            jailbreak:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                                detected:
                                  type: boolean
                              required:
                                - filtered
                                - detected
                              x-apifox-orders:
                                - filtered
                                - detected
                            profanity:
                              type: object
                              properties:
                                filtered:
                                  type: boolean
                                detected:
                                  type: boolean
                              required:
                                - filtered
                                - detected
                              x-apifox-orders:
                                - filtered
                                - detected
                          required:
                            - hate
                            - self_harm
                            - sexual
                            - violence
                            - jailbreak
                            - profanity
                          x-apifox-orders:
                            - hate
                            - self_harm
                            - sexual
                            - violence
                            - jailbreak
                            - profanity
                      x-apifox-orders:
                        - index
                        - delta
                        - finish_reason
                        - content_filter_results
                  system_fingerprint:
                    type: string
                  data:
                    type: array
                    items:
                      type: object
                      properties:
                        url:
                          type: string
                      x-apifox-orders:
                        - url
                  usage:
                    type: object
                    properties:
                      total_tokens:
                        type: integer
                      input_tokens:
                        type: integer
                      output_tokens:
                        type: integer
                      input_tokens_details:
                        type: object
                        properties: {}
                        x-apifox-orders: []
                    required:
                      - total_tokens
                      - input_tokens
                      - output_tokens
                      - input_tokens_details
                    x-apifox-orders:
                      - total_tokens
                      - input_tokens
                      - output_tokens
                      - input_tokens_details
                required:
                  - id
                  - object
                  - created
                  - model
                  - choices
                  - system_fingerprint
                  - data
                  - usage
                x-apifox-orders:
                  - id
                  - object
                  - created
                  - model
                  - choices
                  - system_fingerprint
                  - data
                  - usage
              example: |-
                data: {
                    "id": "1-c1e4db8a-fbd4-42a8-8bfa-4a7679416301",
                    "object": "chat.completion.chunk",
                    "created": 1777896911,
                    "model": "gemini-3.1-pro",
                    "choices": [
                        {
                            "index": 0,
                            "delta": {
                                "content": "你好！👋 请",
                                "role": "assistant"
                            },
                            "finish_reason": null,
                            "content_filter_results": {
                                "hate": {
                                    "filtered": false
                                },
                                "self_harm": {
                                    "filtered": false
                                },
                                "sexual": {
                                    "filtered": false
                                },
                                "violence": {
                                    "filtered": false
                                },
                                "jailbreak": {
                                    "filtered": false,
                                    "detected": false
                                },
                                "profanity": {
                                    "filtered": false,
                                    "detected": false
                                }
                            }
                        }
                    ],
                    "system_fingerprint": ""
                }

                data: {
                    "id": "1-c1e4db8a-fbd4-42a8-8bfa-4a7679416301",
                    "object": "chat.completion.chunk",
                    "created": 1777896911,
                    "model": "gemini-3.1-pro",
                    "choices": [
                        {
                            "index": 0,
                            "delta": {
                                "content": "问有什么我可以帮你的吗？",
                                "role": "assistant"
                            },
                            "finish_reason": null,
                            "content_filter_results": {
                                "hate": {
                                    "filtered": false
                                },
                                "self_harm": {
                                    "filtered": false
                                },
                                "sexual": {
                                    "filtered": false
                                },
                                "violence": {
                                    "filtered": false
                                },
                                "jailbreak": {
                                    "filtered": false,
                                    "detected": false
                                },
                                "profanity": {
                                    "filtered": false,
                                    "detected": false
                                }
                            }
                        }
                    ],
                    "system_fingerprint": ""
                }

                data: {
                    "id": "1-c1e4db8a-fbd4-42a8-8bfa-4a7679416301",
                    "object": "chat.completion.chunk",
                    "created": 1777896912,
                    "model": "gemini-3.1-pro",
                    "choices": [
                        {
                            "index": 0,
                            "delta": {
                                "role": "assistant"
                            },
                            "finish_reason": null,
                            "content_filter_results": {
                                "hate": {
                                    "filtered": false
                                },
                                "self_harm": {
                                    "filtered": false
                                },
                                "sexual": {
                                    "filtered": false
                                },
                                "violence": {
                                    "filtered": false
                                },
                                "jailbreak": {
                                    "filtered": false,
                                    "detected": false
                                },
                                "profanity": {
                                    "filtered": false,
                                    "detected": false
                                }
                            }
                        }
                    ],
                    "system_fingerprint": ""
                }

                data: {
                    "id": "1-c1e4db8a-fbd4-42a8-8bfa-4a7679416301",
                    "object": "chat.completion.chunk",
                    "created": 1777896912,
                    "model": "gemini-3.1-pro",
                    "choices": [
                        {
                            "index": 0,
                            "delta": {
                                "role": "assistant"
                            },
                            "finish_reason": "stop",
                            "content_filter_results": {
                                "hate": {
                                    "filtered": false
                                },
                                "self_harm": {
                                    "filtered": false
                                },
                                "sexual": {
                                    "filtered": false
                                },
                                "violence": {
                                    "filtered": false
                                },
                                "jailbreak": {
                                    "filtered": false,
                                    "detected": false
                                },
                                "profanity": {
                                    "filtered": false,
                                    "detected": false
                                }
                            }
                        }
                    ],
                    "system_fingerprint": "",
                    "usage": {
                        "prompt_tokens": 2,
                        "completion_tokens": 213,
                        "total_tokens": 215,
                        "prompt_tokens_details": null,
                        "completion_tokens_details": null
                    }
                }
          headers: {}
          x-apifox-name: stream流响应
      security: []
      x-apifox-folder: openai-completions接口
      x-apifox-status: released
      x-run-in-apifox: https://app.apifox.com/web/project/8212034/apis/api-452418916-run
components:
  schemas: {}
  securitySchemes: {}
servers: []
security: []

```