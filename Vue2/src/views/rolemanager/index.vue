<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" prefix-icon="el-icon-search" size="small"
          style="width: 200px; margin-bottom: 0;" class="filter-item" :placeholder="'关键字'" v-model="listQuery.key">
        </el-input>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
        <el-checkbox size="small" style='margin-left:15px;' @change='tableKey = tableKey + 1'
          v-model="showDescription">Id/描述</el-checkbox>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <div class="bg-white fh">
        <el-table ref="mainTable" :key='tableKey' :data="list" v-loading="listLoading" border fit highlight-current-row
          style="width: 100%;" height="calc(100% - 52px)" @row-click="rowClick"
          @selection-change="handleSelectionChange">
          <el-table-column align="center" type="selection" width="55">
          </el-table-column>
          <el-table-column :label="'Id'" v-if="showDescription" min-width="120px">
            <template slot-scope="scope">
              <span>{{ scope.row.id }}</span>
            </template>
          </el-table-column>
          <el-table-column min-width="50px" :label="'角色名称'">
            <template slot-scope="scope">
              <span>{{ scope.row.name }}</span>
            </template>
          </el-table-column>
          <el-table-column min-width="300px" :label="'用户列表'">
            <template slot-scope="scope" v-if="list.length > 0">
              <role-users ref="roleUser" :role-id="scope.row.id"
                :selectUsers.sync="roleUsers.list[scope.$index]"></role-users>
            </template>
          </el-table-column>
          <el-table-column class-name="status-col" :label="'状态'" width="100">
            <template slot-scope="scope">
              <span :class="scope.row.status | statusFilter">{{statusOptions.find(u => u.key ==
                scope.row.status).display_name}}</span>
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
      <el-dialog width="500px" v-el-drag-dialog class="dialog-mini" :title="textMap[dialogStatus]"
        :visible.sync="dialogFormVisible">
        <el-form :rules="rules" ref="dataForm" :model="temp" label-position="right" label-width="100px">
          <el-form-item size="small" :label="'Id'" prop="id" v-show="dialogStatus == 'update'">
            <el-input v-model="temp.id" :disabled="true" placeholder="系统自动处理"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'角色名称'" prop="name">
            <el-input v-model="temp.name"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'状态'">
            <el-select class="filter-item" v-model="temp.status" placeholder="Please select">
              <el-option v-for="item in statusOptions" :key="item.key" :label="item.display_name" :value="item.key">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="small" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="small" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="small" v-else type="primary" @click="updateData">确认</el-button>
        </div>
      </el-dialog>
      <!--只有这么写dialog，才能正常触发ESC关闭-->
      <el-dialog class="dialog-mini" ref="accessModulesDlg" v-el-drag-dialog :title="accessTitle"
        :visible.sync="dialogAccessModules">
        <access-modules ref="accessModules" v-if="dialogAccessModules" :role-id="multipleSelection[0].id"
          @change-title="changeTitle" @close="dialogAccessModules = false"></access-modules>
      </el-dialog>
      <el-dialog class="dialog-mini" v-el-drag-dialog :title="'为角色分配资源'" :visible.sync="dialogAccessResource">
        <access-resource ref="accessResource" v-if="dialogAccessResource" :users.sync="assignedResourceIds"
          :userNames="assignedResourceNames" @close="dialogAccessResource = false" :hiddenFooter="true"></access-resource>
        <div style="text-align: right" slot="footer">
          <el-button size="small" type="info" @click="dialogAccessResource = false">
            取消
          </el-button>
          <el-button size="small" type="primary" @click="handleSaveResource">
            确定
          </el-button>
        </div>
      </el-dialog>
      <!-- 添加角色用户 -->
      <el-dialog class="dialog-mini user-dialog" v-el-drag-dialog :title="'添加角色用户'"
        :visible.sync="roleUsers.dialogUserResource">
        <selectUsersCom ref="selectUser" v-if="roleUsers.dialogUserResource" :hiddenFooter="true"
          :loginKey="'loginUser'" :users.sync="assignedUserIds"
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
import * as roles from '@/api/roles'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import RoleUsers from '@/components/RoleUsers'
import * as resourcesApi from '@/api/resources'
import permissionBtn from '@/components/PermissionBtn'
import accessModules from '@/components/AccessModules'
import accessResource from './assignRes'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import selectUsersCom from '@/components/SelectUsersCom'
export default {
  name: 'role',
  components: {
    RoleUsers,
    Sticky,
    permissionBtn,
    accessModules,
    accessResource,
    Pagination,
    selectUsersCom
  },
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
      roleList: [],
      total: 0,
      listLoading: true,
      listQuery: { // 查询条件
        page: 1,
        limit: 20,
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
      temp: {
        id: undefined,
        organizations: '',
        organizationIds: '',
        name: '',
        status: 0
      },
      dialogAccessModules: false, // 角色分配模块对话框
      dialogAccessResource: false, // 分配资源对话框
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加'
      },
      dialogPvVisible: false,
      pvData: [],
      rules: {
        name: [{
          required: true,
          message: '账号不能为空',
          trigger: 'blur'
        }]
      },
      downloadLoading: false,
      assignedResourceIds: [],
      assignedResourceNames: '',
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
      },
      accessTitle: '为角色分配模块菜单'
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
  methods: {
    changeTitle(val) { // 自动调整对话框标题
      this.accessTitle = val
    },
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    getAllroles() {
      this.getList()
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    onBtnClicked: function (domId) {
      console.log(domId)
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
        case 'btnAccessModule':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.dialogAccessModules = true
          break
        case 'btnAssignReource':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          resourcesApi.loadForRole(this.multipleSelection[0].id)
            .then(response => {
              this.assignedResourceIds = response.data.map(u => u.id)
              this.assignedResourceNames = response.data.map(u => u.name).join(',')
              this.dialogAccessResource = true
            })
          break
        case 'btnRoleAccessUser':
          if (this.multipleSelection.length !== 1) {
            this.$message({
              message: '只能选中一个进行分配',
              type: 'error'
            })
            return
          }
          this.roleUsers.rowIndex = this.list.findIndex(item => item.id === this.multipleSelection[0].id)
          this.assignedUserIds = this.roleUsers.list[this.roleUsers.rowIndex].map(u => u.id)
          this.roleUsers.dialogUserResource = true
          break
        default:
          break
      }
    },
    handleSaveUsers() {
      this.$refs.selectUser.handleSaveUsers()
      const postData = {
        roleId: this.multipleSelection[0].id,
        userIds: this.assignedUserIds || []
      }
      roles.AssignRoleUsers(postData).then(() => {
        this.$message.success('添加成功')
        this.roleUsers.dialogUserResource = false
        this.getList()
      })
    },
    getList() {
      this.listLoading = true
      this.list = []
      roles.getList(this.listQuery).then(response => {
        this.roleList = response.data
        this.total = response.data.length
        this.listLoading = false
        this.pageFn()
      })
    },
    pageFn() {
      this.list = this.roleList.slice((this.listQuery.page - 1) * this.listQuery.limit, this.listQuery.page * (this.listQuery.limit))
      this.roleUsers.selectUsers = this.list.map(() => { return { users: [], Texts: '' } })
      this.roleUsers.list = this.list.map(() => [])
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
      this.list = []
      setTimeout(() => {
        this.pageFn()
      })
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
        organizations: '',
        organizationIds: '',
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
          roles.add(this.temp).then((response) => {
            this.roleUsers.list.unshift([])
            this.temp.id = response.data.id
            this.list.unshift(this.temp)
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
          roles.update(tempData).then(() => {
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
              duration: 2000
            })
          })
        }
      })
    },
    handleDelete(rows) { // 多行删除
      roles.del(rows.map(u => u.id)).then(() => {
        this.$notify({
          title: '成功',
          message: '删除成功',
          type: 'success',
          duration: 2000
        })
        rows.forEach(row => {
          const index = this.list.indexOf(row)
          this.list.splice(index, 1)
          this.roleUsers.list.splice(index, 1)
        })
      })
    },
    handleSaveResource() {
      this.$refs.accessResource.handleSaveResource()
      const postData = {
        roleId: this.multipleSelection[0].id,
        resourceIds: this.assignedResourceIds || [],
      }
      roles.assignRoleResources(postData).then(() => {
        this.$message.success('分配成功')
        this.dialogAccessResource = false
      })
    }
  }
}
</script>
<style lang="scss">
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
.el-card__header {
  padding: 12px 20px;
}
.user-dialog {
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
