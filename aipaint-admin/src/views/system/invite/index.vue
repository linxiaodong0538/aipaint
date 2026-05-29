<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="邀请人ID" prop="inviterUserId">
        <el-input
          v-model="queryParams.inviterUserId"
          placeholder="请输入邀请人ID"
          clearable
          style="width: 180px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="被邀请人ID" prop="invitedUserId">
        <el-input
          v-model="queryParams.invitedUserId"
          placeholder="请输入被邀请人ID"
          clearable
          style="width: 180px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="奖励状态" prop="rewardStatus">
        <el-select v-model="queryParams.rewardStatus" placeholder="请选择状态" clearable style="width: 160px">
          <el-option label="已发放" value="GRANTED" />
        </el-select>
      </el-form-item>
      <el-form-item label="邀请时间">
        <el-date-picker
          v-model="dateRange"
          value-format="YYYY-MM-DD"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['system:invite:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="recordList">
      <el-table-column label="记录ID" align="center" prop="recordId" width="90" />
      <el-table-column label="邀请人" align="center" min-width="180">
        <template #default="scope">
          <div class="user-cell">
            <span class="user-name">{{ scope.row.inviterNickName || scope.row.inviterUserName || '-' }}</span>
            <span class="user-id">ID: {{ scope.row.inviterUserId }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="被邀请人" align="center" min-width="180">
        <template #default="scope">
          <div class="user-cell">
            <span class="user-name">{{ scope.row.invitedNickName || scope.row.invitedUserName || '-' }}</span>
            <span class="user-id">ID: {{ scope.row.invitedUserId }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="奖励积分" align="center" prop="rewardAmount" width="110">
        <template #default="scope">
          <el-tag type="success" effect="plain">+{{ scope.row.rewardAmount }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="奖励状态" align="center" prop="rewardStatus" width="110">
        <template #default="scope">
          <el-tag v-if="scope.row.rewardStatus === 'GRANTED'" type="success">已发放</el-tag>
          <el-tag v-else type="info">{{ scope.row.rewardStatus || '-' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="邀请时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script setup name="InviteRecord">
import { listInviteRecord } from "@/api/system/invite"

const { proxy } = getCurrentInstance()

const recordList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const dateRange = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    inviterUserId: undefined,
    invitedUserId: undefined,
    rewardStatus: undefined
  }
})

const { queryParams } = toRefs(data)

function getList() {
  loading.value = true
  listInviteRecord(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    recordList.value = response.rows
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
  proxy.download("system/invite/export", proxy.addDateRange({
    ...queryParams.value
  }, dateRange.value), `invite_record_${new Date().getTime()}.xlsx`)
}

getList()
</script>

<style scoped>
.user-cell {
  display: flex;
  flex-direction: column;
  gap: 4px;
  line-height: 1.3;
}

.user-name {
  color: #303133;
  font-weight: 500;
}

.user-id {
  color: #909399;
  font-size: 12px;
}
</style>
