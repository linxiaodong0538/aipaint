<template>
  <div class="app-container">
    <el-skeleton v-if="loading" :rows="8" animated />

    <el-form v-else ref="configRef" :model="form" :rules="rules" label-width="120px">
      <el-card class="mb16" shadow="never">
        <template #header>
          <div class="section-header">
            <span>通道健康状态</span>
            <el-button text type="primary" @click="loadConfig">刷新</el-button>
          </div>
        </template>

        <el-table :data="healthRows" border>
          <el-table-column label="通道" min-width="150">
            <template #default="{ row }">
              <div class="provider-name">{{ row.providerName }}</div>
              <div class="provider-code">{{ row.providerCode }}</div>
            </template>
          </el-table-column>
          <el-table-column label="最近50次成功率" width="140">
            <template #default="{ row }">
              <el-tag :type="row.successRate >= 90 ? 'success' : row.successRate >= 60 ? 'warning' : 'danger'">
                {{ formatPercent(row.successRate) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="平均耗时" width="120">
            <template #default="{ row }">{{ formatDuration(row.avgDurationMs) }}</template>
          </el-table-column>
          <el-table-column label="连续失败" prop="consecutiveFailures" width="100" />
          <el-table-column label="最后状态" width="100">
            <template #default="{ row }">
              <el-tag :type="row.lastStatus === 'success' ? 'success' : row.lastStatus === 'failed' ? 'danger' : 'info'">
                {{ formatStatus(row.lastStatus) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="最后调用时间" prop="lastCallTime" width="180" />
          <el-table-column label="最后错误" prop="lastErrorMessage" min-width="260" show-overflow-tooltip />
        </el-table>
      </el-card>

      <el-card class="mb16" shadow="never">
        <template #header>
          <div class="section-header">
            <span>全局设置</span>
          </div>
        </template>

        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="输出格式" prop="outputFormat">
              <el-radio-group v-model="form.outputFormat">
                <el-radio value="jpeg">JPEG</el-radio>
                <el-radio value="png">PNG</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="JPEG 压缩" prop="outputCompression">
              <el-input-number
                v-model="form.outputCompression"
                :min="0"
                :max="100"
                :disabled="form.outputFormat !== 'jpeg'"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="熔断条件">
              <div class="inline-controls">
                <el-input-number v-model="form.circuitBreakerFailureThreshold" :min="1" :max="20" controls-position="right" />
                <span>次 /</span>
                <el-input-number v-model="form.circuitBreakerCooldownMinutes" :min="1" :max="1440" controls-position="right" />
                <span>分钟</span>
              </div>
            </el-form-item>
          </el-col>
        </el-row>
      </el-card>

      <el-card class="mb16" shadow="never">
        <template #header>
          <div class="section-header">
            <span>模型价格</span>
            <el-button type="primary" plain @click="addModelPricing">新增模型价格</el-button>
          </div>
        </template>

        <el-row :gutter="16" class="pricing-multiplier-row">
          <el-col :span="8">
            <el-form-item label="1K 倍率">
              <el-input-number v-model="form.resolutionMultipliers['1K']" :min="0.1" :max="100" :step="0.1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="2K 倍率">
              <el-input-number v-model="form.resolutionMultipliers['2K']" :min="0.1" :max="100" :step="0.1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="4K 倍率">
              <el-input-number v-model="form.resolutionMultipliers['4K']" :min="0.1" :max="100" :step="0.1" controls-position="right" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-table :data="form.modelPricings" border row-key="model">
          <el-table-column label="启用" width="72" align="center">
            <template #default="{ row }">
              <el-switch v-model="row.enabled" />
            </template>
          </el-table-column>
          <el-table-column label="模型" min-width="200">
            <template #default="{ row }">
              <el-select
                v-model="row.model"
                class="full-width"
                filterable
                allow-create
                default-first-option
                placeholder="选择或输入模型"
              >
                <el-option v-for="item in modelOptions" :key="item" :label="item" :value="item" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="基础价" width="150">
            <template #default="{ row }">
              <el-input-number v-model="row.baseCredits" :min="1" :max="9999" controls-position="right" class="credit-input" />
            </template>
          </el-table-column>
          <el-table-column label="单张预览" min-width="220">
            <template #default="{ row }">
              <div class="pricing-preview">
                <el-tag size="small">1K {{ previewCredit(row, "1K") }}</el-tag>
                <el-tag size="small" type="success">2K {{ previewCredit(row, "2K") }}</el-tag>
                <el-tag size="small" type="warning">4K {{ previewCredit(row, "4K") }}</el-tag>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="排序" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.sortOrder" :min="0" :max="9999" controls-position="right" class="sort-input" />
            </template>
          </el-table-column>
          <el-table-column label="备注" min-width="180">
            <template #default="{ row }">
              <el-input v-model.trim="row.remark" placeholder="备注" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="90" fixed="right">
            <template #default="{ $index }">
              <el-button text type="danger" @click="removeModelPricing($index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card class="mb16" shadow="never">
        <template #header>
          <div class="section-header">
            <span>通道配置</span>
            <el-button type="primary" plain @click="addProvider">新增通道</el-button>
          </div>
        </template>

        <el-table :data="form.providers" border row-key="providerCode">
          <el-table-column label="启用" width="72" align="center">
            <template #default="{ row }">
              <el-switch v-model="row.enabled" />
            </template>
          </el-table-column>
          <el-table-column label="编码" width="150">
            <template #default="{ row }">
              <el-input v-model.trim="row.providerCode" placeholder="superapi" />
            </template>
          </el-table-column>
          <el-table-column label="名称" width="160">
            <template #default="{ row }">
              <el-input v-model.trim="row.providerName" placeholder="通道名称" />
            </template>
          </el-table-column>
          <el-table-column label="接口协议" width="200">
            <template #default="{ row }">
              <el-select v-model="row.adapterType" class="full-width">
                <el-option v-for="item in adapterTypes" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="响应模式" width="150">
            <template #default="{ row }">
              <el-select v-model="row.responseMode" class="full-width" :disabled="row.adapterType !== 'openai-compatible'">
                <el-option v-for="item in responseModes" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="支持批量生成" width="130" align="center">
            <template #default="{ row }">
              <el-switch v-model="row.supportsBatch" />
            </template>
          </el-table-column>
          <el-table-column label="支持模型" min-width="240">
            <template #default="{ row }">
              <el-select
                v-model="row.supportedModels"
                class="full-width"
                multiple
                filterable
                allow-create
                default-first-option
                placeholder="选择或输入模型"
              >
                <el-option v-for="item in modelOptions" :key="item" :label="item" :value="item" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="供应商模型映射" min-width="260">
            <template #default="{ row }">
              <div class="model-alias-list">
                <div v-for="item in normalizeModels(row.supportedModels)" :key="item" class="model-alias-row">
                  <span class="model-alias-label">{{ item }}</span>
                  <el-input
                    v-model.trim="row.providerModelMap[item]"
                    :placeholder="item"
                    @blur="ensureProviderModelMap(row)"
                  />
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="Base URL" min-width="260">
            <template #default="{ row }">
              <el-input v-model.trim="row.baseUrl" :placeholder="baseUrlPlaceholder(row.adapterType)" />
            </template>
          </el-table-column>
          <el-table-column label="API Key" min-width="220">
            <template #default="{ row }">
              <el-input v-model="row.apiKey" type="password" show-password placeholder="请输入 API Key" />
            </template>
          </el-table-column>
          <el-table-column label="排序" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.sortOrder" :min="0" :max="9999" controls-position="right" class="sort-input" />
            </template>
          </el-table-column>
          <el-table-column label="备注" min-width="180">
            <template #default="{ row }">
              <el-input v-model.trim="row.remark" placeholder="备注" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="90" fixed="right">
            <template #default="{ $index }">
              <el-button text type="danger" @click="removeProvider($index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never">
        <template #header>
          <div class="section-header">
            <span>模型路由</span>
            <el-button type="primary" plain @click="addRoute">新增路由</el-button>
          </div>
        </template>

        <el-table :data="form.modelRoutes" border row-key="model">
          <el-table-column label="启用" width="72" align="center">
            <template #default="{ row }">
              <el-switch v-model="row.enabled" />
            </template>
          </el-table-column>
          <el-table-column label="模型" min-width="200">
            <template #default="{ row }">
              <el-select
                v-model="row.model"
                class="full-width"
                filterable
                allow-create
                default-first-option
                placeholder="选择或输入模型"
              >
                <el-option v-for="item in modelOptions" :key="item" :label="item" :value="item" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="主通道" min-width="200">
            <template #default="{ row }">
              <el-select
                v-model="row.primaryProviderCode"
                class="full-width"
                filterable
                placeholder="选择主通道"
                @change="handlePrimaryProviderChange(row)"
              >
                <el-option
                  v-for="item in providerOptionsForModel(row.model)"
                  :key="item.providerCode"
                  :label="providerOptionLabel(item)"
                  :value="item.providerCode"
                />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="备用通道" min-width="200">
            <template #default="{ row }">
              <el-select v-model="row.backupProviderCode" class="full-width" filterable clearable placeholder="无备用通道">
                <el-option
                  v-for="item in backupProviderOptionsForRoute(row)"
                  :key="item.providerCode"
                  :label="providerOptionLabel(item)"
                  :value="item.providerCode"
                />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="失败切备用" width="120" align="center">
            <template #default="{ row }">
              <el-switch v-model="row.fallbackEnabled" :disabled="!row.backupProviderCode" />
            </template>
          </el-table-column>
          <el-table-column label="排序" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.sortOrder" :min="0" :max="9999" controls-position="right" class="sort-input" />
            </template>
          </el-table-column>
          <el-table-column label="备注" min-width="220">
            <template #default="{ row }">
              <el-input v-model.trim="row.remark" placeholder="备注" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="90" fixed="right">
            <template #default="{ $index }">
              <el-button text type="danger" @click="removeRoute($index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <div class="footer-actions">
        <el-button
          type="primary"
          :loading="submitting"
          @click="submitForm"
          v-hasPermi="['system:aiImageConfig:edit']"
        >
          保存配置
        </el-button>
        <el-button @click="loadConfig">重新加载</el-button>
      </div>
    </el-form>
  </div>
</template>

<script setup name="AiImageConfig">
import { computed, getCurrentInstance, reactive, ref } from "vue"
import { getAiImageConfig, updateAiImageConfig } from "@/api/system/aiImageConfig"

const { proxy } = getCurrentInstance()

const adapterTypes = [
  { label: "OpenAI 兼容接口", value: "openai-compatible" },
  { label: "Grsai 异步接口", value: "grsai-async" }
]

const responseModes = [
  { label: "JSON", value: "json" },
  { label: "流式 SSE", value: "stream" }
]

const modelOptions = ["gpt-image-2", "gpt-image-2-vip", "nano-banana", "nano-banana-2", "nano-banana-pro"]

const loading = ref(true)
const submitting = ref(false)

function createProvider(overrides = {}) {
  return {
    providerCode: "",
    providerName: "",
    enabled: false,
    adapterType: "openai-compatible",
    responseMode: "json",
    supportsBatch: true,
    baseUrl: "",
    apiKey: "",
    model: "gpt-image-2",
    supportedModels: ["gpt-image-2"],
    providerModelMap: { "gpt-image-2": "gpt-image-2" },
    sortOrder: 0,
    remark: "",
    ...overrides
  }
}

function createRoute(overrides = {}) {
  return {
    model: "gpt-image-2",
    enabled: true,
    primaryProviderCode: "",
    backupProviderCode: "",
    fallbackEnabled: false,
    sortOrder: 0,
    remark: "",
    ...overrides
  }
}

function createModelPricing(overrides = {}) {
  return {
    model: "gpt-image-2",
    baseCredits: 6,
    enabled: true,
    sortOrder: 0,
    remark: "",
    ...overrides
  }
}

function createForm() {
  return {
    circuitBreakerFailureThreshold: 3,
    circuitBreakerCooldownMinutes: 10,
    outputFormat: "jpeg",
    outputCompression: 90,
    resolutionMultipliers: {
      "1K": 1,
      "2K": 1.2,
      "4K": 1.5
    },
    modelPricings: [
      createModelPricing({ model: "gpt-image-2", baseCredits: 6, sortOrder: 1, remark: "全能艺术创作" }),
      createModelPricing({ model: "gpt-image-2-vip", baseCredits: 15, sortOrder: 2, remark: "尺寸增强" }),
      createModelPricing({ model: "nano-banana", baseCredits: 5, sortOrder: 3, remark: "轻量快速生成" }),
      createModelPricing({ model: "nano-banana-2", baseCredits: 12, sortOrder: 4, remark: "写实摄影风格" }),
      createModelPricing({ model: "nano-banana-pro", baseCredits: 20, sortOrder: 5, remark: "专业细节增强" })
    ],
    providers: [
      createProvider({
        providerCode: "superapi",
        providerName: "SuperAPI 中转站",
        enabled: true,
        responseMode: "stream",
        supportedModels: ["gpt-image-2"],
        providerModelMap: { "gpt-image-2": "gpt-image-2" },
        sortOrder: 1
      }),
      createProvider({
        providerCode: "grsai",
        providerName: "Grsai 中转站",
        adapterType: "grsai-async",
        responseMode: "json",
        supportedModels: ["gpt-image-2", "gpt-image-2-vip", "nano-banana", "nano-banana-2", "nano-banana-pro"],
        providerModelMap: {
          "gpt-image-2": "gpt-image-2",
          "gpt-image-2-vip": "gpt-image-2-vip",
          "nano-banana": "nano-banana",
          "nano-banana-2": "nano-banana-2",
          "nano-banana-pro": "nano-banana-pro"
        },
        sortOrder: 2
      })
    ],
    modelRoutes: [
      createRoute({
        model: "gpt-image-2",
        primaryProviderCode: "superapi",
        backupProviderCode: "grsai",
        fallbackEnabled: true,
        sortOrder: 1,
        remark: "GPT 主用 SuperAPI，失败切 Grsai"
      }),
      createRoute({
        model: "gpt-image-2-vip",
        primaryProviderCode: "grsai",
        fallbackEnabled: false,
        sortOrder: 2,
        remark: "GPT VIP 暂时走 Grsai"
      }),
      createRoute({
        model: "nano-banana",
        primaryProviderCode: "grsai",
        fallbackEnabled: false,
        sortOrder: 3,
        remark: "nano-banana 暂时走 Grsai"
      }),
      createRoute({
        model: "nano-banana-2",
        primaryProviderCode: "grsai",
        fallbackEnabled: false,
        sortOrder: 4,
        remark: "nano-banana-2 暂时走 Grsai"
      }),
      createRoute({
        model: "nano-banana-pro",
        primaryProviderCode: "grsai",
        fallbackEnabled: false,
        sortOrder: 5,
        remark: "nano-banana-pro 暂时走 Grsai"
      })
    ],
    healthStats: []
  }
}

const form = reactive(createForm())

const rules = computed(() => ({
  outputFormat: [{ required: true, message: "请选择输出格式", trigger: "change" }],
  outputCompression: [{ validator: validateOutputCompression, trigger: "change" }]
}))

const healthRows = computed(() => {
  const stats = Array.isArray(form.healthStats) ? form.healthStats : []
  return form.providers.map((provider) => {
    const stat = stats.find((item) => item.providerCode === provider.providerCode) || {}
    return {
      providerCode: provider.providerCode,
      providerName: provider.providerName || provider.providerCode,
      totalCount: Number(stat.totalCount || 0),
      successRate: Number(stat.successRate || 0),
      avgDurationMs: Number(stat.avgDurationMs || 0),
      consecutiveFailures: Number(stat.consecutiveFailures || 0),
      lastStatus: stat.lastStatus || "",
      lastCallTime: stat.lastCallTime || "-",
      lastErrorMessage: stat.lastErrorMessage || "-"
    }
  })
})

function validateOutputCompression(rule, value, callback) {
  if (form.outputFormat !== "jpeg") {
    callback()
    return
  }
  const compression = Number(value)
  if (Number.isInteger(compression) && compression >= 0 && compression <= 100) {
    callback()
    return
  }
  callback(new Error("JPEG 压缩强度需为 0-100 的整数"))
}

function assignForm(data) {
  const defaults = createForm()
  form.circuitBreakerFailureThreshold = Number(data?.circuitBreakerFailureThreshold || defaults.circuitBreakerFailureThreshold)
  form.circuitBreakerCooldownMinutes = Number(data?.circuitBreakerCooldownMinutes || defaults.circuitBreakerCooldownMinutes)
  form.outputFormat = data?.outputFormat || defaults.outputFormat
  form.outputCompression = Number(data?.outputCompression ?? defaults.outputCompression)
  form.resolutionMultipliers = normalizeResolutionMultipliers(data?.resolutionMultipliers, defaults.resolutionMultipliers)
  form.modelPricings = normalizeModelPricingList(data?.modelPricings, defaults.modelPricings)
  form.providers = normalizeProviderList(data?.providers, defaults.providers)
  form.modelRoutes = normalizeRouteList(data?.modelRoutes, defaults.modelRoutes)
  form.healthStats = Array.isArray(data?.healthStats) ? data.healthStats : []
}

function normalizeResolutionMultipliers(value, defaults) {
  const source = value && typeof value === "object" ? value : {}
  return {
    "1K": normalizeMultiplier(source["1K"], defaults["1K"]),
    "2K": normalizeMultiplier(source["2K"], defaults["2K"]),
    "4K": normalizeMultiplier(source["4K"], defaults["4K"])
  }
}

function normalizeMultiplier(value, fallback) {
  const numericValue = Number(value)
  return Number.isFinite(numericValue) && numericValue >= 0.1 && numericValue <= 100 ? numericValue : fallback
}

function normalizeModelPricingList(pricings, defaults) {
  const source = Array.isArray(pricings) && pricings.length > 0 ? pricings : defaults
  return source.map((pricing, index) => createModelPricing({
    ...pricing,
    model: String(pricing.model || "").trim() || "gpt-image-2",
    baseCredits: normalizeBaseCredits(pricing.baseCredits, defaults[index]?.baseCredits || 6),
    enabled: pricing.enabled !== false,
    sortOrder: Number(pricing.sortOrder ?? index + 1),
    remark: String(pricing.remark || "").trim()
  }))
}

function normalizeBaseCredits(value, fallback) {
  const numericValue = Number(value)
  return Number.isInteger(numericValue) && numericValue >= 1 && numericValue <= 9999 ? numericValue : fallback
}

function normalizeProviderList(providers, defaults) {
  const source = Array.isArray(providers) && providers.length > 0 ? providers : defaults
  return source.map((provider, index) => createProvider({
    ...provider,
    adapterType: normalizeAdapterType(provider.adapterType),
    responseMode: normalizeResponseMode(provider.responseMode, provider),
    supportsBatch: provider.supportsBatch !== false,
    supportedModels: normalizeModels(provider.supportedModels || provider.model),
    providerModelMap: normalizeProviderModelMap(provider),
    sortOrder: Number(provider.sortOrder ?? index + 1)
  }))
}

function normalizeRouteList(routes, defaults) {
  const source = Array.isArray(routes) && routes.length > 0 ? routes : defaults
  return source.map((route, index) => createRoute({
    ...route,
    backupProviderCode: route.backupProviderCode || "",
    fallbackEnabled: Boolean(route.fallbackEnabled && route.backupProviderCode),
    sortOrder: Number(route.sortOrder ?? index + 1)
  }))
}

function normalizeModels(value) {
  const values = Array.isArray(value) ? value : [value]
  const models = values.map((item) => String(item || "").trim()).filter(Boolean)
  return Array.from(new Set(models.length > 0 ? models : ["gpt-image-2"]))
}

function normalizeProviderModelMap(provider) {
  const supportedModels = normalizeModels(provider.supportedModels || provider.model)
  const inputMap = provider.providerModelMap && typeof provider.providerModelMap === "object" ? provider.providerModelMap : {}
  return supportedModels.reduce((map, model) => {
    map[model] = String(inputMap[model] || model).trim() || model
    return map
  }, {})
}

function ensureProviderModelMap(provider) {
  provider.supportedModels = normalizeModels(provider.supportedModels)
  provider.providerModelMap = normalizeProviderModelMap(provider)
}

function normalizeAdapterType(value) {
  const adapterType = String(value || "").trim()
  if (adapterType === "grsai") {
    return "grsai-async"
  }
  return adapterType || "openai-compatible"
}

function normalizeResponseMode(value, provider = {}) {
  const responseMode = String(value || "").trim().toLowerCase()
  if (responseModes.some((item) => item.value === responseMode)) {
    return responseMode
  }
  const baseUrl = String(provider.baseUrl || "").toLowerCase()
  return baseUrl.includes("gpt2image.superapi.buzz") ? "stream" : "json"
}

function addProvider() {
  const nextIndex = form.providers.length + 1
  form.providers.push(createProvider({
    providerCode: `provider${nextIndex}`,
    providerName: `通道 ${nextIndex}`,
    sortOrder: nextIndex
  }))
}

function removeProvider(index) {
  const provider = form.providers[index]
  if (!provider) return
  const usedAsPrimary = form.modelRoutes.some((route) => route.primaryProviderCode === provider.providerCode)
  if (usedAsPrimary) {
    proxy.$modal.msgError("该通道仍被模型路由作为主通道使用")
    return
  }
  form.modelRoutes.forEach((route) => {
    if (route.backupProviderCode === provider.providerCode) {
      route.backupProviderCode = ""
      route.fallbackEnabled = false
    }
  })
  form.providers.splice(index, 1)
}

function addRoute() {
  const model = modelOptions.find((item) => !form.modelRoutes.some((route) => route.model === item)) || ""
  form.modelRoutes.push(createRoute({
    model,
    sortOrder: form.modelRoutes.length + 1
  }))
}

function removeRoute(index) {
  form.modelRoutes.splice(index, 1)
}

function addModelPricing() {
  const model = modelOptions.find((item) => !form.modelPricings.some((pricing) => pricing.model === item)) || ""
  form.modelPricings.push(createModelPricing({
    model,
    sortOrder: form.modelPricings.length + 1
  }))
}

function removeModelPricing(index) {
  form.modelPricings.splice(index, 1)
}

function previewCredit(row, resolution) {
  const baseCredits = Number(row.baseCredits || 0)
  const multiplier = Number(form.resolutionMultipliers?.[resolution] || 1)
  return `${Math.ceil(baseCredits * multiplier)} PTS`
}

function providerOptionsForModel(model) {
  const normalizedModel = String(model || "").trim()
  if (!normalizedModel) {
    return form.providers
  }
  return form.providers.filter((provider) => normalizeModels(provider.supportedModels).includes(normalizedModel))
}

function backupProviderOptionsForRoute(route) {
  return providerOptionsForModel(route.model).filter((provider) => provider.providerCode !== route.primaryProviderCode)
}

function handlePrimaryProviderChange(route) {
  if (route.backupProviderCode === route.primaryProviderCode) {
    route.backupProviderCode = ""
    route.fallbackEnabled = false
  }
}

function providerOptionLabel(provider) {
  const status = provider.enabled ? "启用" : "停用"
  return `${provider.providerName || provider.providerCode} (${provider.providerCode} / ${status})`
}

function baseUrlPlaceholder(adapterType) {
  return adapterType === "grsai-async" ? "例如 https://grsai.dakka.com.cn" : "例如 https://example.com/v1"
}

function validateBeforeSubmit() {
  const multiplierMessage = validateResolutionMultipliers()
  if (multiplierMessage) {
    return multiplierMessage
  }

  const pricingMessage = validateModelPricings()
  if (pricingMessage) {
    return pricingMessage
  }

  if (form.providers.length === 0) {
    return "请至少配置一个通道"
  }
  const providerCodes = new Set()
  for (const provider of form.providers) {
    provider.providerCode = String(provider.providerCode || "").trim().toLowerCase()
    provider.providerName = String(provider.providerName || "").trim()
    provider.supportedModels = normalizeModels(provider.supportedModels)
    provider.providerModelMap = normalizeProviderModelMap(provider)
    if (!/^[a-zA-Z0-9][a-zA-Z0-9_-]{0,31}$/.test(provider.providerCode)) {
      return "通道编码只能使用 1-32 位字母、数字、下划线或中划线"
    }
    if (providerCodes.has(provider.providerCode)) {
      return `通道编码重复：${provider.providerCode}`
    }
    providerCodes.add(provider.providerCode)
    if (!provider.providerName) {
      return `通道 ${provider.providerCode} 未填写名称`
    }
    provider.adapterType = normalizeAdapterType(provider.adapterType)
    provider.responseMode = normalizeResponseMode(provider.responseMode, provider)
    if (!adapterTypes.some((item) => item.value === provider.adapterType)) {
      return `通道 ${provider.providerCode} 接口协议不支持`
    }
    if (provider.adapterType !== "openai-compatible") {
      provider.responseMode = "json"
    }
    if (provider.enabled && (!provider.baseUrl || !provider.apiKey)) {
      return `通道 ${provider.providerName} 启用时必须填写 Base URL 和 API Key`
    }
  }

  const routeModels = new Set()
  for (const route of form.modelRoutes) {
    route.model = String(route.model || "").trim()
    route.primaryProviderCode = String(route.primaryProviderCode || "").trim().toLowerCase()
    route.backupProviderCode = String(route.backupProviderCode || "").trim().toLowerCase()
    route.fallbackEnabled = Boolean(route.fallbackEnabled && route.backupProviderCode)
    if (!route.model) {
      return "模型路由的模型不能为空"
    }
    if (routeModels.has(route.model)) {
      return `模型路由重复：${route.model}`
    }
    routeModels.add(route.model)
    const primary = form.providers.find((provider) => provider.providerCode === route.primaryProviderCode)
    if (!primary) {
      return `模型 ${route.model} 未选择有效主通道`
    }
    if (!normalizeModels(primary.supportedModels).includes(route.model)) {
      return `主通道 ${primary.providerCode} 不支持模型 ${route.model}`
    }
    if (route.backupProviderCode) {
      if (route.backupProviderCode === route.primaryProviderCode) {
        return `模型 ${route.model} 的主通道和备用通道不能相同`
      }
      const backup = form.providers.find((provider) => provider.providerCode === route.backupProviderCode)
      if (!backup) {
        return `模型 ${route.model} 未选择有效备用通道`
      }
      if (!normalizeModels(backup.supportedModels).includes(route.model)) {
        return `备用通道 ${backup.providerCode} 不支持模型 ${route.model}`
      }
    }
  }
  return ""
}

function validateResolutionMultipliers() {
  for (const resolution of ["1K", "2K", "4K"]) {
    const value = Number(form.resolutionMultipliers?.[resolution])
    if (!Number.isFinite(value) || value < 0.1 || value > 100) {
      return `${resolution} 倍率需为 0.1-100 的数字`
    }
    form.resolutionMultipliers[resolution] = value
  }
  return ""
}

function validateModelPricings() {
  if (!Array.isArray(form.modelPricings) || form.modelPricings.length === 0) {
    return "请至少配置一个模型价格"
  }
  const models = new Set()
  for (const pricing of form.modelPricings) {
    pricing.model = String(pricing.model || "").trim()
    pricing.baseCredits = Number(pricing.baseCredits)
    pricing.enabled = pricing.enabled !== false
    pricing.sortOrder = Number(pricing.sortOrder || 0)
    pricing.remark = String(pricing.remark || "").trim()
    if (!pricing.model) {
      return "模型价格的模型不能为空"
    }
    if (models.has(pricing.model)) {
      return `模型价格重复：${pricing.model}`
    }
    models.add(pricing.model)
    if (!Number.isInteger(pricing.baseCredits) || pricing.baseCredits < 1 || pricing.baseCredits > 9999) {
      return `模型 ${pricing.model} 的基础价需为 1-9999 的整数`
    }
  }
  return ""
}

function toPayload() {
  return {
    circuitBreakerFailureThreshold: form.circuitBreakerFailureThreshold,
    circuitBreakerCooldownMinutes: form.circuitBreakerCooldownMinutes,
    outputFormat: form.outputFormat,
    outputCompression: form.outputCompression,
    resolutionMultipliers: normalizeResolutionMultipliers(form.resolutionMultipliers, createForm().resolutionMultipliers),
    modelPricings: form.modelPricings.map((pricing) => ({
      ...pricing,
      model: String(pricing.model || "").trim(),
      baseCredits: Number(pricing.baseCredits),
      enabled: pricing.enabled !== false,
      sortOrder: Number(pricing.sortOrder || 0),
      remark: String(pricing.remark || "").trim()
    })),
    providers: form.providers.map((provider) => ({
      ...provider,
      adapterType: normalizeAdapterType(provider.adapterType),
      responseMode: provider.adapterType === "openai-compatible" ? normalizeResponseMode(provider.responseMode, provider) : "json",
      supportsBatch: provider.supportsBatch !== false,
      model: normalizeModels(provider.supportedModels)[0],
      supportedModels: normalizeModels(provider.supportedModels),
      providerModelMap: normalizeProviderModelMap(provider)
    })),
    modelRoutes: form.modelRoutes.map((route) => ({
      ...route,
      backupProviderCode: route.backupProviderCode || null,
      fallbackEnabled: Boolean(route.fallbackEnabled && route.backupProviderCode)
    }))
  }
}

function formatPercent(value) {
  return `${Number(value || 0).toFixed(2)}%`
}

function formatDuration(value) {
  const duration = Number(value || 0)
  return duration > 0 ? `${duration}ms` : "-"
}

function formatStatus(value) {
  if (value === "success") return "成功"
  if (value === "failed") return "失败"
  return "暂无"
}

function loadConfig() {
  loading.value = true
  getAiImageConfig().then((response) => {
    assignForm(response.data || response)
  }).finally(() => {
    loading.value = false
  })
}

function submitForm() {
  proxy.$refs["configRef"].validate((valid) => {
    if (!valid) return

    const message = validateBeforeSubmit()
    if (message) {
      proxy.$modal.msgError(message)
      return
    }

    submitting.value = true
    updateAiImageConfig(toPayload()).then(() => {
      proxy.$modal.msgSuccess("保存成功")
      loadConfig()
    }).finally(() => {
      submitting.value = false
    })
  })
}

loadConfig()
</script>

<style scoped>
.mb16 {
  margin-bottom: 16px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-weight: 600;
}

.provider-name {
  font-weight: 600;
}

.provider-code {
  margin-top: 2px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}

.full-width {
  width: 100%;
}

.inline-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.pricing-multiplier-row {
  margin-bottom: 8px;
}

.sort-input {
  width: 82px;
}

.credit-input {
  width: 112px;
}

.pricing-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.model-alias-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.model-alias-row {
  display: grid;
  grid-template-columns: minmax(96px, 1fr) minmax(120px, 1.4fr);
  align-items: center;
  gap: 8px;
}

.model-alias-label {
  color: var(--el-text-color-secondary);
  font-size: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.footer-actions {
  margin-top: 20px;
}
</style>
