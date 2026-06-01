<template>
  <div class="app-container payment-order-page">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="订单号" prop="outTradeNo">
        <el-input v-model="queryParams.outTradeNo" placeholder="请输入商户订单号" clearable style="width: 220px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="用户ID" prop="userId">
        <el-input v-model="queryParams.userId" placeholder="请输入用户ID" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="商品类型" prop="productType">
        <el-select v-model="queryParams.productType" placeholder="请选择类型" clearable style="width: 160px">
          <el-option label="会员套餐" value="MEMBERSHIP" />
          <el-option label="积分加量" value="ADDON" />
        </el-select>
      </el-form-item>
      <el-form-item label="订单状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 150px">
          <el-option label="待支付" value="CREATED" />
          <el-option label="已支付" value="PAID" />
          <el-option label="已关闭" value="CLOSED" />
        </el-select>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['system:payment:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderList">
      <el-table-column label="订单号" align="left" prop="outTradeNo" min-width="210" show-overflow-tooltip />
      <el-table-column label="用户" align="center" min-width="170">
        <template #default="scope">
          <div class="user-cell">
            <span class="user-name">{{ scope.row.userNickName || scope.row.userName || '-' }}</span>
            <span class="user-id">ID: {{ scope.row.userId }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="商品" align="center" min-width="170">
        <template #default="scope">
          <div class="product-cell">
            <span class="product-name">{{ scope.row.productName }}</span>
            <el-tag size="small" :type="scope.row.productType === 'MEMBERSHIP' ? 'warning' : 'success'" effect="plain">
              {{ formatProductType(scope.row.productType) }}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="金额" align="center" prop="amountCent" width="110">
        <template #default="scope">
          <span class="amount-text">￥{{ formatAmount(scope.row.amountCent) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="到账积分" align="center" prop="credits" width="110">
        <template #default="scope">
          <el-tag type="success" effect="plain">+{{ scope.row.credits }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template #default="scope">
          <el-tag :type="statusTagType(scope.row.status)">{{ formatStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="微信交易号" align="center" prop="transactionId" min-width="180" show-overflow-tooltip />
      <el-table-column label="创建时间" align="center" prop="createTime" width="170">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="支付时间" align="center" prop="paidTime" width="170">
        <template #default="scope">{{ parseTime(scope.row.paidTime) || '-' }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="150" fixed="right">
        <template #default="scope">
          <el-tooltip content="查看报文" placement="top">
            <el-button link type="primary" icon="Document" @click="handleViewRaw(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="手动查单" placement="top" v-if="scope.row.status !== 'PAID'">
            <el-button link type="primary" icon="Refresh" @click="handleSync(scope.row)" v-hasPermi="['system:payment:sync']"></el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="支付报文" v-model="rawOpen" width="760px" append-to-body>
      <pre class="raw-json">{{ rawText }}</pre>
      <template #footer>
        <el-button @click="rawOpen = false">关 闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="PaymentOrder">
import { listPaymentOrder, syncPaymentOrder } from "@/api/system/payment"

const { proxy } = getCurrentInstance()

const orderList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const dateRange = ref([])
const rawOpen = ref(false)
const rawText = ref("")

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    outTradeNo: undefined,
    userId: undefined,
    productType: undefined,
    status: undefined
  }
})

const { queryParams } = toRefs(data)

function getList() {
  loading.value = true
  listPaymentOrder(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    orderList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  dateRange.value = []
  proxy.resetForm("queryRef")
  handleQuery()
}

function handleExport() {
  proxy.download("system/payment/export", proxy.addDateRange({
    ...queryParams.value
  }, dateRange.value), `payment_order_${new Date().getTime()}.xlsx`)
}

function handleSync(row) {
  proxy.$modal.confirm(`确认向微信同步订单 ${row.outTradeNo} 吗？`).then(() => {
    return syncPaymentOrder(row.outTradeNo)
  }).then(() => {
    proxy.$modal.msgSuccess("同步完成")
    getList()
  })
}

function handleViewRaw(row) {
  rawText.value = formatRawText(row.rawNotify)
  rawOpen.value = true
}

function formatRawText(value) {
  if (!value) {
    return "暂无支付回调或查单报文"
  }
  try {
    return JSON.stringify(JSON.parse(value), null, 2)
  } catch (error) {
    return value
  }
}

function formatAmount(value) {
  return ((Number(value) || 0) / 100).toFixed(2)
}

function formatProductType(value) {
  if (value === "MEMBERSHIP") return "会员套餐"
  if (value === "ADDON") return "积分加量"
  return value || "-"
}

function formatStatus(value) {
  if (value === "CREATED") return "待支付"
  if (value === "PAID") return "已支付"
  if (value === "CLOSED") return "已关闭"
  return value || "-"
}

function statusTagType(value) {
  if (value === "PAID") return "success"
  if (value === "CREATED") return "warning"
  if (value === "CLOSED") return "info"
  return "info"
}

getList()
</script>

<style scoped>
.payment-order-page :deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

.user-cell,
.product-cell {
  display: flex;
  flex-direction: column;
  gap: 5px;
  line-height: 1.3;
}

.user-name,
.product-name {
  color: #303133;
  font-weight: 600;
}

.user-id {
  color: #909399;
  font-size: 12px;
}

.amount-text {
  color: #111;
  font-weight: 700;
}

.raw-json {
  max-height: 520px;
  margin: 0;
  padding: 16px;
  overflow: auto;
  border-radius: 8px;
  background: #111;
  color: #f5f5f5;
  font-family: Consolas, Monaco, monospace;
  font-size: 12px;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-all;
}
</style>
