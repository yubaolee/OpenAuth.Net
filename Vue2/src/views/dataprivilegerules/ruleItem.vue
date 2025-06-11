<!--
 * @description: 数据权限中的表单项
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-09-28 获取字段的方式调整为按代码生成器定义的表结构
-->

<template>
  <div class="rule-group-box flex-row">
    <div class="rule-groups flex-item flex-column">
      <div class="rule-head flex-row">
        <div class="flex-item">
          <el-select class="sellect-operation" size="mini" v-model="ruleForm.Operation">
            <el-option v-for="item in operations" :key="item.value" :label="item.label" :value="item.value"></el-option>
          </el-select>
        </div>
        <el-button size="mini" class="VM" type="danger" icon="el-icon-delete" v-if="isDelete" @click="deleteGroupRule(parentForm)">删除分组</el-button>
        <el-button size="mini" class="VM" type="primary" icon="el-icon-plus" @click="addGroupRule(ruleForm)">添加分组</el-button>
      </div>
      <div class="rule-form flex-item">
        <template v-for="(rule, ruleIndex) in ruleForm.Filters">
          <el-form :key="createKey(rule.Key)">
            <el-form-item style="display: inline-block;margin-bottom: 0;margin-right: 5px;">
              <el-select size="mini" v-model="rule.Key" @change="handleChangeKey(rule)">
                <el-option v-for="item in propertyData" :key="item.columnName" :label="item.remark" :value="item.columnName"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item style="display: inline-block;width:110px;margin-bottom: 0;margin-right: 5px;">
              <el-select size="mini" v-model="rule.Contrast">
                <el-option v-for="item in contrasts" :key="item.value" :label="item.label" :value="item.value"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item v-if="handleShowMore(rule.Key)" style="display: inline-block;margin-bottom: 0;width:260px;margin-right: 5px;">
              <el-input :readonly="['CreateUserId', 'CreateUserName'].indexOf(rule.Key) >= 0 ? false : true" size="mini" style="text-overflow: ellipsis;padding-right: 30px;" v-model="rule.Text"></el-input>
              <span style="position: absolute;right: 0;top:6px;bottom:7px;line-height: 28px;display:inline-block;background: #fff;border: 1px solid #DCDFE6;padding: 0 10px;border-radius: 0 4px 4px 0;cursor:pointer;" @click="handleSelectUser(ruleForm, ruleIndex)"><i class="el-icon-more"></i></span>
            </el-form-item>
            <el-form-item v-else style="display: inline-block;margin-bottom: 0;width:260px;margin-right: 5px;">
              <el-popover ref="popover4" placement="bottom" width="250" trigger="focus">
                <el-input slot="reference" size="mini" v-model="rule.Value"></el-input>
                <div>
                  <el-tag size="mini" style="margin: 0 10px 10px 0;cursor: pointer;" @click="handleSelectCurrentName(item.columnName, rule, ruleIndex)" v-for="(item, index) in keys" :key="index">{{ item.currentName }}</el-tag>
                </div>
              </el-popover>
            </el-form-item>
            <el-button type="danger" size="mini" icon="el-icon-delete" v-if="ruleForm.Filters.length > 1" @click="deleteRule(ruleForm, ruleIndex)"></el-button>
            <el-button type="primary" size="mini" icon="el-icon-plus" v-if="ruleIndex === ruleForm.Filters.length - 1" @click="addRule(ruleForm)"></el-button>
          </el-form>
        </template>
        <template v-if="ruleForm.Children && ruleForm.Children.length > 0">
          <rule-item :level="index" v-for="(child, index) in ruleForm.Children" :propertyDatas="propertyDatas" :key="index" :ruleForm="child" :parentForm="ruleForm"></rule-item>
        </template>
      </div>
    </div>

    <!-- 选择角色/用户 -->
    <el-dialog :destroy-on-close="true" class="dialog-mini custom-dialog user-dialog" width="850px" :title="loginKey === '{loginUser}' ? '选择用户' : '选择角色'" :visible.sync="selectDialog">
      <div v-if="selectDialog" class="flex-row" style="height: 100%;">
        <div class="part-box" v-if="loginKey === '{loginUser}'">
          <el-card shadow="never" class="body-small custom-card" style="height: 100%;">
            <div slot="header" class="clearfix">
              <el-button type="text" style="padding: 0 11px" @click="getAllUsers">全部用户>></el-button>
            </div>

            <el-tree :data="orgsTree" :expand-on-click-node="false" default-expand-all @node-click="handleNodeClick"></el-tree>
          </el-card>
        </div>
        <div class="flex-item table-box">
          <div class="flex-row" style="align-items: center;" v-if="loginKey === '{loginUser}'" @keyup.13="handleSearchUser">
            <el-input size="mini" style="margin: 10px;width: 200px;" placeholder="请输入内容" v-model="searchKey">
              <i slot="prefix" class="el-input__icon el-icon-search"></i>
            </el-input>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleSearchUser">查询</el-button>
            <div style="text-align: right;padding: 5px 10px;" class="flex-item ellipsis" v-if="names">选中用户：{{ names }}</div>
          </div>
          <el-table ref="multipleTable" height="calc(100% - 60px - 45px)" v-if="loginKey === '{loginUser}'" :data="tableData.datas" tooltip-effect="dark" v-loading="tableData.loading" style="width: 100%;border-top: 1px solid #e4e4e4;" @select="handleSelectionUser" @select-all="handleSelectionUser">
            <!-- @selection-change="handleSelectionUser"> -->
            <el-table-column align="center" type="selection" width="55"> </el-table-column>

            <el-table-column align="center" min-width="80px" :label="'账号'">
              <template slot-scope="scope">
                <span class="link-type">{{ scope.row.account }}</span>
              </template>
            </el-table-column>

            <el-table-column align="center" min-width="80px" :label="'姓名'">
              <template slot-scope="scope">
                <span>{{ scope.row.name }}</span>
              </template>
            </el-table-column>

            <el-table-column align="center" :label="'所属部门'">
              <template slot-scope="scope">
                <span>{{ scope.row.organizations }}</span>
              </template>
            </el-table-column>

            <el-table-column align="center" class-name="status-col" :label="'状态'" width="100">
              <template slot-scope="scope">
                <span :class="scope.row.status | userStatusFilter">{{ statusOptions.find((u) => u.key == scope.row.status).display_name }}</span>
              </template>
            </el-table-column>
          </el-table>
          <el-table ref="multipleTable" height="calc(100%)" v-else :data="tableData.datas" tooltip-effect="dark" v-loading="tableData.loading" border style="width: 100%;" @select="handleSelectionUser" @select-all="handleSelectionUser">
            <!-- @selection-change="handleSelectionUser"> -->
            <el-table-column align="center" type="selection" width="55"> </el-table-column>

            <el-table-column align="center" min-width="50px" :label="'角色名称'">
              <template slot-scope="scope">
                <span>{{ scope.row.name }}</span>
              </template>
            </el-table-column>

            <!-- <el-table-column min-width="300px" :label="'用户列表'">
              <template slot-scope="scope">
                <role-users :role-id="scope.row.id"></role-users>
              </template>
            </el-table-column> -->

            <el-table-column align="center" class-name="status-col" :label="'状态'" width="100">
              <template slot-scope="scope">
                <span :class="scope.row.status | userStatusFilter">{{ statusOptions.find((u) => u.key == scope.row.status).display_name }}</span>
              </template>
            </el-table-column>
          </el-table>
          <el-pagination background v-if="loginKey === '{loginUser}'" layout="prev, pager, next" :total="tableData.total" :page-size="tableData.listQuery.limit" @current-change="handlePageSearch" style="margin-top: 15px;text-align: right;"> </el-pagination>
        </div>
      </div>
      <div style="text-align:right;margin-top: 10px;">
        <el-button size="small" type="cancel" @click="selectDialog = false">取消</el-button>
        <el-button size="small" type="primary" @click="handleSaveUsers">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import { listToTreeSelect } from '@/utils'
