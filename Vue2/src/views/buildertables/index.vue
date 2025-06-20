<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:30
 * @LastEditTime: 2025-06-20 20:59:32
 * @Description: 2021-08-24   采用通用的列表和表单组件改造
 *               2021-09-14   保持和订单界面一致
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" style="width: 200px;" class="filter-item"
          :placeholder="'名称'" v-model="firstQuery.key"> </el-input>
        <el-button class="filter-item" size="mini" v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>
        <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
      </div>
    </sticky>
    <div class="app-container flex-item flex-column">
      <div class="flex-item" v-show="showNotFullScreen">
        <el-card shadow="nerver" class="demo-card fh">
          <auth-table style="height:calc(100% - 52px)" ref="mainTable" :select-type="'radio'"
            :table-fields="firstHeaderList" :data="mainList" :v-loading="listLoading"
            @row-click="rowClickFirstTable"></auth-table>
          <pagination v-show="firstTotal > 0" :total="firstTotal" :page.sync="firstQuery.page"
            :limit.sync="firstQuery.limit" @pagination="handleCurrentChange" />
        </el-card>
      </div>
      <el-row class="flex-item">
        <el-col :span="showNotFullScreen ? 12 : 0" class="fh form-card">
          <el-card shadow="nerver" class="demo-card fh">
            <div slot="header">
              <span v-if="radio == ''">表信息</span>
              <span v-else>{{ tableName }}表信息</span>
            </div>
            <auth-form ref="dataForm" :rules="mainRules" :edit-model="editModel" :form-fields="firstHeaderList"
              v-model="firstTemp" :col-num="3"></auth-form>
          </el-card>
        </el-col>

        <!-- 第二部分多选 -->
        <el-col :span="!showNotFullScreen ? 24 : 12" class="fh detail-card">
          <el-card shadow="nerver" class="demo-card fh" id="secondCard">
            <div slot="header">
              <span v-if="radio == ''">表字段信息（修改后，编辑框内回车生效）</span>
              <span v-else>{{ tableName }}表字段信息（修改后，编辑框内回车生效）</span>
              <div class="edit-buttons">
                <el-button class="filter-item edit-button" size="mini" v-waves icon="el-icon-refresh"
                  @click="onBtnClicked('btnSync')">同步结构</el-button>
                <el-button v-if="editModel" class="filter-item edit-button delete-button" size="mini" v-waves
                  icon="el-icon-delete" @click="onBtnClicked('btnDelDetail')">删除</el-button>
                <el-button :icon="showNotFullScreen ? 'el-icon-full-screen' : 'el-icon-aim'" plain
                  @click="showNotFullScreen = !showNotFullScreen" size="mini">{{ showNotFullScreen ? '全屏' : '退出全屏'
                  }}</el-button>
              </div>
            </div>
            <auth-table style="height:calc(100% - 52px - 34px)" ref="secondTable" border :editModel="editModel"
              :table-fields="secondHeaderList" :data="secondList" @row-click="rowClickSecondTable"
              @selection-change="selChangeSecondTable" @item-change="handleUpdateDetail"></auth-table>
            <pagination v-show="secondTotal > 0" :total="secondTotal" :page.sync="secondQuery.page"
              :limit.sync="secondQuery.limit" @pagination="handleSecondPage" />
          </el-card>
        </el-col>
      </el-row>
      <el-card shadow="nerver" v-if="editModel" style="text-align: right;padding-bottom: 10px;">
        <el-row>
          <el-col :span="24"><el-button size="mini" @click="editModel = false">取消</el-button>
            <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
            <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button></el-col>
        </el-row>
      </el-card>
    </div>
  </div>
</template>

