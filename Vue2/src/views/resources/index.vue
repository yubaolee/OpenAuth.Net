<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:34
 * @LastEditTime: 2023-09-13 22:18:18
 * @Description: 
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" style="width: 200px;" class="filter-item" :placeholder="'名称'" v-model="listQuery.key"> </el-input>
        <auth-select :isEdit="true" class="filter-item" :type="'dynamic'" :data-source="'/applications/load'" v-model="listQuery.appId" size="mini"></auth-select>
     
        <el-button class="filter-item" size="mini" v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <div class="bg-white" style="height: 100%;">
        <auth-table
          style="height:calc(100% - 60px)"
          ref="mainTable"
          :select-type="'checkbox'"
          :table-fields="headerList"
          :data="list"
          :loading="listLoading"
          @row-click="rowClick"
          @selection-change="handleSelectionChange"
        ></auth-table>
        <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="handleCurrentChange" />
      </div>
      <el-dialog v-el-drag-dialog class="dialog-mini" width="500px" :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible">
        <auth-form ref="dataForm" :rules="rules" :edit-model="true" :form-fields="headerList" v-model="temp" :col-num="2"></auth-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>
<script>
import * as resources from '@/api/resources'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import { defaultVal } from '@/utils/index'
import extend from '@/extensions/common.js'
import AuthForm from '../../components/Base/AuthForm.vue'
import AuthTable from '../../components/Base/AuthTable.vue'
import AuthSelect from '../../components/Base/AuthSelect.vue'
export default {
  name: 'resource',
  components: { Sticky, permissionBtn, Pagination, AuthTable, AuthForm,AuthSelect, },
  directives: {
    waves,
    elDragDialog,
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
        appId: undefined,
      },
      temp: { },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加',
      },
      rules: {
        appId: [{ required: true, message: '必须选择一个应用', trigger: 'change' }],
        name: [{ required: true, message: '名称不能为空', trigger: 'blur' }],
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
    onBtnClicked: function(domId,callback) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd':
          this.handleCreate()
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
          case 'btnExport':
            this.$refs.mainTable.exportExcel('资源文件',callback)
            break
        default:
          break
      }
    },
    getList() {
      this.listLoading = true
      resources.getList(this.listQuery).then((response) => {
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
    resetTemp() {
       let obj = {};
       this.headerList.forEach((item) => {
        obj[item.columnName] = defaultVal(item.entityType)
      })
      this.temp =Object.assign({}, obj) // copy obj
    },
    handleCreate() {
      // 弹出添加框
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() {
      // 保存提交
      this.$refs['dataForm'].validate(() => {
        resources.add(this.temp).then(() => {
          this.list.unshift(this.temp)
          this.dialogFormVisible = false
          this.$notify({
            title: '成功',
            message: '创建成功',
            type: 'success',
            duration: 2000,
          })
        })
      })
    },
    handleUpdate(row) {
      // 弹出编辑框
      this.temp = Object.assign({}, row) // copy obj
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    updateData() {
      // 更新提交
      this.$refs['dataForm'].validate(() => {
        const tempData = Object.assign({}, this.temp)
        resources.update(tempData).then(() => {
          for (const v of this.list) {
            if (v.id === this.temp.id) {
              const index = this.list.indexOf(v)
              this.list.splice(index, 1, this.temp)
              break
            }
          }
          this.dialogFormVisible = false
          this.$notify({
            title: '成功',
            message: '更新成功',
            type: 'success',
            duration: 2000,
          })
        })
      })
    },
    handleDelete(rows) {
      // 多行删除
      this.delrows(resources, rows)
    },
  },
}
</script>
<style>
.dialog-mini .el-select {
  width: 100%;
}
</style>
