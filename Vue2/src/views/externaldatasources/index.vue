<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-03-12 23:34:34
 * @LastEditTime: 2025-03-18 21:29:37
 * @Description: 外部数据源管理
 * @Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved. 
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
        <auth-table style="height:calc(100% - 60px)" ref="mainTable" :select-type="'checkbox'"
          :table-fields="headerList" :data="list" :loading="listLoading" @row-click="rowClick"
          @selection-change="handleSelectionChange"></auth-table>
        <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit"
          @pagination="handleCurrentChange" />
      </div>
      <el-dialog v-el-drag-dialog class="dialog-mini" width="500px" :title="textMap[dialogStatus]"
        :visible.sync="dialogFormVisible">
        <auth-form ref="dataForm" :rules="rules" :edit-model="true" :form-fields="headerList" v-model="temp"
          :col-num="2"></auth-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button>
          <el-button size="small" type="default" :loading="btnLoading" @click="testConnection">测试</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>
<script>
import * as externalDataSources from '@/api/externalDataSources'
import ColumnDefine from '@/interface/columnDefine'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import { defaultVal } from '@/utils/index'
import extend from '@/extensions/common.js'
import AuthForm from '../../components/Base/AuthForm.vue'
import AuthTable from '../../components/Base/AuthTable.vue'
export default {
  name: 'resource',
  components: { Sticky, permissionBtn, Pagination, AuthTable, AuthForm },
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
      btnLoading: false, //测试按钮loading状态
      listQuery: {
        // 查询条件
        page: 1,
        limit: 20,
        key: undefined,
      },
      temp: {
        dbtype: 0,
        server: '',
        port: null,
        databasename: '',
        username: '',
        password: '',
        connectionstring: '',
        enabled: true,
        description: '',
        id: null,
        testsuccess: true,
        createuserid: null,
        createtime: null,
        createusername: '',
        updateuserid: null,
        updateusername: '',
        updatetime: null,
      },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加',
      },
      rules: {
        name: [{ required: true, message: '名称不能为空', trigger: 'blur' }],
      },
    }
  },
  watch: {
    // 监听temp对象的变化
    'temp.dbtype': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    },
    'temp.server': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    },
    'temp.port': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    },
    'temp.databasename': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    },
    'temp.username': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    },
    'temp.password': function(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.generateConnectionString()
      }
    }
  },
  created() {
    this.headerList = [
    new ColumnDefine('name', '数据源名称', true, true, '', '', 'string', 'varchar', 'Name'),
    new ColumnDefine('dbtype', '数据库类型', true, true, 'selectDynamic', '/externalDataSources/getdbtypes', 'int', 'int', 'Dbtype'),
    new ColumnDefine('server', '服务器地址', true, true, '', '', 'string', 'varchar', 'Server'),
    new ColumnDefine('port', '端口', true, true, '', '', 'int', 'int', 'Port'),
    new ColumnDefine('databasename', '数据库名称', true, true, '', '', 'string', 'varchar', 'Databasename'),
    new ColumnDefine('username', '用户名', true, true, '', '', 'string', 'varchar', 'Username'),
    new ColumnDefine('password', '密码', true, true, '', '', 'string', 'varchar', 'Password'),
    new ColumnDefine('connectionstring', '连接字符串', true, true, 'textarea', '', 'string', 'varchar', 'Connectionstring'),
    new ColumnDefine('enabled', '是否启用', true, true, 'switch', '', 'bool', 'tinyint', 'Enabled'),
    new ColumnDefine('description', '描述', true, true, 'textarea', '', 'string', 'varchar', 'Description'),
    new ColumnDefine('id', '主键', false, false, '', '', 'string', 'varchar', 'Id'),
    new ColumnDefine('testsuccess', '是否测试成功', false, false, '', '', 'bool', 'tinyint', 'Testsuccess'),
    new ColumnDefine('createuserid', '创建用户ID', false, false, '', '', 'string', 'varchar', 'Createuserid'),
    new ColumnDefine('createtime', '创建时间', false, false, '', '', 'DateTime', 'datetime', 'Createtime'),
    new ColumnDefine('createusername', '创建用户名', false, false, '', '', 'string', 'varchar', 'Createusername'),
    new ColumnDefine('updateuserid', '更新用户ID', false, false, '', '', 'string', 'varchar', 'Updateuserid'),
    new ColumnDefine('updateusername', '更新用户名', false, false, '', '', 'string', 'varchar', 'Updateusername'),
    new ColumnDefine('updatetime', '最后修改时间', false, false, '', '', 'DateTime', 'datetime', 'Updatetime')
  ]
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
    onBtnClicked: function (domId, callback) {
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
          this.$refs.mainTable.exportExcel('资源文件', callback)
          break
        default:
          break
      }
    },
    getList() {
      this.listLoading = true
      externalDataSources.getList(this.listQuery).then((response) => {
        this.list = response.data
        
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
      this.temp = Object.assign({}, obj) // copy obj
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
        externalDataSources.add(this.temp).then(() => {
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
        externalDataSources.update(tempData).then(() => {
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
      this.delrows(externalDataSources, rows)
    },
    testConnection() {
      // 测试连接
      this.btnLoading = true
      externalDataSources.testConnection({
        dbtype: this.temp.dbtype,
        connectionstring: this.temp.connectionstring
      }).then(response => {
        this.btnLoading = false
        this.$notify({
          title: '提醒',
          message: `测试结果${response.message}`,
          type: 'success',
          duration: 2000,
        })
      }).catch(() => {
        this.btnLoading = false
      })
    },
    
    // 根据数据库类型、服务器地址、端口等生成连接字符串
    generateConnectionString() {
      // 根据数据库类型生成不同的连接字符串
      switch (this.temp.dbtype) {
        case 0: // MySQL
          this.temp.connectionstring = `server=${this.temp.server};${this.temp.port ? 'Port=' + this.temp.port + ';' : ''}database=${this.temp.databasename};${this.temp.username ? `user id=${this.temp.username};password=${this.temp.password};` : ''}`
          break
        case 1: // SQL Server
          this.temp.connectionstring = `Data Source=${this.temp.server};${this.temp.port ? 'Port=' + this.temp.port + ';' : ''}Encrypt=false;Initial Catalog=${this.temp.databasename};User=${this.temp.username};Password=${this.temp.password};`
          break
        case 2: // SQLite
          this.temp.connectionstring = `Data Source=${this.temp.databasename};Version=3;`
          break
        case 3: // Oracle
          this.temp.connectionstring = `DATA SOURCE=${this.temp.server}:${this.temp.port}/${this.temp.databasename};USER ID=${this.temp.username};PASSWORD=${this.temp.password};Validate Connection=true;PERSIST SECURITY INFO=True;`
          break
        case 4: // PostgreSQL
          this.temp.connectionstring = `Host=${this.temp.server};Port=${this.temp.port};Database=${this.temp.databasename};Username=${this.temp.username};Password=${this.temp.password};`
          break
        default:
          // 默认格式
          this.temp.connectionstring = `Server=${this.temp.server};Database=${this.temp.databasename};User=${this.temp.username};Password=${this.temp.password};`
      }
    }
  },
}
</script>
<style>
.dialog-mini .el-select {
  width: 100%;
}
</style>