<script>
import * as builderTables from '@/api/builderTables'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import ColumnDefine from '@/interface/columnDefine'
import { mapGetters } from 'vuex'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import { parseTime, defaultVal } from '@/utils/index'
import AuthForm from '@/components/Base/AuthForm'
import AuthTable from '@/components/Base/AuthTable'
import { typeLists } from '@/utils/const.js'
export default {
  name: 'builderTable',
  components: {
    Sticky,
    permissionBtn,
    Pagination,
    AuthForm,
    AuthTable,
  },
  directives: {
    waves,
    elDragDialog,
  },

  data() {
    return {
      // ------------------------主列表数据（头）-----------------------------
      firstHeaderList: [], // 主列表列定义
      radio: '', // 主列表选中项
      firstQuery: {
        // 主列表查询条件
        page: 1,
        limit: 20,
        key: undefined,
        appId: undefined,
      },
      tableName: '',
      mainList: null, // 主列表值
      firstTotal: 0, // 主列表总条数
      listLoading: true, // 主列表记录总数
      tableKey: 0,
      showNotFullScreen: true,

      editModel: false, // 是否为编辑模式
      editType: 'edit', // 编辑类型
      dialogStatus: '', // 主修改对话框状态create/update
      selectRow: {},
      firstTemp: {}, // 当前选中的头信息
      mainRules: {
        tableName: [
          {
            required: true,
            message: '请输入表名',
            trigger: 'change',
          },
        ],
        namespace: [
          {
            required: true,
          },
        ],
        moduleCode: [
          {
            required: true,
            message: '请输入模块标识',
            trigger: 'change',
          },
        ],
        moduleName: [
          {
            required: true,
            message: '请输入模块名称',
            trigger: 'change',
          },
        ],
      },
      // ------------------------明细列表数据-------------------------------------
      secondHeaderList: [], // 明细列表列定义
      secondList: [], // 明细列表值
      secondQuery: {}, // 明细列表的过滤条件，如页码、每页条数，搜索关键字等
      secondTotal: 0, // 明细列表总条数
      multipleSelection: [], // 明细列表checkbox选中的值,

      // ------------------------通用数据项-------------------------------------
      textMap: {
        update: '编辑',
        create: '添加',
      },
    }
  },

  computed: {
    ...mapGetters(['defaultorgid']),
  },
  created() {
    this.getList()
  },
  mounted() {
    this.initCfg()
  },
  methods: {
    initCfg() {
      this.firstHeaderList = [
        new ColumnDefine('id', 'id', false, false, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('tableName', '表名', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('moduleName', '模块名称', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('parentTableId', '父表', true, true, 'selectDynamic', '/BuilderTables/AllMain', 'string', 'varchar', ''),
        new ColumnDefine('externalDataSourceId', '外部数据源', true, false, 'selectDynamic', '/externalDataSources/Load', 'string', 'varchar', ''),
        new ColumnDefine('foreignKey', '外键', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('isDynamicHeader', '动态头部', true, true, 'switch', '', 'bool', 'tinyint', ''),
        new ColumnDefine('className', '实体类名称', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('namespace', '命名空间', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('moduleCode', '模块编码', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('folder', 'vue目录', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('remark', '描述', true, true, 'textarea', '', 'string', 'varchar', ''),
      ]

      this.secondHeaderList = [
        new ColumnDefine('columnName', '字段名', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('remark', '描述', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('editType', '编辑类型', true, true, 'select', typeLists, 'string', 'varchar', ''),
        new ColumnDefine('entityType', '实体类型', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('columnType', '字段类型', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('dataSource', '数据来源', true, true, 'selectDynamic', '/CategoryTypes/Load', 'string', 'varchar', ''),
        new ColumnDefine('isList', '可显示', true, true, 'switch', '', 'bool', 'tinyint', ''),
        new ColumnDefine('isEdit', '可编辑', true, true, 'switch', '', 'bool', 'tinyint', ''),
        new ColumnDefine('sort', '排序', true, true, 'number', '', 'string', 'varchar', ''),
      ]
    },
    // ------------------------通用处理函数-------------------------------------
    onBtnClicked: function (domId, callback) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd': // 添加新记录
          this.resetFirstTemp()
          this.secondList = []
          this.dialogStatus = 'create'
          this.editModel = true
          this.tableName = '新建'
          this.editType = 'add'
          this.$nextTick(() => {
            this.$refs['dataForm'].clearValidate()
          })
          break
        case 'btnEdit': // 编辑头
          this.firstTemp = Object.assign({}, this.selectRow)
          if (this.firstTemp.id === '') {
            this.editModel = false
            this.$message({
              message: '请选择要修改的项',
              type: 'error',
            })
            return
          }
          this.dialogStatus = 'update'
          this.editModel = true
          this.editType = 'edit'
          this.$nextTick(() => {
            this.$refs['dataForm'].clearValidate()
          })
          break
        case 'btnDel': // 删除主表
          if (this.firstTemp.id === '') {
            this.$message({
              message: '请选择要删除的项',
              type: 'error',
            })
            return
          }
          this.handleFirstDel(this.firstTemp)
          break
        case 'btnCreateEntity': // 创建实体
          this.handleCreateEntity()
          break
        case 'btnCreateBusiness': // 创建业务逻辑
          this.handleCreateBusiness()
          break
        case 'btnCreateVue': // 创建vue界面
          this.handleCreateVue()
          break
        case 'btnUpdateDetail': // 同步表数据结构
          this.handleUpdateDetail()
          break
        case 'btnDelDetail': // 删除明细行
          if (this.multipleSelection.length < 1) {
            this.$message({
              message: '至少删除一个',
              type: 'error',
            })
            return
          }
          this.handleSecondDel(this.multipleSelection)
          break
        case 'btnSync': // 同步表数据结构
          this.handleSync()
          break
        case 'btnExport':
          this.$refs.mainTable.exportExcel(`表结构${parseTime(new Date())}`, callback)
          break
        default:
          break
      }
    },
    // 创建实体
    handleCreateEntity() {
      builderTables
        .CreateEntity({
          id: this.firstTemp.id,
        })
        .then(() => {
          this.$message.success('创建成功')
        })
    },
    // 创建业务逻辑
    handleCreateBusiness() {
      builderTables
        .CreateBusiness({
          id: this.firstTemp.id,
        })
        .then(() => {
          this.$message.success('创建成功')
        })
    },
    // 创建vue界面
    handleCreateVue() {
      if (this.firstTemp.folder == undefined || this.firstTemp.folder == '') {
        this.$message.error('Vue根目录不能为空')
        return
      }
      builderTables
        .CreateVue({
          id: this.firstTemp.id,
          vueProjRootPath: this.firstTemp.folder,
        })
        .then(() => {
          this.$message.success('创建成功')
        })
    },
    // ------------------------主数据列表处理------------------------------------
    getList() {
      this.listLoading = true
      builderTables.getList(this.firstQuery).then((response) => {
        this.mainList = response.data
        this.firstTotal = response.count

        if (this.firstTotal > 0) {
          this.rowClickFirstTable(this.mainList[0])
        }

        this.listLoading = false
      })
    },
    rowClickFirstTable(row) {
      // 点击行
      this.radio = row.id
      this.tableName = row.tableName
      this.secondQuery.page = 1
      this.secondQuery.limit = 10
      this.querySecondList(this.radio)
      this.showTitleDetail(row)
    },
    handleFilter() {
      this.firstQuery.page = 1
      this.getList()
    },
    handleSizeChange(val) {
      this.firstQuery.limit = val
      this.getList()
    },
    handleCurrentChange(val) {
      this.firstQuery.page = val.page
      this.firstQuery.limit = val.limit
      this.getList()
    },
    resetFirstTemp() {
      this.firstHeaderList.forEach((item) => {
        this.firstTemp[item.columnName] = defaultVal(item.entityType)
      })
      this.firstTemp.namespace = 'OpenAuth.Repository.Domain'
    },
    createData() {
      // 保存提交
      this.$refs['dataForm'].validate(() => {
        let tempData = Object.assign({}, this.firstTemp)
        tempData.OrgId = this.defaultorgid
        builderTables.add(tempData).then((resp) => {
          this.firstTemp.id = resp.data
          this.mainList.unshift(this.firstTemp)
          this.editModel = false
          this.rowClickFirstTable(this.firstTemp)
          this.$notify({
            title: '成功',
            message: '创建成功',
            type: 'success',
            duration: 2000,
          })
        })
      })
    },
    showTitleDetail(row) {
      // 弹出编辑框
      this.selectRow = Object.assign({}, row) // 新增订单时保存当前选中行
      this.firstTemp = Object.assign({}, row) // copy obj
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },

    updateData() {
      // 更新提交
      this.$refs['dataForm'].validate(() => {
        let tempData = Object.assign({}, this.firstTemp)
        builderTables.update(tempData).then(() => {
          for (const v of this.mainList) {
            if (v.id === this.firstTemp.id) {
              const index = this.mainList.indexOf(v)
              this.mainList.splice(index, 1, this.firstTemp)
              break
            }
          }

          this.editModel = false
          this.$notify({
            title: '成功',
            message: '更新成功',
            type: 'success',
            duration: 2000,
          })
        })
      })
    },
    handleFirstDel(row) {
      // 删除头
      builderTables.del([row.id]).then(() => {
        this.$notify({
          title: '成功',
          message: '删除成功',
          type: 'success',
          duration: 2000,
        })
        this.mainList = this.mainList.filter((item) => item.id !== row.id)
        if (this.mainList.length > 0) {
          this.$nextTick(() => {
            this.rowClickFirstTable(this.mainList[0])
          })
          return
        }
        this.secondList = []
        this.showTitleDetail({})
      })
    },

    // ------------------------明细列表处理-------------------------------------
    handleSecondPage(e) {
      this.secondQuery = e
      this.querySecondList(this.radio)
    },
    querySecondList(id) {
      builderTables
        .getDetailList({
          BuilderTableId: id,
          page: this.secondQuery.page,
          limit: this.secondQuery.limit,
          key: this.secondQuery.customerKey,
        })
        .then((res) => {
          this.secondTotal = res.count
          this.secondList = res.data.sort((a, b) => {
            if (a.isList == b.isList) return a.sort - b.sort //先把显示在列表的按排序号排序
            if (b.isList > a.isList) return 1  //再按是否在列表显示整体排序                      
            return -1
          })
        })
    },
    rowClickSecondTable(row) {
      // 行点击事件
      this.$refs.secondTable.clearSelection()
      this.$refs.secondTable.toggleRowSelection(row)
    },
    handleSecondDel(rows) {
      builderTables.delDetail(rows.map((item) => item.id)).then(() => {
        rows.forEach((row) => {
          this.secondList = this.secondList.filter((item) => item.id !== row.id)
        })
        this.$notify({
          title: '成功',
          message: '删除成功',
          type: 'success',
          duration: 2000,
        })
      })
    },
    handleSync() {
      //同步数据结构
      builderTables.sync({ tableName: this.tableName, id: this.radio }).then(() => {
        this.querySecondList(this.radio)

        this.$notify({
          title: '成功',
          message: '同步成功',
          type: 'success',
          duration: 2000,
        })
      })
    },
    selChangeSecondTable(val) {
      // 明细选中事件
      this.multipleSelection = val
    },
    handleUpdateDetail(item) {
      // 同步表数据结构
      builderTables.updateDetail(item).then(() => {
        this.$notify({
          title: '成功',
          message: '更新成功',
          type: 'success',
          duration: 2000,
        })
      })
    },
  },
}
</script>
<style lang="scss">
.nomal-form label {
  font-weight: 500 !important;
}

.demo-card .el-card__header {
  padding: 10px !important;
  line-height: 1;
  position: relative;
}

.el-card__body {
  padding: 10px 10px 0 10px !important;
  height: 100%;
}

.form-card .el-card__body {
  padding-right: 0 !important;
}

.form-card .el-form {
  padding-right: 5px;
}

.dialog-small .el-dialog__header {
  padding: 10px;
  border-bottom: 1px solid #efefef;
}

.dialog-small .el-dialog__headerbtn {
  top: 15px;
}

.dialog-small .el-dialog__body {
  padding: 10px;
}

.el-form-item__error {
  padding-top: 0;
}

.edit-buttons {
  position: absolute !important;
  top: 2px;
  right: 10px;
}
</style>
