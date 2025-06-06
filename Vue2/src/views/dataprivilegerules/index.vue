<!--
 * @description: 资源管理，用于为三方站点提供资源授权服务
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-09-23 使用通用组件改造
-->

<template>
  <div class="data-rule-wrap flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" style="width: 200px;" class="filter-item" :placeholder="'名称'" v-model="listQuery.key"> </el-input>

        <el-button class="filter-item" size="mini" v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <div class="bg-white" style="height: 100%;">
        <auth-table style="height:calc(100% - 60px)" ref="mainTable" :select-type="'checkbox'" :table-fields="headerList" :templates="['privilegeRules']" :data="list" :v-loading="listLoading" @row-click="rowClick" @selection-change="handleSelectionChange"></auth-table>
        <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="handleCurrentChange" />
      </div>

      <el-dialog v-el-drag-dialog :destroy-on-close="true" class="dialog-mini rule-form-dialog" width="850px" :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible">
        <el-form :rules="rules" ref="dataForm" :model="temp" label-position="right" label-width="100px">
          <el-row>
            <el-col :span="12">
              <el-form-item label-width="60px" size="small" :label="'数据ID'" prop="id">
                <el-input v-model="temp.id" :disabled="true" placeholder="系统自动处理"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label-width="150px" size="small" :label="'资源标识（模块编号）'" prop="sourceCode">
                <el-select class="sellect-operation" size="mini" v-model="temp.sourceCode" @change="handleSourceCode">
                  <el-option v-for="item in sourceModules" :key="item.code" :label="item.name" :value="item.code"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>

          <add-rule v-if="temp.sourceCode" :dataSource="temp.privilegeRules" :propertyDatas="propertyDatas" ref="addRule"></add-rule>
          <el-row>
            <el-col :span="6">
              <el-form-item label-width="60px" size="small" :label="'排序号'">
                <el-input-number v-model="temp.sortNo" :min="0" :max="10"></el-input-number>
              </el-form-item>
            </el-col>
            <el-col :span="4">
              <el-form-item size="small" :label="'是否可用'" prop="enable">
                <el-switch v-model="temp.enable"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span="14">
              <el-form-item size="small" :label="'权限描述'" prop="description">
                <el-input v-model="temp.description"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item hidden size="small" :label="'权限规则'" prop="privilegeRules">
            <el-input v-model="temp.privilegeRules" readonly style="padding-right: 26px;"></el-input>
            <span style="position: absolute;right: 0;top:0;bottom:0;display:inline-block;background: #fff;border: 1px solid #DCDFE6;padding: 0 10px;border-radius: 0 4px 4px 0;cursor:pointer;" @click="dialogRuleVisible = true"><i class="el-icon-more"></i></span>
          </el-form-item>
        </el-form>
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
import * as dataPrivilegeRules from '@/api/dataprivilegerules'
import * as apiModules from '@/api/modules'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import addRule from './addRule'
import { mapGetters, mapActions } from 'vuex'
import extend from '@/extensions/common.js'
import AuthTable from '../../components/Base/AuthTable.vue'
import { defaultVal } from '@/utils/index'
import Vue from 'vue'
export default {
  name: 'dataPrivilegeRule',
  components: {
    Sticky,
    permissionBtn,
    Pagination,
    addRule,
    AuthTable
  },
  mixins: [extend],
  directives: {
    waves,
    elDragDialog
  },
  data() {
    return {
      // requestRules: {},
      propertyDatas: [],
      multipleSelection: [], // 列表c eckbox选中的值
      tableKey: 0,
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        // 查询条件
        page: 1,
        limit: 20,
        key: undefined,
        appId: undefined
      },
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
      temp: {  },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '编辑',
        create: '添加'
      },
      // dialogPvVisible: false,
      pvData: [],
      rules: {
        appId: [
          {
            required: true,
            message: '必须选择一个应用',
            trigger: 'change'
          }
        ],
        name: [
          {
            required: true,
            message: '名称不能为空',
            trigger: 'blur'
          }
        ]
      },
      downloadLoading: false,
      headerList: []
      // dialogRuleVisible: false
    }
  },
  computed: {
    ...mapGetters({
      modules: 'checkModules'
    }),
    sourceModules() {
      if (this.modules.length <= 0) return
      return this.modules.filter((item) => item.code)
    }
  },
  created() {
    this.getList()
  },
  methods: {
    ...mapActions({
      GetModules: 'getCheckModules'
    }),
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    onBtnClicked: function(domId) {
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
        default:
          break
      }
    },
    getList() {
      let _this = this
      // 权限规则使用自定义的模版
      Vue.component('privilegeRules', {
        props: ['row'],
        methods: {
          itemClick(row) {
            _this.handleUpdate(row)
          }
        },
        template: `<span class="ruleSpan ellipsis"  @click.stop='itemClick(row)'>{{row['privilegeRules']}}</span>`
      })

      this.listLoading = true
      dataPrivilegeRules.getList(this.listQuery).then((response) => {
        response.columnFields.forEach((item) => {
          // 首字母小写
          item.columnName = item.columnName.substring(0, 1).toLowerCase() + item.columnName.substring(1)
        })
        this.headerList = response.columnFields

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
    handleModifyStatus(row, disable) {
      // 模拟修改状态
      this.$message({
        message: '操作成功',
        type: 'success'
      })
      row.disable = disable
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
      this.modules.length <= 0 && this.GetModules()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() {
      // 保存提交
      this.temp.privilegeRules = (this.temp.sourceCode && JSON.stringify(this.$refs.addRule.saveRule())) || ''
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          dataPrivilegeRules.add(this.temp).then(() => {
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
    handleUpdate(row) {
      // 弹出编辑框
      this.temp = Object.assign({}, row) // copy obj
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.modules.length <= 0 && this.GetModules()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
      this.loadProperties()
    },
    loadProperties() {
      this.temp.sourceCode &&
        apiModules
          .getProperties(this.temp.sourceCode)
          .then((res) => {
            this.propertyDatas = res.result
          })
          .catch(() => {
            this.propertyDatas = []
          })
    },
    updateData() {
      // 更新提交
      this.temp.privilegeRules = JSON.stringify(this.$refs.addRule.saveRule())
      this.temp.updateTime = '刚刚'
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.temp)
          dataPrivilegeRules.update(tempData).then(() => {
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
    handleDelete(rows) {
      // 多行删除
      this.delrows(dataPrivilegeRules, rows)
    },
    handleSourceCode() {
      this.loadProperties()
      this.temp.privilegeRules = ''
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.dialog-mini .el-select {
  width: 100%;
}
.data-rule-wrap {
  .ruleSpan {
    cursor: pointer;
    color: #409eff;
  }
  .custom-dialog {
    .el-dialog {
      height: 70%;
      .el-dialog__body {
        height: calc(100% - 35px - 40px);
      }
    }
  }
  .custom-card {
    height: 100%;
    .el-card__body {
      height: calc(100% - 34px);
      overflow: auto;
    }
  }
  .flex-item {
    overflow: hidden;
  }
}
.part-box {
  width: 200px;
  border: 1px solid #e4e4e4;
}
.table-box {
  border: 1px solid #e4e4e4;
  border-left: 0;
}
.rule-group-box {
  border-radius: 5px;
  overflow: hidden;
  margin-bottom: 10px;
  .rule-groups {
    .rule-head {
      padding: 5px 10px;
      background: #e4e4e4;
      .sellect-operation {
        width: 120px;
      }
    }
    .rule-form {
      padding-bottom: 0;
      border: 1px solid #e4e4e4;
      border-radius: 0 0 0 5px;
      border-top: 0;
      padding-left: 10px;
      padding-right: 10px;
      .el-form {
        padding-top: 0;
      }
    }
  }
  .add-rule-group {
    text-align: center;
    border: 1px solid #e4e4e4;
    border-radius: 0px 5px 5px 0;
    font-size: 60px;
    font-weight: bold;
    padding: 0 30px;
    border-left: 0;
    cursor: pointer;
    color: #999999;
    i:hover {
      color: #4a4b4b;
    }
  }
}
</style>
