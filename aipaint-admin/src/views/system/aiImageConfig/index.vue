<template>
  <div class="app-container">
    <el-skeleton v-if="loading" :rows="8" animated />

    <el-form v-else ref="configRef" :model="form" :rules="rules" label-width="120px">
      <el-card class="mb16" shadow="never">
        <template #header>
          <div class="card-header">基础设置</div>
        </template>

        <el-form-item label="当前生效通道" prop="activeProvider">
          <el-radio-group v-model="form.activeProvider">
            <el-radio value="primary">主通道</el-radio>
            <el-radio value="backup">备用通道</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="固定尺寸开关" prop="forceSizeEnabled">
          <el-switch v-model="form.forceSizeEnabled" />
        </el-form-item>

        <el-form-item label="固定尺寸" prop="forceSize">
          <el-select v-model="form.forceSize" :disabled="!form.forceSizeEnabled" style="width: 220px">
            <el-option v-for="item in sizeOptions" :key="item" :label="item" :value="item" />
          </el-select>
          <span class="form-tip">关闭后将按前台比例自动映射尺寸</span>
        </el-form-item>
      </el-card>

      <el-row :gutter="16">
        <el-col :span="12">
          <el-card shadow="never">
            <template #header>
              <div class="card-header">主通道</div>
            </template>
            <ProviderForm provider-key="primaryProvider" :form="form" :provider-types="providerTypes" />
          </el-card>
        </el-col>

        <el-col :span="12">
          <el-card shadow="never">
            <template #header>
              <div class="card-header">备用通道</div>
            </template>
            <ProviderForm provider-key="backupProvider" :form="form" :provider-types="providerTypes" />
          </el-card>
        </el-col>
      </el-row>

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
import { computed, h, reactive, ref } from "vue"
import { ElForm, ElFormItem, ElInput, ElOption, ElSelect, ElSwitch } from "element-plus"
import { getAiImageConfig, updateAiImageConfig } from "@/api/system/aiImageConfig"

const { proxy } = getCurrentInstance()

const sizeOptions = ["1024x1024", "1536x1024", "1024x1536"]
const providerTypes = [
  { label: "OpenAI Compatible", value: "openai-compatible" }
]

const loading = ref(true)
const submitting = ref(false)

function createProvider(providerCode, providerName) {
  return {
    providerCode,
    providerName,
    enabled: providerCode === "backup",
    providerType: "openai-compatible",
    baseUrl: providerCode === "backup" ? "https://dm-fox.rjj.cc/codex/v1" : "",
    apiKey: "",
    model: "gpt-image-2"
  }
}

function createForm() {
  return {
    activeProvider: "backup",
    forceSizeEnabled: false,
    forceSize: "1024x1024",
    primaryProvider: createProvider("primary", "主通道"),
    backupProvider: createProvider("backup", "备用通道")
  }
}

const form = reactive(createForm())

const rules = computed(() => ({
  activeProvider: [{ required: true, message: "请选择当前生效通道", trigger: "change" }],
  forceSize: [{ validator: validateForceSize, trigger: "change" }],
  "primaryProvider.providerName": [{ required: true, message: "请输入主通道名称", trigger: "blur" }],
  "primaryProvider.providerType": [{ required: true, message: "请选择主通道类型", trigger: "change" }],
  "primaryProvider.baseUrl": [{ validator: createProviderRequiredValidator("primaryProvider", "Base URL"), trigger: "blur" }],
  "primaryProvider.apiKey": [{ validator: createProviderRequiredValidator("primaryProvider", "API Key"), trigger: "blur" }],
  "primaryProvider.model": [{ validator: createProviderRequiredValidator("primaryProvider", "模型"), trigger: "blur" }],
  "backupProvider.providerName": [{ required: true, message: "请输入备用通道名称", trigger: "blur" }],
  "backupProvider.providerType": [{ required: true, message: "请选择备用通道类型", trigger: "change" }],
  "backupProvider.baseUrl": [{ validator: createProviderRequiredValidator("backupProvider", "Base URL"), trigger: "blur" }],
  "backupProvider.apiKey": [{ validator: createProviderRequiredValidator("backupProvider", "API Key"), trigger: "blur" }],
  "backupProvider.model": [{ validator: createProviderRequiredValidator("backupProvider", "模型"), trigger: "blur" }]
}))

