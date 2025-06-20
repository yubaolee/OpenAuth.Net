﻿<!--
 * @description: 入库订单界面
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-08-25 全部调整为通用组件，代码生成功能基于该页面做为模版
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
      <div class="flex-item">
        <el-card shadow="nerver" class="demo-card fh">
          <auth-table style="height:calc(100% - 52px)" ref="mainTable" :select-type="'radio'"
            :table-fields="firstHeaderList" :data="mainList" :v-loading="listLoading"
            @row-click="rowClickFirstTable"></auth-table>
          <pagination v-show="firstTotal > 0" :total="firstTotal" :page.sync="firstQuery.page"
            :limit.sync="firstQuery.limit" @pagination="handleCurrentChange" />
        </el-card>
      </div>
      <el-row class="flex-item">
        <el-col :span="showTitleDialog ? 12 : 0" class="fh form-card">
          <el-card shadow="nerver" class="demo-card fh">
            <div slot="header">
              <span v-if="radio == ''">头信息</span>
              <span v-else>{{ radio }}头信息</span>
            </div>
            <auth-form ref="dataForm" :edit-model="editModel" :form-fields="firstHeaderList" v-model="firstTemp"
              :col-num="3"></auth-form>
          </el-card>
        </el-col>

        <!-- 第二部分多选 -->
        <el-col :span="!showTitleDialog ? 24 : 12" class="fh detail-card">
          <el-card shadow="nerver" class="demo-card fh" id="secondCard">
            <div slot="header">
              <i class="show-title-button" :class="showTitleDialog ? 'el-icon-d-arrow-left' : 'el-icon-d-arrow-right'"
                :title="showTitleDialog ? '展开' : '收缩'" @click="showTitleDialog = !showTitleDialog"></i>
              <span v-if="radio == ''">订单明细</span>
              <span v-else>{{ radio }}订单明细</span>
              <div class="edit-buttons">
                <el-button v-if="editModel" class="filter-item edit-button" size="mini" v-waves icon="el-icon-plus"
                  @click="onBtnClicked('btnAddDetail')">添加</el-button>
                <el-button v-if="editModel" class="filter-item edit-button delete-button" size="mini" v-waves
                  icon="el-icon-delete" @click="onBtnClicked('btnDelDetail')">删除</el-button>
              </div>
            </div>
            <auth-table style="height:calc(100% - 52px - 34px)" ref="secondTable" border :editModel="editModel"
              :table-fields="secondHeaderList" :data="secondList" @row-click="rowClickSecondTable"
              @selection-change="selChangeSecondTable"></auth-table>
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

    <print-preview ref="preView" />
  </div>
</template>

