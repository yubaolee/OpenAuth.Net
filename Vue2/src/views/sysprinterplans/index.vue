<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2023-09-16 19:59:57
 * @LastEditTime: 2023-09-16 21:37:07
 * @Description: 打印模板列表
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" style="width: 200px;" class="filter-item"
          :placeholder="'名称'" v-model="listQuery.key"> </el-input>
        <el-button class="filter-item" size="mini" v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <div class="bg-white" style="height: 100%;">
        <auth-table style="height:calc(100% - 60px)" ref="mainTable" :select-type="'checkbox'" :table-fields="headerList"
          :data="list" :v-loading="listLoading" @row-click="rowClick"
          @selection-change="handleSelectionChange"></auth-table>
        <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit"
          @pagination="handleCurrentChange" />
      </div>
    </div>
  </div>
</template>
<script>
import * as sysPrinterPlans from '@/api/sysPrinterPlans'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import extend from '@/extensions/common.js'
import AuthTable from '../../components/Base/AuthTable.vue'
export default {
  name: 'sysPrinterPlan',
  components: { Sticky, permissionBtn, Pagination, AuthTable },
  directives: {
    waves
  },
  mixins: [extend],
  data() {
    return {
      headerList: [], // 主列表列定义
      multipleSelection: [], // 列表checkbox选中的值
      tableKey: 0,
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        // 查询条件
        page: 1,
        limit: 20,
        key: undefined,
      },
    }
  },
  created() {
    this.getList()
  },
  methods: {

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
          this.$router.push('/sysprinterplans/design')
          break
        case 'btnEdit':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error',
            })
            return
          }
          // 弹出编辑框
          this.$router.push('/sysprinterplans/design/' + this.multipleSelection[0].id)
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
      sysPrinterPlans.getList(this.listQuery).then((response) => {
        this.list = response.data
        response.columnFields.forEach((item) => {
          // 首字母小写
          item.columnName = item.columnName.substring(0, 1).toLowerCase() + item.columnName.substring(1)
        })
        this.headerList = response.columnFields
        this.total = response.count
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
      this.listQuery.page = val.page
      this.listQuery.limit = val.limit
      this.getList()
    },

    handleDelete(rows) {
      // 多行删除
      this.delrows(sysPrinterPlans, rows)
    },
  },
}
</script>
<style>
.dialog-mini .el-select {
  width: 100%;
}
</style>
