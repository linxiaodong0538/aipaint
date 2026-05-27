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

const modelOptions = ["gpt-image-2", "nano-banana-2"]

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

function createForm() {
  return {
    circuitBreakerFailureThreshold: 3,
    circuitBreakerCooldownMinutes: 10,
    outputFormat: "jpeg",
    outputCompression: 90,
    providers: [
      createProvider({
        providerCode: "superapi",
        providerName: "SuperAPI 中转站",
        enabled: true,
        responseMode: "stream",
        supportedModels: ["gpt-image-2"],
        sortOrder: 1
      }),
      createProvider({
        providerCode: "grsai",
        providerName: "Grsai 中转站",
        adapterType: "grsai-async",
        responseMode: "json",
        supportedModels: ["gpt-image-2", "nano-banana-2"],
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
        model: "nano-banana-2",
        primaryProviderCode: "grsai",
        fallbackEnabled: false,
        sortOrder: 2,
        remark: "nano-banana 固定走 Grsai"
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
  form.providers = normalizeProviderList(data?.providers, defaults.providers)
  form.modelRoutes = normalizeRouteList(data?.modelRoutes, defaults.modelRoutes)
  form.healthStats = Array.isArray(data?.healthStats) ? data.healthStats : []
}

function normalizeProviderList(providers, defaults) {
  const source = Array.isArray(providers) && providers.length > 0 ? providers : defaults
  return source.map((provider, index) => createProvider({
    ...provider,
    adapterType: normalizeAdapterType(provider.adapterType),
    responseMode: normalizeResponseMode(provider.responseMode, provider),
    supportsBatch: provider.supportsBatch !== false,
    supportedModels: normalizeModels(provider.supportedModels || provider.model),
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
  if (form.providers.length === 0) {
    return "请至少配置一个通道"
  }
  const providerCodes = new Set()
  for (const provider of form.providers) {
    provider.providerCode = String(provider.providerCode || "").trim().toLowerCase()
    provider.providerName = String(provider.providerName || "").trim()
    provider.supportedModels = normalizeModels(provider.supportedModels)
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

function toPayload() {
  return {
    circuitBreakerFailureThreshold: form.circuitBreakerFailureThreshold,
    circuitBreakerCooldownMinutes: form.circuitBreakerCooldownMinutes,
    outputFormat: form.outputFormat,
    outputCompression: form.outputCompression,
    providers: form.providers.map((provider) => ({
      ...provider,
      adapterType: normalizeAdapterType(provider.adapterType),
      responseMode: provider.adapterType === "openai-compatible" ? normalizeResponseMode(provider.responseMode, provider) : "json",
      supportsBatch: provider.supportsBatch !== false,
      model: normalizeModels(provider.supportedModels)[0],
      supportedModels: normalizeModels(provider.supportedModels)
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

.sort-input {
  width: 82px;
}

.footer-actions {
  margin-top: 20px;
}
</style>
