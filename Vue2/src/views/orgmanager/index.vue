<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-03-23 18:39:46
 * @Description: 
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
      <el-row style="height: 100%;">
        <el-col :span="4" style="height: 100%;border: 1px solid #EBEEF5;">
          <el-card shadow="never" class="body-small" style="height: 100%;overflow:auto;">
            <div slot="header" class="clearfix">
              <el-button type="text" style="padding: 0 11px" @click="getAllOrgs">所有机构>></el-button>
            </div>

            <el-tree :data="orgsTree" :expand-on-click-node="false" default-expand-all :props="defaultProps"
              @node-click="handleNodeClick"></el-tree>
          </el-card>
        </el-col>
        <el-col :span="20" style="height: 100%;">
          <div class="bg-white" style="height: 100%;">
            <el-table ref="mainTable" :key='tableKey' :data="list" v-loading="listLoading" border fit
              highlight-current-row style="width: 100%;" height="calc(100% - 52px)" @row-click="rowClick"
              @selection-change="handleSelectionChange">
              <el-table-column type="selection" align="center" width="55">
              </el-table-column>

              <el-table-column :label="'Id'" v-if="showDescription" min-width="120px">
                <template slot-scope="scope">
                  <span>{{ scope.row.id }}</span>
                </template>
              </el-table-column>

              <el-table-column min-width="80px" :label="'层级ID'">
                <template slot-scope="scope">
                  <span class="link-type" @click="handleUpdate(scope.row)">{{ scope.row.cascadeId }}</span>
                </template>
              </el-table-column>

              <el-table-column min-width="80px" :label="'名称'">
                <template slot-scope="scope">
                  <span>{{ scope.row.name }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'部门负责人'">
                <template slot-scope="scope">
                  <span>{{ scope.row.chairmanName }}</span>
                </template>
              </el-table-column>

              <el-table-column width="120px" :label="'上级部门'">
                <template slot-scope="scope">
                  <span>{{ scope.row.parentName }}</span>
                </template>
              </el-table-column>

              <el-table-column class-name="status-col" :label="'状态'" width="100">
                <template slot-scope="scope">
                  <span :class="scope.row.status | statusFilter">{{ statusOptions.find(u => u.key ==
                    scope.row.status).display_name }}</span>
                </template>
              </el-table-column>

              <el-table-column align="center" :label="'操作'" width="150" class-name="small-padding fixed-width">
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



      <el-dialog v-el-drag-dialog class="dialog-mini" width="500px" :title="textMap[dialogStatus]"
        :visible.sync="dialogFormVisible">
        <el-form :rules="rules" ref="dataForm" :model="temp" label-position="right" label-width="100px">
          <el-form-item size="small" :label="'Id'" prop="id" v-show="dialogStatus == 'update'">
            <span>{{ temp.id }}</span>
          </el-form-item>
          <el-form-item size="small" :label="'层级ID'" v-show="dialogStatus == 'update'">
            <span>{{ temp.cascadeId }}</span>
          </el-form-item>
          <el-form-item size="small" :label="'名称'" prop="name">
            <el-input v-model="temp.name"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'负责人'">
            <select-users :single="true" placeholder="请先分配用户,再选定负责人" :userNames="chairmanName" :orgId="temp.id" :users="temp.chairmanId"
              :ignore-auth="true" v-on:users-change="usersChange">
            </select-users>
          </el-form-item>
          <el-form-item size="small" :label="'状态'">
            <el-select class="filter-item" v-model="temp.status" placeholder="Please select">
              <el-option v-for="item in  statusOptions" :key="item.key" :label="item.display_name" :value="item.key">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item size="small" :label="'上级机构'">
            <treeselect ref="orgsTree" :options="mechOrgsTree" :default-expand-level="3" :multiple="false"
              :open-on-click="true" :open-on-focus="true" :clear-on-select="true" v-model="selectOrgs"></treeselect>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button>
        </div>
      </el-dialog>
      <!-- 添加角色用户 -->
      <el-dialog class="dialog-mini user-dialog" v-el-drag-dialog :title="'分配用户'"
        :visible.sync="roleUsers.dialogUserResource">
        <selectUsersCom ref="selectUser" v-if="roleUsers.dialogUserResource"
          :hiddenFooter="true" :loginKey="'loginUser'" :users.sync="assignedUserIds"
          :userNames="roleUsers.rowIndex > -1 && roleUsers.list[roleUsers.rowIndex].map(u => u.name || u.account).join(',')">
        </selectUsersCom>
        <div style="text-align:right;" slot="footer">
          <el-button size="small" type="cancel" @click="roleUsers.dialogUserResource = false">取消</el-button>
          <el-button size="small" type="primary" @click="handleSaveUsers">确定</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import {
  listToTreeSelect
} from '@/utils'
import * as orgs from '@/api/orgs'
import * as apiUsers from '@/api/users'
import * as login from '@/api/login'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import selectUsersCom from '@/components/SelectUsersCom'
import SelectUsers from '@/components/SelectUsers'
import extend from "@/extensions/common.js"

export default {
  name: 'org',
  components: {
    Sticky,
    permissionBtn,
    Treeselect,
    Pagination,
    selectUsersCom,
    SelectUsers
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
      subLists: [],
      total: 0,
      currentOrgId: '',
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
      chairmanName: '', //部门负责人姓名（因不需要数据库存储，所以不放入temp中）
      temp: {
        id: undefined,
        cascadeId: '',
        parentName: '',
        parentId: null,
        name: '',
        chairmanId: '',
        status: 0
      },
      dialogFormVisible: false,
      chkRoot: false, // 根节点是否选中
      treeDisabled: true, // 树选择框时候可用
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加'
      },
      rules: {
        name: [{
          required: true,
          message: '名称不能为空',
          trigger: 'blur'
        }]
      },
      downloadLoading: false,
      selectOrgs: '',
      /**
       * 组织已分配的用户ID
       */
      assignedUserIds: [],
      roleUsers: {
        dialogUserResource: false,
        Texts: '',
        rowIndex: -1,
        selectUsers: [],
        list: []
      }
    }
  },
  watch: {
    selectOrgs() {
      if (this.selectOrgs === undefined || this.selectOrgs === null || this.selectOrgs === '') { // 如果是根节点
        this.temp.parentName = '根节点'
        this.temp.parentId = ''
        this.isRoot = true
        return
      }
      this.isRoot = false
      this.temp.parentId = this.selectOrgs
      var parentname = this.orgs.find((val) => {
        return this.selectOrgs === val.id
      }).label
      this.temp.parentName = parentname
    }
  },
  computed: {
    mechOrgsTree() {
      const arr = [{
        id: '',
        label: '根节点',
        parentId: null
      }]
      return arr.concat(this.orgsTree)
    },
    isRoot: {
      get() {
        return this.chkRoot
      },
      set(v) {
        this.chkRoot = v
        if (v) {
          this.temp.parentName = '根节点'
          this.temp.parentId = ''
        }
        this.treeDisabled = v
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
    this.getOrgTree()
  },
  methods: {
    loadRoleUsers() {
      var _this = this
      this.isLoading = true
      apiUsers.LoadByOrg({ page: 1, limit: 99999, orgId: _this.multipleSelection[0].id }).then(response => {
        this.roleUsers.dialogUserResource = true
        _this.roleUsers.list[this.roleUsers.rowIndex] = response.data || []
        _this.assignedUserIds = _this.roleUsers.list[this.roleUsers.rowIndex].map(u => u.id)
      })
    },
    handleSaveUsers() {
      this.$refs.selectUser.handleSaveUsers()
      const postData = {
        orgId: this.multipleSelection[0].id,
        userIds: this.assignedUserIds || []
      }
      orgs.AssignOrgUsers(postData).then(() => {
        this.$message.success('添加成功')
        this.roleUsers.dialogUserResource = false
      })
    },
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    handleNodeClick(data) {
      this.currentOrgId = data.id
      this.getList()
    },
    getAllOrgs() {
      this.currentOrgId = ''
      this.getList()
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    onBtnClicked: function (domId) {
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
        case 'btnAssignOrgUser':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.roleUsers.rowIndex = this.list.findIndex(item => item.id === this.multipleSelection[0].id)
          this.loadRoleUsers()
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
        default:
          break
      }
    },
    usersChange(name, val) {
      if (name == 'users') {
        this.temp.chairmanId = val[0] //负责人只取一个
      } else {
        this.chairmanName = val
      }
    },
    getList() {
      this.listLoading = true
      login.getSubOrgs({ orgId: this.currentOrgId, limit: this.listQuery.limit, page: this.listQuery.page }).then(response => {
        this.subLists = Object.assign([], response.data)
        this.total = response.count
        this.listLoading = false
        this.pageSubOrgs()
      })
    },
    pageSubOrgs() {
      this.list = this.subLists.slice((this.listQuery.page - 1) * this.listQuery.limit, this.listQuery.page * (this.listQuery.limit))
      this.roleUsers.selectUsers = this.list.map(() => { return { users: [], Texts: '' } })
    },
    getOrgTree() {
      var _this = this // 记录vuecomponent
      login.getOrgs().then(response => {
        _this.orgs = response.data.map(function (item) {
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
      this.pageSubOrgs()
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
        cascadeId: '',
        parentName: '根节点',
        chairmanId: '',
        parentId: '',
        name: '',
        status: 0
      }
    },
    handleCreate() { // 弹出添加框
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.selectOrgs = ''
      this.chairmanName=''
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() { // 保存提交
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          orgs.add(this.temp).then((response) => {
            // 需要回填数据库生成的数据
            this.temp.id = response.data.id
            this.temp.cascadeId = response.data.cascadeId
            this.list.unshift({...this.temp, ...{chairmanName:this.chairmanName}})
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: '创建成功',
              type: 'success',
              duration: 2000
            })
            this.getOrgTree()
          })
        }
      })
    },
    handleUpdate(row) { // 弹出编辑框
      if(row.id != this.temp.id && row.chairmanId != this.temp.chairmanId){
        this.chairmanName = ''; //如果两次编辑的不是同一条，需要把名称清空，否则会一直显示
      }
      this.temp = Object.assign({}, row) // copy obj
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.selectOrgs = this.temp.parentId
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    updateData() { // 更新提交
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.temp)
          orgs.update(tempData).then(() => {
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: '更新成功',
              type: 'success',
              duration: 2000
            })

            this.getOrgTree()
            for (const v of this.list) {
              if (v.id === this.temp.id) {
                const index = this.list.indexOf(v)
                this.list.splice(index, 1, {...this.temp, ...{chairmanName:this.chairmanName}})
                break
              }
            }
          })
        }
      })
    },
    handleDelete(rows) { // 多行删除
      this.delrows(orgs, rows, this.getOrgTree)
    }
  }
}

</script>

<style lang="scss" scoped>
.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}

.clearfix:after {
  clear: both
}

.el-select.filter-item.el-select--small {
  width: 100%;
}

::v-deep .user-dialog {
  .el-dialog {
    height: 70%;

    .el-icon-close {
      padding-top: 10px;
    }

    .el-dialog__body {
      height: calc(100% - 35px - 40px);
    }

    .el-dialog__headerbtn {
      top: 0;
    }
  }
}
</style>