import * as login from '@/api/login'
import * as users from '@/api/users'
import * as roles from '@/api/roles'
export default {
  name: 'ruleItem',
  props: {
    ruleForm: Object,
    level: Number,
    parentForm: Object,
    isDelete: {
      type: Boolean,
      default: true
    },
    propertyDatas: Array
  },
  data() {
    return {
      contrasts: [
        {
          label: '大于等于',
          value: '>='
        },
        {
          label: '小于等于',
          value: '<='
        },
        {
          label: '等于',
          value: '=='
        },
        {
          label: '不等于',
          value: '!='
        },
        {
          label: '包含',
          value: 'contains'
        },
        {
          label: '属于',
          value: 'in'
        },
        {
          label: '含有任意一个',
          value: 'intersect'
        }
      ],
      operations: [
        {
          label: '并且',
          value: 'and'
        },
        {
          label: '或者',
          value: 'or'
        }
      ],
      keys: [
        {
          remark: '{当前登录用户的角色}',
          columnName: '{loginRole}',
          currentName: '当前登录用户的角色'
        },
        {
          remark: '{当前登录的用户}',
          columnName: '{loginUser}',
          currentName: '当前登录的用户'
        },
        {
          remark: '{当前登录用户的部门}',
          columnName: '{loginOrg}',
          currentName: '当前登录用户的部门'
        }
      ],
      selectDialog: false,
      statusOptions: [
        {
          key: true,
          display_name: '停用'
        },
        {
          key: false,
          display_name: '正常'
        }
      ],
      userInfo: {
        listQuery: {
          // 查询条件
          page: 1,
          limit: 15,
          orgId: '',
          key: undefined
        },
        selectIdsC: [],
        selectTextsC: []
      },
      roleInfo: {
        listQuery: {
          page: 1,
          limit: 15,
          key: undefined
        }
      },
      comonInfo: {
        datas: [],
        total: 0,
        selectTexts: [],
        selectIds: [],
        loading: false
      },
      partDatas: [],
      orgsTree: [],
      ruleIndexInfo: {},
      loginKey: '',
      searchKey: ''
    }
  },
  computed: {
    tableData() {
      if (this.loginKey === '{loginUser}') {
        return { ...this.comonInfo, ...this.userInfo }
      }
      return { ...this.comonInfo, ...this.roleInfo }
    },
    propertyData() {
      return this.propertyDatas && this.propertyDatas.concat(this.keys)
    },
    names() {
      let names = ''
      if (this.comonInfo.selectTexts.length > 0 || this.userInfo.selectTextsC.length > 0) {
        names = [...this.comonInfo.selectTexts, ...this.userInfo.selectTextsC].join(',')
      }
      return names
    }
  },
  filters: {
    userStatusFilter(status) {
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
  watch: {
    selectDialog() {
      if (this.selectDialog) {
        const item = this.ruleIndexInfo.item
        const index = this.ruleIndexInfo.index
        this.comonInfo.selectIds = (item.Filters[index].Value && item.Filters[index].Value.split(',')) || []
      }
    }
  },
  mounted() {},
  methods: {
    createKey(key) {
      return `${Math.random()}_${key}`
    },
    handleShowMore(key) {
      const keys = ['{loginUser}', '{loginRole}']
      if (keys.indexOf(key) > -1) {
        return true
      }
      return false
    },
    addGroupRule(item) {
      !item.Children && this.$set(item, 'Children', [])
      item.Children &&
        item.Children.push({
          Operation: 'or',
          Filters: [
            {
              Key: '',
              Value: '',
              Contrast: '',
              Text: ''
            }
          ]
        })
    },
    deleteGroupRule(item) {
      item.Children.splice(this.level, 1)
      item.Children.length <= 0 && delete item['Children']
    },
    // key修改时
    handleChangeKey(item) {
      item.Value = ''
      item.Text = ''
      this.comonInfo.selectTexts = []
      this.comonInfo.selectIds = []
      this.userInfo.selectTextsC = []
      this.userInfo.selectIdsC = []
    },
    addRule(item) {
      item.Filters.push({
        Key: '',
        Value: '',
        Contrast: '',
        Text: ''
      })
    },
    deleteRule(item, index) {
      item.Filters.splice(index, 1)
    },
    // 通过部门获取用户
    handleNodeClick(data) {
      this.userInfo.listQuery.orgId = data.id
      this.userInfo.listQuery.page = 1
      this.groupData()
      this.getUserList()
    },
    // 搜索用户/角色
    handleSearchUser() {
      this.loadData()
    },
    // 获取全部用户
    getAllUsers() {
      this.userInfo.listQuery.orgId = ''
      this.userInfo.listQuery.page = 1
      this.getUserList()
    },
    // 分页查询用户/角色
    handlePageSearch(val) {
      this.loadData(val)
    },
    // 获取用户
    getUserList() {
      this.comonInfo.loading = true
      this.userInfo.listQuery.key = this.searchKey
      users.getList(this.userInfo.listQuery).then((response) => {
        this.comonInfo.datas = response.data
        this.comonInfo.total = response.count
        this.comonInfo.loading = false
        if (this.comonInfo.datas.length > 0) {
          this.userInfo.selectTextsC = [...this.comonInfo.datas].filter((x) => this.comonInfo.selectTexts.indexOf(x.name) > -1).map((item) => item.name)
          this.userInfo.selectIdsC = [...this.comonInfo.datas].filter((x) => this.comonInfo.selectIds.indexOf(x.id) > -1).map((item) => item.id)
          if (this.comonInfo.selectTexts.length > 0) {
            this.comonInfo.selectTexts = this.comonInfo.selectTexts.filter((item) => !this.comonInfo.datas.some((x) => x.name === item))
          }
          if (this.comonInfo.selectIds.length > 0) {
            this.comonInfo.selectIds = this.comonInfo.selectIds.filter((item) => !this.comonInfo.datas.some((x) => x.id === item))
          }
        }
        this.setSelectTable()
      })
    },
    groupData() {
      this.comonInfo.selectTexts = [...this.comonInfo.selectTexts, ...this.userInfo.selectTextsC]
      this.comonInfo.selectIds = [...this.comonInfo.selectIds, ...this.userInfo.selectIdsC]
    },
    // 获取部门信息
    getPartData() {
      login.getOrgs().then((response) => {
        this.partDatas = response.data.map(function(item) {
          return {
            id: item.id,
            label: item.name,
            parentId: item.parentId
          }
        })
        var orgstmp = JSON.parse(JSON.stringify(this.partDatas))
        this.orgsTree = listToTreeSelect(orgstmp)
      })
    },
    // 弹出选择用户对话框
    handleSelectUser(item, index) {
      this.selectDialog = true
      this.loginKey = item.Filters[index].Key
      this.ruleIndexInfo = {
        item: item,
        index: index
      }
      this.loadData()
    },
    handleSelectCurrentName(key, rule) {
      this.selectDialog = false
      rule.Value = key
    },
    // 默认选中
    setSelectTable() {
      const selectIds = this.loginKey === '{loginUser}' ? this.userInfo.selectIdsC : this.comonInfo.selectIds
      this.$nextTick(() => {
        const rows = [...this.comonInfo.datas].filter((x) => [...selectIds].some((y) => y === x.id))
        rows.forEach((row) => {
          this.$refs.multipleTable.toggleRowSelection(row)
        })
      })
    },

    // 加载数据
    loadData(page) {
      this.userInfo.listQuery.page = page || 1
      if (this.loginKey === '{loginUser}') {
        (!this.partDatas || this.partDatas.length <= 0) && this.getPartData()
        this.groupData()
        this.getUserList()
        return
      }
      this.getRoleList()
    },
    // 确认用户选择
    handleSaveUsers() {
      this.loginKey === '{loginUser}' && this.groupData()
      this.selectDialog = false
      this.ruleIndexInfo.item.Filters[this.ruleIndexInfo.index].Text = this.comonInfo.selectTexts && this.comonInfo.selectTexts.join(',')
      this.ruleIndexInfo.item.Filters[this.ruleIndexInfo.index].Value = this.comonInfo.selectIds && this.comonInfo.selectIds.join(',')
    },
    // 选择用户
    handleSelectionUser(val) {
      if (this.loginKey === '{loginUser}') {
        this.userInfo.selectTextsC = val.map((item) => item.name)
        this.userInfo.selectIdsC = val.map((item) => item.id)
        return
      }
      this.comonInfo.selectTexts = val.map((item) => item.name)
      this.comonInfo.selectIds = val.map((item) => item.id)
    },
    // 获取角色
    getRoleList() {
      this.comonInfo.loading = true
      this.roleInfo.listQuery.key = this.searchKey
      roles.getList(this.listQuery).then((response) => {
        this.comonInfo.datas = response.data
        this.comonInfo.loading = false
        this.setSelectTable()
      })
    }
  }
}
</script>
<style></style>
