<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:32
 * @LastEditTime: 2022-06-18 17:04:09
 * @Description: 表单设计列表
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" style="width: 200px" class="filter-item" :placeholder="'名称'" v-model="listQuery.key"> </el-input>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>

        <el-checkbox size="small" style="margin-left: 15px" @change="tableKey = tableKey + 1" v-model="showDescription">描述</el-checkbox>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <div class="bg-white" style="height: 100%">
        <el-table
          height="100%"
          ref="mainTable"
          :key="tableKey"
          :data="list"
          v-loading="listLoading"
          border
          fit
          highlight-current-row
          style="width: 100%"
          @row-click="rowClick"
          @selection-change="handleSelectionChange"
        >
          <el-table-column align="center" type="selection" width="55"> </el-table-column>

          <el-table-column :label="'Id'" min-width="120px">
            <template slot-scope="scope">
              <span>{{ scope.row.id }}</span>
            </template>
          </el-table-column>

          <el-table-column min-width="80px" :label="'名称'">
            <template slot-scope="scope">
              <span class="link-type" @click="handleUpdate(scope.row)">{{ scope.row.name }}</span>
            </template>
          </el-table-column>

          <el-table-column min-width="150px" v-if="showDescription" :label="'描述'">
            <template slot-scope="scope">
              <span style="color: red">{{ scope.row.description }}</span>
            </template>
          </el-table-column>

          <el-table-column class-name="status-col" :label="'状态'" width="100">
            <template slot-scope="scope">
              <span :class="scope.row.disabled | statusFilter">{{ statusOptions.find((u) => u.key == scope.row.disabled).display_name }}</span>
            </template>
          </el-table-column>

          <el-table-column align="center" :label="'操作'" width="230" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <el-button type="primary" size="mini" @click="handleUpdate(scope.row)">编辑</el-button>
              <el-button v-if="scope.row.disabled != 0" size="mini" type="danger" @click="handleModifyStatus(scope.row, 0)">停用</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
  </div>
</template>

<script>
import * as forms from '@/api/forms'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import { mapActions, mapGetters } from 'vuex'
import extend from '@/extensions/common.js'

export default {
  name: 'forms',
  components: {
    Sticky,
    permissionBtn,
  },
  mixins: [extend],
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      if (vm.isRender) {
        vm.getList()
      }
    })
  },
  directives: {
    waves,
  },
  data() {
    return {
      multipleSelection: [], // 列表checkbox选中的值
      tableKey: 0,
      list: null,
      total: null,
      listLoading: true,
      listQuery: {
        // 查询条件
        page: 1,
        limit: 20,
        key: undefined,
      },
      apps: [],
      statusOptions: [
        {
          key: 1,
          display_name: '停用',
        },
        {
          key: 0,
          display_name: '正常',
        },
      ],
      showDescription: true,
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加',
      },
      dialogPvVisible: false,
      pvData: [],
      rules: {
        name: [
          {
            required: true,
            message: '名称不能为空',
            trigger: 'blur',
          },
        ],
      },
      downloadLoading: false,
    }
  },
  filters: {
    statusFilter(disabled) {
      const statusMap = {
        0: 'color-success',
        1: 'color-danger',
      }
      return statusMap[disabled]
    },
  },
  computed: {
    ...mapGetters(['isRender']),
  },
  created() {
    this.getList()
  },
  methods: {
    ...mapActions({
      saveFormDetails: 'saveFormDetails',
      saveAddFormDetails: 'saveAddFormDetails',
      updateIsRender: 'updateIsRender',
    }),
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    onBtnClicked: function (domId) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd':
          this.saveAddFormDetails('')
          this.$router.push('/forms/add')
          break
        case 'btnEdit':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error',
            })
            return
          }
          this.handleUpdate(this.multipleSelection[0])
          break
        case 'btnDel':
          if (this.multipleSelection.length < 1) {
            this.$message({
              message: '至少删除一个',
              type: 'error',
            })
            return
          }
          this.handleDelete(this.multipleSelection)
          break
        default:
          break
      }
    },
    getList() {
      this.listLoading = true
      forms.getList(this.listQuery).then((response) => {
        this.list = response.data
        this.total = response.count
        this.updateIsRender(false)
        this.listLoading = false
      })
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleSizeChange(val) {
      this.listQuery.limit = val
      this.getList()
    },
    handleCurrentChange(val) {
      this.listQuery.page = val
      this.getList()
    },
    handleModifyStatus(row, disabled) {
      // 模拟修改状态
      this.$message({
        message: '操作成功',
        type: 'success',
      })
      row.disabled = disabled
    },
    handleUpdate(row) {
      // 弹出编辑框
      const data = {}
      data[row.id] = row
      this.saveFormDetails(data)
      this.$router.push({ path: '/forms/edit/' + row.id, query: { frmType: row.frmType } })
    },
    handleDelete(rows) {
      // 多行删除
      this.delrows(forms, rows)
    },
  },
}
</script>
