<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:35
 * @LastEditTime: 2023-12-23 14:04:28
 * @Description: 用户管理
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" prefix-icon="el-icon-search" size="small"
          style="width: 200px; margin-bottom: 0;" class="filter-item" :placeholder="'关键字'" v-model="listQuery.key">
        </el-input>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
        <el-checkbox size="mini" style='margin-left:15px;' @change='tableKey = tableKey + 1'
          v-model="showDescription">Id/描述</el-checkbox>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <el-row :gutter="4" class="fh">
        <el-col :span="6" class="fh ls-border">
          <el-card shadow="never" class="body-small fh" style="overflow: auto">
            <div slot="header" class="clearfix">
              <el-button type="text" style="padding: 0 11px" @click="getAllUsers">全部用户>></el-button>
            </div>
            <el-tree :data="orgsTree" :expand-on-click-node="false" default-expand-all :props="defaultProps"
              @node-click="handleNodeClick"></el-tree>
          </el-card>
        </el-col>
        <el-col :span="18" class="fh">
          <div class="bg-white fh">
            <el-table ref="mainTable" :key='tableKey' :data="list" v-loading="listLoading" border fit
              highlight-current-row style="width: 100%;" height="calc(100% - 52px)" @row-click="rowClick"
              @selection-change="handleSelectionChange">
              <el-table-column align="center" type="selection" width="55">
              </el-table-column>
              <el-table-column :label="'Id'" v-if="showDescription" min-width="120px">
                <template slot-scope="scope">
                  <span>{{ scope.row.id }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'账号'">
                <template slot-scope="scope">
                  <span class="link-type" @click="handleUpdate(scope.row)">{{ scope.row.account }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'姓名'">
                <template slot-scope="scope">
                  <span>{{ scope.row.name }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="120px" :label="'所属部门'">
                <template slot-scope="scope">
                  <span>{{ scope.row.organizations }}</span>
                </template>
              </el-table-column>
              <el-table-column width="120px" :label="'直属上级'">
                <template slot-scope="scope">
                  <span>{{ scope.row.parentName }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="150px" v-if='showDescription' :label="'描述'">
                <template slot-scope="scope">
                  <span style='color:red;'>{{ scope.row.description }}</span>
                </template>
              </el-table-column>
              <el-table-column class-name="status-col" :label="'状态'" width="100">
                <template slot-scope="scope">
                  <span :class="scope.row.status | statusFilter">{{ statusOptions.find(u => u.key ==
                    scope.row.status).display_name }}</span>
                </template>
              </el-table-column>
              <el-table-column align="center" :label="'操作'" width="230" class-name="small-padding fixed-width">
                <template slot-scope="scope">
                  <el-button type="primary" size="mini" @click="handleUpdate(scope.row)">编辑</el-button>
                  <el-button v-if="scope.row.status == 0" size="mini" type="danger"
                    @click="handleModifyStatus(scope.row, 1)">停用</el-button>
                </template>
              </el-table-column>
            </el-table>
            <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit"
              @pagination="handleCurrentChange" />
          </div>
        </el-col>
      </el-row>
      <el-dialog class="dialog-mini" width="500px" v-el-drag-dialog :title="textMap[dialogStatus]"
        :visible.sync="dialogFormVisible">
        <el-form :rules="rules" ref="dataForm" :model="temp" label-position="right" label-width="100px">
          <el-form-item size="small" :label="'Id'" prop="id" v-show="dialogStatus == 'update'">
            <el-input v-model="temp.id" :disabled="true" size="small" placeholder="系统自动处理"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'账号'" prop="account">
            <el-input v-model="temp.account"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'姓名'">
            <el-input v-model="temp.name"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'密码'">
            <el-input v-model="temp.password"
              :placeholder="dialogStatus == 'update' ? '如果为空则不修改密码' : '如果为空则默认与账号相同'"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'状态'">
            <el-select class="filter-item" v-model="temp.status" placeholder="Please select">
              <el-option v-for="item in  statusOptions" :key="item.key" :label="item.display_name" :value="item.key">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item size="small" :label="'所属机构'">
            <treeselect v-if="dialogFormVisible" :options="orgsTree" :default-expand-level="3" :multiple="true"
              :flat="true" :open-on-click="true" :open-on-focus="true" :clear-on-select="true" v-model="selectOrgs">
            </treeselect>
          </el-form-item>
          <el-form-item size="small" :label="'直接上级'">
            <select-users placeholder="直接上级" :userNames="parentName" :users="temp.parentId"
              :ignore-auth="true" v-on:users-change="usersChange">
            </select-users>
          </el-form-item>
          <el-form-item size="small" :label="'描述'">
            <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4 }" placeholder="Please input"
              v-model="temp.description">
            </el-input>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button>
        </div>
      </el-dialog>
      <el-dialog width="516px" class="dialog-mini body-small" v-el-drag-dialog :title="'分配角色'"
        :visible.sync="dialogRoleVisible">
        <el-form ref="rolesForm" size="small" v-if="dialogRoleVisible" label-position="left">
          <el-form-item>
            <select-roles :roles="selectRoles" :userNames="selectRoleNames"
              v-on:roles-change="rolesChange"></select-roles>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogRoleVisible = false">取消</el-button>
          <el-button size="mini" type="primary" @click="acceRole">确认</el-button>
        </div>
      </el-dialog>
    </div>
    <print-preview ref="preView" />
  </div>
</template>
<script>
import {
  listToTreeSelect
} from '@/utils'
import * as accessObjs from '@/api/accessObjs'
import * as users from '@/api/users'
import * as apiRoles from '@/api/roles'
import * as login from '@/api/login'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import SelectRoles from '@/components/SelectRoles'
import SelectUsers from '@/components/SelectUsers'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import extend from "@/extensions/common.js"
export default {
  name: 'user',
  components: {
    Sticky,
    permissionBtn,
    Treeselect,
    SelectRoles,
    SelectUsers,
    Pagination
  },
  mixins: [extend],
  directives: {
    waves,
    elDragDialog
  },
  data() {
    return {
      defaultProps: { // tree配置项
        children: 'children',
        label: 'label'
      },
      multipleSelection: [], // 列表checkbox选中的值
      tableKey: 0,
      list: null,
      total: 0,
      listLoading: true,
      listQuery: { // 查询条件
        page: 1,
        limit: 20,
        orgId: '',
        key: undefined
      },
      apps: [],
      statusOptions: [{
        key: 1,
        display_name: '停用'
      },
      {
        key: 0,
        display_name: '正常'
      }
      ],
      showDescription: false,
      orgs: [], // 用户可访问到的组织列表
      orgsTree: [], // 用户可访问到的所有机构组成的树
      selectRoles: [], // 用户分配的角色
      selectRoleNames: '',
      temp: {
        id: undefined,
        description: '',
        organizations: '',
        organizationIds: '',
        account: '',
        name: '',
        password: '',
        parentId:'', //直接上级
        status: 0
      },
      parentName:'',  //直接上级姓名
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加'
      },
      dialogRoleVisible: false, // 分配角色对话框
      rules: {
        account: [{
          required: true,
          message: '账号不能为空',
          trigger: 'blur'
        }]
      },
      downloadLoading: false
    }
  },
  computed: {
    selectOrgs: {
      get: function () {
        if (this.dialogStatus === 'update') {
          return this.temp.organizationIds && this.temp.organizationIds.split(',')
        } else {
          return []
        }
      },
      set: function (v) {
        // console.log('set org:', v)
        var _this = this
        _this.temp.organizationIds = v.length > 0 && v.join(',') || ''
        var organizations = _this.orgs.filter((val) => {
          return _this.temp.organizationIds.indexOf(val.id) >= 0
        }).map(u => u.label)
        this.temp.organizations = organizations.join(',')
      }
    }
  },
  filters: {
    statusFilter(status) {
      var res = 'color-success'
      switch (status) {
        case 1:
          res = 'color-danger'
          break
        default:
          break
      }
      return res
    }
  },
  created() {
    this.getList()
  },
  mounted() {
    var _this = this // 记录vuecomponent
    login.getOrgs().then(response => {
      _this.orgs = response.result.map(function (item) {
        return {
          id: item.id,
          label: item.name,
          parentId: item.parentId || null
        }
      })
      var orgstmp = JSON.parse(JSON.stringify(_this.orgs))
      _this.orgsTree = listToTreeSelect(orgstmp)
    })
  },
  methods: {
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    handleNodeClick(data) {
      this.listQuery.orgId = data.id
      this.getList()
    },
    getAllUsers() {
      this.listQuery.orgId = ''
      this.getList()
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    usersChange(name, val) {
      if (name == 'users') {
        this.temp.parentId = val[0] //直接上级只取一个
      } else {
        this.parentName = val
      }
    },
    onBtnClicked: function (domId, args) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd':
          this.handleCreate()
          break
        case 'btnEdit':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.handleUpdate(this.multipleSelection[0])
          break
        case 'btnDel':
          if (this.multipleSelection.length < 1) {
            this.$message({
              message: '至少删除一个',
              type: 'error'
            })
            return
          }
          this.handleDelete(this.multipleSelection)
          break
        case 'btnPrint':
          if (this.multipleSelection.length < 1) {
            this.$message({
              message: '至少选择一个',
              type: 'error'
            })
            return
          }
          this.printPreview(this.$refs.preView, args, this.multipleSelection[0]);
          break
        case 'btnAccessRole':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.handleAccessRole(this.multipleSelection[0])
          break
        default:
          break
      }
    },
    getList() {
      this.listLoading = true
      users.getList(this.listQuery).then(response => {
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
    handleModifyStatus(row, status) { // 模拟修改状态
      this.$message({
        message: '操作成功',
        type: 'success'
      })
      row.status = status
    },
    resetTemp() {
      this.temp = {
        id: undefined,
        description: '',
        organizations: '',
        organizationIds: '',
        account: '',
        parentId:'',
        name: '',
        status: 0
      }
    },
    handleCreate() { // 弹出添加框
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() { // 保存提交
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          users.add(this.temp).then((response) => {
            this.temp.id = response.result
            this.list.unshift({...this.temp, ...{parentName:this.parentName}})
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: '创建成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleUpdate(row) { // 弹出编辑框
      if(row.id != this.temp.id && row.parentId != this.temp.parentId){
        this.parentName = ''; //如果两次编辑的不是同一条，需要把名称清空，否则会一直显示
      }
      this.temp = Object.assign({}, row) // copy obj
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    updateData() { // 更新提交
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.temp)
          users.update(tempData).then(() => {
            for (const v of this.list) {
              if (v.id === this.temp.id) {
                const index = this.list.indexOf(v)
                this.list.splice(index, 1, {...this.temp, ...{parentName:this.parentName}})
                break
              }
            }
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: '更新成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleDelete(rows) { // 多行删除
      this.delrows(users, rows)
    },
    handleAccessRole(row) { // 分配角色
      const _this = this
      this.temp = Object.assign({}, row) // copy obj
      apiRoles.loadForUser(this.temp.id).then(response => {
        _this.dialogRoleStatus = 'update'
        _this.dialogRoleVisible = true
        _this.selectRoles = response.result
        _this.getRoleList()
        _this.$nextTick(() => {
          _this.$refs['rolesForm'].clearValidate()
        })
      })
    },
    // 获取角色
    getRoleList() {
      apiRoles.getList({}).then(response => {
        this.selectRoleNames = [...response.result].filter(x => this.selectRoles.indexOf(x.id) > -1).map(item => item.name || item.account).join(',')
      })
    },
    rolesChange(type, val) {
      if (type === 'Texts') {
        this.selectRoleNames = val
        return
      }
      this.selectRoles = val
    },
    acceRole() {
      accessObjs.unAssignAndAssign({
        type: 'UserRole',
        firstId: this.temp.id,
        secIds: this.selectRoles
      }).then(() => {
        this.dialogRoleVisible = false
        this.$notify({
          title: '成功',
          message: '更新成功',
          type: 'success',
          duration: 2000
        })
      })
    }
  }
}
</script>
<style>
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
.el-card__header {
  padding: 12px 20px;
}
.body-small.dialog-mini .el-dialog__body .el-form {
  padding-right: 0px;
  padding-top: 0px;
}
</style>