<script>
import * as wmsInboundOrderTbls from '@/api/wmsinboundordertbls'
import * as wmsInboundOrderDtbls from '@/api/wmsinboundorderdtbls'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import { mapGetters } from 'vuex'
import permissionBtn from '@/components/PermissionBtn'
import Pagination from '@/components/Pagination'
import elDragDialog from '@/directive/el-dragDialog'
import { parseTime, defaultVal } from '@/utils/index'
import AuthForm from '@/components/Base/AuthForm'
import AuthTable from '@/components/Base/AuthTable'
import extend from "@/extensions/common.js"
export default {
  name: 'wmsInboundOrderTbl',
  components: {
    Sticky,
    permissionBtn,
    Pagination,
    AuthForm,
    AuthTable
  },
  directives: {
    waves,
    elDragDialog
  },
  mixins: [extend],
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
        appId: undefined
      },
      mainList: null, // 主列表值
      firstTotal: 0, // 主列表总条数
      listLoading: true, // 主列表记录总数
      tableKey: 0,
      showTitleDialog: true,

      editModel: false, // 是否为编辑模式
      editType: 'edit', // 编辑类型
      dialogStatus: '', // 主修改对话框状态create/update
      selectRow: {},
      firstTemp: {}, // 当前选中的头信息
      // ------------------------明细列表数据-------------------------------------
      secondHeaderList: [], // 明细列表列定义
      secondList: [], // 明细列表值
      secondQuery: {}, // 明细列表的过滤条件，如页码、每页条数，搜索关键字等
      secondTotal: 0, // 明细列表总条数
      multipleSelection: [], // 明细列表checkbox选中的值,

      // ------------------------通用数据项-------------------------------------
      textMap: {
        update: '编辑',
        create: '添加'
      }
    }
  },

  computed: {
    ...mapGetters(['defaultorgid'])
  },
  created() {
    this.getList()
  },
  methods: {
    // ------------------------通用处理函数-------------------------------------
    onBtnClicked: function (domId, args) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd': // 添加新记录
          this.resetFirstTemp()
          this.secondList = []
          this.dialogStatus = 'create'
          this.editModel = true
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
              type: 'error'
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
              type: 'error'
            })
            return
          }
          this.handleFirstDel(this.firstTemp)
          break
        case 'btnPrint':
          if (this.firstTemp.id === '') {
            this.$message({
              message: '请选择要打印的项',
              type: 'error'
            })
            return
          }
          this.printPreview(this.$refs.preView, args, this.firstTemp);
          break
          case 'btnFlowscheme':
          if (this.firstTemp.id === '') {
            this.$message({
              message: '请选择要送审的内容',
              type: 'error'
            })
            return
          }
          this.createFlowInstance(args, this.firstTemp);
          break
        case 'btnAddDetail': // 添加明细行
          this.handleAddOrderDetail()
          break
        case 'btnDelDetail': // 删除明细行
          if (this.multipleSelection.length < 1) {
            this.$message({
              message: '至少删除一个',
              type: 'error'
            })
            return
          }
          this.handleSecondDel(this.multipleSelection)
          break
        case 'btnExport':
          this.$refs.mainTable.exportExcel(`订单${parseTime(new Date())}`, args)
          break
        default:
          break
      }
    },
    // ------------------------主数据列表处理------------------------------------
    getList() {
      this.listLoading = true
      wmsInboundOrderTbls.getList(this.firstQuery).then((response) => {
        response.columnFields.forEach((item) => {
          // 首字母小写
          item.columnName = item.columnName.substring(0, 1).toLowerCase() + item.columnName.substring(1)
        })
        this.firstHeaderList = response.columnFields
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
    },
    createData() {
      // 保存提交
      this.$refs['dataForm'].validate(() => {
        let tempData = Object.assign({}, this.firstTemp)
        tempData = this.setDetails(tempData)
        tempData.OrgId = this.defaultorgid
        wmsInboundOrderTbls.add(tempData).then(() => {
          this.mainList.unshift(this.firstTemp)
          this.editModel = false
          this.$notify({
            title: '成功',
            message: '创建成功',
            type: 'success',
            duration: 2000
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
    setDetails(tempData) {
      // 处理明细
      tempData.wmsInboundOrderDtblReqs = []
      this.secondList.length > 0 &&
        this.secondList.forEach((item) => {
          const obj = {}

          this.secondHeaderList.forEach((header) => {
            obj[header.columnName] = item[header.columnName] || defaultVal(header.entityType)
          })

          tempData.wmsInboundOrderDtblReqs.push(obj)
        })
      return tempData
    },
    updateData() {
      // 更新提交
      this.$refs['dataForm'].validate(() => {
        let tempData = Object.assign({}, this.firstTemp)
        tempData = this.setDetails(tempData)
        wmsInboundOrderTbls.update(tempData).then(() => {
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
            duration: 2000
          })
        })
      })
    },
    handleFirstDel(row) {
      // 删除头
      wmsInboundOrderTbls.del([row.id]).then(() => {
        this.$notify({
          title: '成功',
          message: '删除成功',
          type: 'success',
          duration: 2000
        })
        this.mainList = this.mainList.filter((item) => item.id !== row.id)
        this.resetFirstTemp()
        this.secondList = []
      })
    },

    // ------------------------明细列表处理-------------------------------------
    handleSecondPage(e) {
      this.secondQuery = e
      this.querySecondList(this.radio)
    },
    querySecondList(id) {
      wmsInboundOrderDtbls
        .getList({
          inboundorderid: id,
          page: this.secondQuery.page,
          limit: this.secondQuery.limit,
          key: this.secondQuery.customerKey
        })
        .then((res) => {
          res.columnFields.forEach((item) => {
            // 首字母小写
            item.columnName = item.columnName.substring(0, 1).toLowerCase() + item.columnName.substring(1)
          })
          this.secondHeaderList = res.columnFields
          this.secondTotal = res.count
          this.secondList = res.data
        })
    },
    rowClickSecondTable(row) {
      // 行点击事件
      this.$refs.secondTable.clearSelection()
      this.$refs.secondTable.toggleRowSelection(row)
    },
    handleSecondDel(rows) {
      // 删除明细时,只删除前端
      rows.forEach((row) => {
        this.secondList = this.secondList.filter((item) => item.id !== row.id)
      })
    },
    selChangeSecondTable(val) {
      // 明细选中事件
      this.multipleSelection = val
    },
    handleAddOrderDetail() {
      // 添加明细
      const obj = {}
      this.secondHeaderList.forEach((header) => {
        obj[header.columnName] = defaultVal(header.entityType)
      })
      obj.orderId = this.firstTemp.id

      this.secondList.push(Object.assign({}, obj))
    }
  }
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
}</style>