function validateForceSize(rule, value, callback) {
  if (!form.forceSizeEnabled) {
    callback()
    return
  }
  if (sizeOptions.includes(value)) {
    callback()
    return
  }
  callback(new Error("固定尺寸配置无效"))
}

function createProviderRequiredValidator(providerKey, label) {
  return (rule, value, callback) => {
    const provider = form[providerKey]
    if (!provider?.enabled) {
      callback()
      return
    }
    if (value === undefined || value === null || String(value).trim() === "") {
      callback(new Error(`${provider.providerName || "通道"}启用时，${label}不能为空`))
      return
    }
    callback()
  }
}

function assignForm(data) {
  const defaults = createForm()
  form.activeProvider = data?.activeProvider || defaults.activeProvider
  form.forceSizeEnabled = Boolean(data?.forceSizeEnabled)
  form.forceSize = data?.forceSize || defaults.forceSize
  form.primaryProvider = { ...defaults.primaryProvider, ...(data?.primaryProvider || {}), providerCode: "primary" }
  form.backupProvider = { ...defaults.backupProvider, ...(data?.backupProvider || {}), providerCode: "backup" }
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
    if (!valid) {
      return
    }

    submitting.value = true
    updateAiImageConfig(form).then(() => {
      proxy.$modal.msgSuccess("保存成功")
      loadConfig()
    }).finally(() => {
      submitting.value = false
    })
  })
}

const ProviderForm = {
  name: "ProviderForm",
  props: {
    form: {
      type: Object,
      required: true
    },
    providerKey: {
      type: String,
      required: true
    },
    providerTypes: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const provider = computed(() => props.form[props.providerKey])

    return () => h("div", { class: "provider-form" }, [
      h(ElFormItem, { label: "通道名称", prop: `${props.providerKey}.providerName` }, () =>
        h(ElInput, {
          modelValue: provider.value.providerName,
          "onUpdate:modelValue": (value) => provider.value.providerName = value,
          placeholder: "请输入通道名称"
        })
      ),
      h(ElFormItem, { label: "启用状态" }, () =>
        h(ElSwitch, {
          modelValue: provider.value.enabled,
          "onUpdate:modelValue": (value) => provider.value.enabled = value
        })
      ),
      h(ElFormItem, { label: "通道类型", prop: `${props.providerKey}.providerType` }, () =>
        h(ElSelect, {
          modelValue: provider.value.providerType,
          "onUpdate:modelValue": (value) => provider.value.providerType = value
        }, () => props.providerTypes.map((item) =>
          h(ElOption, { key: item.value, label: item.label, value: item.value })
        ))
      ),
      h(ElFormItem, { label: "Base URL", prop: `${props.providerKey}.baseUrl` }, () =>
        h(ElInput, {
          modelValue: provider.value.baseUrl,
          "onUpdate:modelValue": (value) => provider.value.baseUrl = value,
          placeholder: "例如 https://example.com/v1"
        })
      ),
      h(ElFormItem, { label: "API Key", prop: `${props.providerKey}.apiKey` }, () =>
        h(ElInput, {
          modelValue: provider.value.apiKey,
          "onUpdate:modelValue": (value) => provider.value.apiKey = value,
          type: "password",
          showPassword: true,
          placeholder: "请输入 API Key"
        })
      ),
      h(ElFormItem, { label: "模型", prop: `${props.providerKey}.model` }, () =>
        h(ElInput, {
          modelValue: provider.value.model,
          "onUpdate:modelValue": (value) => provider.value.model = value,
          placeholder: "例如 gpt-image-2"
        })
      )
    ])
  }
}

loadConfig()
</script>

<style scoped>
.mb16 {
  margin-bottom: 16px;
}

.card-header {
  font-weight: 600;
}

.form-tip {
  margin-left: 12px;
  color: var(--el-text-color-secondary);
  font-size: 13px;
}

.footer-actions {
  margin-top: 20px;
}

.provider-form :deep(.el-form-item:last-child) {
  margin-bottom: 0;
}
</style>
