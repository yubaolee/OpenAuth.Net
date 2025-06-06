<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2023-09-16 11:32:50
 * @LastEditTime: 2024-05-12 14:08:15
 * @Description: 打印模板设计
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input size="mini" style="margin:0 10px; width: 200px;" :placeholder="'打印方案名称'" v-model="name"> </el-input>
        <!-- 纸张设置 -->
        <el-button-group style="margin:0 10px">
          <el-button size="mini" v-for="(value, type) in paperTypes" :type="curPaperType() === type ? 'primary' : ' '"
            @click="setPaper(value)" :key="type">
            {{ type }}
          </el-button>
        </el-button-group>
        <el-input-number size="mini" style="margin:0 10px" :value="scaleValue" :precision="2" :step="0.1" :min="scaleMin"
          :max="scaleMax" @change="changeScale"></el-input-number>
        <el-popover placement="bottom" width="300" title="设置纸张宽高(mm)" v-model="paperPopVisible">
          <div style="display: flex;align-items: center;justify-content: space-between;margin-bottom: 10px">
            <el-input type="number" v-model="curPaper.width" style=" width: 100px; text-align: center"
              place="宽（mm）"></el-input>~
            <el-input type="number" v-model="curPaper.height" style=" width: 100px; text-align: center"
              place="高（mm）"></el-input>
          </div>
          <div>
            <el-button type="primary" style="width: 100%" @click="otherPaper" size="mini">确定</el-button>
          </div>
          <el-button size="mini" slot="reference" type="primary" style="margin:0 10px">自定义宽高</el-button>
        </el-popover>
        <!-- 预览/打印 -->
        <el-button-group>
          <el-button size="mini" type="primary" icon="el-icon-view" @click="setSqlDialogShow = true">
            设置数据源
          </el-button>
        </el-button-group>
        <!-- 预览/打印 -->
        <el-button-group>
          <el-button size="mini" type="primary" icon="el-icon-view" @click="btnPreview">
            预览
          </el-button>
          <el-button size="mini" type="primary" icon="el-icon-printer" @click="print">
            直接打印
          </el-button>
          <el-button size="mini" type="primary" icon="el-icon-s-management" @click="save">
            保存
          </el-button>
          <el-button size="mini" type="danger" icon="el-icon-delete" @click="clearPaper">
            清空
          </el-button>
        </el-button-group>
        <!-- 保存/清空 -->
      </div>
    </sticky>
    <div class="flex-item flex-row" style="padding: 10px;">
      <div style="width: 250px;padding: 0 20px;background: #ffffff;overflow-y:auto;">
        <el-row>
          <el-col :span="24">
            <el-select v-model="columnView" size="small" clearable allow-create default-first-option filterable
              placeholder="请选择或录入一个视图/表">
              <el-option v-for="item in tableList" :key="item.name" :label="item.description?item.name + item.description.substring(0, 15): item.name"
                :value="item.name">
              </el-option>
            </el-select>
          </el-col>
        </el-row>
        <div class="rect-printElement-types hiprintEpContainer" id="hiprintEpContainer"></div>
      </div>
      <div class="flex-item"
        style="padding: 30px 20px;background: #ffffff;overflow-y:auto; border-right: 5px solid #f5f5f5; border-left: 5px solid #f5f5f5;">
        <div id="hiprint-printTemplate" class="hiprint-printTemplate"></div>
      </div>
      <div style="width: 350px;padding: 0 20px;background: #ffffff;overflow-y:auto;">
        <div id="PrintElementOptionSetting"></div>
      </div>
    </div>
    <!-- 预览 -->
    <print-preview ref="preView" />
    <!-- 设置数据源 -->
    <el-dialog v-el-drag-dialog :destroy-on-close="true" class="dialog-mini custom-dialog user-dialog" width="600px"
      title="设置数据源" :visible.sync="setSqlDialogShow">
      <el-row>
        <el-col :span="12">
          <el-form ref="categoryTypeForm" label-width="80px">
            <el-form-item prop="id" label="数据源">
              <el-input size="small" v-model="sourceSql" type="textarea" :autosize="{ minRows: 4 }"></el-input>
            </el-form-item>
            <el-form-item :label="item" v-for="(item, key) in inParamColumns" :key="key">
              <el-input size="small" v-model="inParam[item]"></el-input>
            </el-form-item>
            <el-form-item prop="name" label="分组字段">
              <el-input size="small" v-model="groupBy"></el-input>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <json-viewer :value="testSqlResult"></json-viewer>
        </el-col>
      </el-row>
      <div style="text-align:right;margin-top: 10px;">
        <el-button size="small" type="primary" @click="testSql">测试数据源</el-button>
        <el-button size="small" type="cancel" @click="setSqlDialogShow = false">关闭</el-button>
      </div>
    </el-dialog>
    <!-- 预览设置参数 -->
    <el-dialog v-el-drag-dialog :destroy-on-close="true" class="dialog-mini custom-dialog user-dialog" title="预览参数"
      :visible.sync="previewParamDlg">
      <el-form label-width="80px">
        <el-form-item prop="id" label="数据源">
          <el-input size="small" v-model="sourceSql" type="textarea" :autosize="{ minRows: 4 }"></el-input>
        </el-form-item>
        <el-form-item :label="item" v-for="(item, key) in inParamColumns" :key="key">
          <el-input size="small" v-model="inParam[item]"></el-input>
        </el-form-item>
      </el-form>
      <div style="text-align:right;margin-top: 10px;">
        <el-button size="small" type="primary" @click="showPreviewDlg">确定</el-button>
        <el-button size="small" type="cancel" @click="previewParamDlg = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import * as sysPrinterPlans from '@/api/sysPrinterPlans'
// import vueJsonEditor from 'vue-json-editor'
import JsonViewer from 'vue-json-viewer'
import 'vue-json-viewer/style.css'
import printPreview from './preview'
import Sticky from '@/components/Sticky'
import { MessageBox } from 'element-ui'
import { hiprint } from 'vue-plugin-hiprint'
import { groupBy } from '@/utils/index'
import elDragDialog from '@/directive/el-dragDialog'
let hiprintTemplate;
export default {
  name: "printCustom",
  components: {
    printPreview,
    JsonViewer,
    Sticky
  },
  directives: {
    elDragDialog
  },
  data() {
    return {
      paperPopVisible: false,
      setSqlDialogShow: false, //设置数据源对话框
      previewParamDlg: false, //预览时是否显示设置参数对话框
      sourceSql: '',//数据源
      inParam: {}, //入口参数，用于测试数据源和预览打印使用
      groupBy: '', //分组字段，用于形成主从表结构
      columnView: '', //打印方案的中文视图/表名
      tableList: [],  //所有的表
      columnList: [], //当前选中表的所有字段列表
      testSqlResult: {},  //测试数据源结果
      id: '',
      name: '', //打印方案名称
      // 当前纸张
      curPaper: {
        type: 'other',
        width: 210,
        height: 100
      },
      // 纸张类型
      paperTypes: {
        'A3': {
          width: 420,
          height: 296.6
        },
        'A4': {
          width: 210,
          height: 296.6
        },
        'A5': {
          width: 210,
          height: 147.6
        },
        'B3': {
          width: 500,
          height: 352.6
        },
        'B4': {
          width: 250,
          height: 352.6
        },
        'B5': {
          width: 250,
          height: 175.6
        }
      },
      scaleValue: 1,
      scaleMax: 5,
      scaleMin: 0.5,
    }
  },
  computed: {
    inParamColumns() {
      return this.inParam && Object.keys(this.inParam) || []
    }
  },
  watch: {
    sourceSql(newSql, oldSql) { //监听sql变化，自动生成入口参数
      if (!newSql.includes('@')) {
        this.inParam = {};
        return;
      }
      if (newSql == oldSql) {
        return;
      }
      let matchs = newSql.match(/@\w*/g); //正则表达匹配@
      let obj = {};
      matchs.forEach(s => {
        if (s.length <= 1) return true;
        obj[s.slice(1)] = '';
      });
      this.inParam = obj;
    },
    columnView(newColView, oldColView) { //监听中文视图变化
      if (newColView == oldColView) {
        return;
      }
      if (newColView == '') {
        return;
      }
      sysPrinterPlans
        .getColumns({
          tableViewName: newColView,
        })
        .then((response) => {
          this.columnList = response.result;
          this.initPrint();
        });
    }
  },
  mounted() {
    sysPrinterPlans
      .getTables()
      .then((response) => {
        this.tableList = response.result;
      });
    this.initPrint();
    this.id = this.$route.params && this.$route.params.id
    if (this.id && this.id != '') {
      sysPrinterPlans
        .get({
          id: this.id,
        })
        .then((response) => {
          this.name = response.result.name;
          this.columnView = response.result.columnView;
          this.sourceSql = response.result.sourceSql
          this.groupBy = response.result.groupBy
          let template = JSON.parse(response.result.planContent)
          hiprintTemplate = new hiprint.PrintTemplate({
            template: template,
            settingContainer: '#PrintElementOptionSetting',
            paginationContainer: '.hiprint-printPagination'
          });
          hiprintTemplate.design('#hiprint-printTemplate');
          // 获取当前放大比例, 当zoom时传true 才会有
          this.scaleValue = hiprintTemplate.editingPanel.scale || 1;
          this.setPaper({ width: template.panels[0].width, height: template.panels[0].height })
        })
    } else {
      hiprintTemplate = new hiprint.PrintTemplate({
        template: {},
        settingContainer: '#PrintElementOptionSetting',
        paginationContainer: '.hiprint-printPagination'
      });
      hiprintTemplate.design('#hiprint-printTemplate');
      // 获取当前放大比例, 当zoom时传true 才会有
      this.scaleValue = hiprintTemplate.editingPanel.scale || 1;
      this.setPaper()
    }
  },
  methods: {
    initPrint() { //初始化打印设计器
      let _this = this;
      document.getElementById("hiprintEpContainer").innerHTML = "";
      var addElementTypes = function (context) {
        context.removePrintElementTypes("providerModule");
        let columns = []; //业务字段;
        let tableFields = [];  //表格字段
        let tableColumns = []; //表格列属性定义
        _this.columnList.forEach(e => {
          var columnDescription = e.columnDescription? e.columnDescription.substring(0, 10) : e.dbColumnName;
          columns.push({
            tid: 'providerModule.' + e.dbColumnName, title: columnDescription, data: columnDescription, type: 'text',
            options: {
              field: e.dbColumnName,
              testData: columnDescription,
              height: 16,
              fontSize: 15,
              textAlign: "center",
              hideTitle: true
            }
          });
          tableFields.push({ text: columnDescription, field: e.dbColumnName });
          tableColumns.push({ title: columnDescription, align: 'center', field: e.dbColumnName, width: 80 });

        });
        context.addPrintElementTypes(
          "providerModule",
          [
            new hiprint.PrintElementTypeGroup("表格/其他", [
              {
                tid: 'providerModule.table', title: '数据表格',
                type: 'table',
                options: {
                  field: 'details',
                  tableHeaderRepeat: 'first',
                  tableFooterRepeat: 'last',
                  fields: tableFields
                },
                editable: true,
                columnDisplayEditable: true,//列显示是否能编辑
                columnDisplayIndexEditable: true,//列顺序显示是否能编辑
                columnTitleEditable: true,//列标题是否能编辑
                columnResizable: true, //列宽是否能调整
                columnAlignEditable: true,//列对齐是否调整
                isEnableEditField: true, //编辑字段
                isEnableContextMenu: true, //开启右键菜单 默认true
                isEnableInsertRow: true, //插入行
                isEnableDeleteRow: true, //删除行
                isEnableInsertColumn: true, //插入列
                isEnableDeleteColumn: true, //删除列
                isEnableMergeCell: true, //合并单元格
                columns: [
                  tableColumns
                ]
              },
              { tid: 'providerModule.customText', title: '文本', customText: '自定义文本', custom: true, type: 'text' },
              {
                tid: 'providerModule.longText', title: '长文本', type: 'longText', options: {
                  field: 'test.longText',
                  width: 200,
                  testData: '长文本分页/不分页测试'
                },
              },
            ]),
            new hiprint.PrintElementTypeGroup("基础图形", [
              {
                tid: 'providerModule.qrcode', title: '二维码', data: 'XS888888888', type: 'text',
                options: {
                  testData: 'XS888888888',
                  height: 32,
                  fontSize: 12,
                  lineHeight: 18,
                  fontWeight: "700",
                  textAlign: "left",
                  textContentVerticalAlign: "middle",
                  textType: "qrcode"
                }
              },
              {
                tid: 'providerModule.barcode', title: '条形码', data: 'XS888888888', type: 'text',
                options: {
                  testData: 'XS888888888',
                  height: 32,
                  fontSize: 12,
                  lineHeight: 18,
                  fontWeight: "700",
                  textAlign: "left",
                  textContentVerticalAlign: "middle",
                  textType: "barcode"
                }
              },
              {
                tid: 'providerModule.hline',
                title: '横线',
                type: 'hline'
              },
              {
                tid: 'providerModule.vline',
                title: '竖线',
                type: 'vline'
              },
              {
                tid: 'providerModule.rect',
                title: '矩形',
                type: 'rect'
              },
              {
                tid: 'providerModule.oval',
                title: '椭圆',
                type: 'oval'
              },
              { tid: 'providerModule.logo', title: 'Logo', data: '', type: 'image' }
            ]),
            new hiprint.PrintElementTypeGroup("业务字段", columns)
          ]
        );
      };
      hiprint.init({
        providers: [{ addElementTypes: addElementTypes }]
      });
      hiprint.PrintElementTypeManager.build('.hiprintEpContainer', 'providerModule');
    },
    testSql() { //测试数据源
      sysPrinterPlans
        .query({
          sourceSql: this.sourceSql,
          paramJsonStr: JSON.stringify(this.inParam)
        })
        .then((response) => {
          if (this.groupBy && this.groupBy != '') {
            this.testSqlResult = groupBy(response.data, this.groupBy)
          } else {
            this.testSqlResult = response.data
          }
        })
    },
    btnPreview() { //预览
      if (this.sourceSql == '') {
        this.$message.error('请设置数据源')
      }
      if (this.inParamColumns.length > 0) {  //需要设置参数
        this.previewParamDlg = true;
      } else {
        this.showPreviewDlg();
      }
    },
    showPreviewDlg() { //显示预览界面
      sysPrinterPlans
        .query({
          sourceSql: this.sourceSql,
          paramJsonStr: JSON.stringify(this.inParam)
        })
        .then((response) => {
          if (response.data.length == 0) {
            this.$message.error('未查询到任何打印数据，请调整数据源或入口参数值')
            return;
          }
          let { width } = this.curPaper
          if (this.groupBy && this.groupBy != '') {
            this.testSqlResult = groupBy(response.data, this.groupBy)
          } else {
            this.testSqlResult = response.data
          }
          this.$refs.preView.show(hiprintTemplate, this.testSqlResult, width)
        })
    },
    curPaperType() { //根据宽高反向计算纸张类型
      let type = 'other'
      let types = this.paperTypes
      for (const key in types) {
        let item = types[key]
        let { width, height } = this.curPaper
        if (item.width === width && item.height === height) {
          type = key
        }
      }
      return type
    },
    /**
     * 设置纸张大小
     * @param type [A3, A4, A5, B3, B4, B5, other]
     * @param value {width,height} mm
     */
    setPaper(value) {
      if (value != undefined && value != null) {
        this.curPaper.width = value.width
        this.curPaper.height = value.height
      }
      hiprintTemplate.setPaper(this.curPaper.width, this.curPaper.height)
      this.curPaper.type = this.curPaperType()
    },
    otherPaper() {
      this.paperPopVisible = false
      this.setPaper()
    },
    changeScale(currentValue, oldValue) {
      let big = false
      currentValue <= oldValue ? big = false : big = true
      let scaleValue = this.scaleValue;
      if (big) {
        scaleValue += 0.1;
        if (scaleValue > this.scaleMax) scaleValue = 5;
      } else {
        scaleValue -= 0.1;
        if (scaleValue < this.scaleMin) scaleValue = 0.5;
      }
      if (hiprintTemplate) {
        // scaleValue: 放大缩小值, false: 不保存(不传也一样), 如果传 true, 打印时也会放大
        hiprintTemplate.zoom(scaleValue);
        this.scaleValue = scaleValue;
      }
    },
    clearPaper() {
      MessageBox.confirm('是否确认清空模板信息?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        try {
          hiprintTemplate.clear();
        } catch (error) {
          this.$message.error(`操作失败: ${error}`);
        }
      }).catch((err) => {
        console.log(err)
      })
    },
    print() {
      if (window.hiwebSocket.opened) {
        const printerList = hiprintTemplate.getPrinterList();
        console.log(printerList)
        hiprintTemplate.print2(this.testSqlResult, { printer: '', title: 'hiprint测试打印' });
        return
      }
      this.$message.error('客户端未连接,无法直接打印')
    },
    save() {
      if(this.name ==''){
        this.$message.error('打印方案名称不能为空')
        return;
      }
      if (this.id && this.id != '') { //编辑
        sysPrinterPlans.update({
          id: this.id,
          name: this.name,
          groupBy: this.groupBy,
          columnView: this.columnView,
          sourceSql: this.sourceSql,
          inParamColumn: this.inParamColumns.join(),
          planContent: JSON.stringify(hiprintTemplate.getJson()) //模板内容
        }).then(() => {
          this.$notify({
            title: '成功',
            message: '修改成功',
            type: 'success',
            duration: 2000,
          })
        })
      } else {  //新增
        sysPrinterPlans.add({
          name: this.name,
          columnView: this.columnView,
          sourceSql: this.sourceSql,
          groupBy: this.groupBy,
          inParamColumn: this.inParamColumns.join(),
          planContent: JSON.stringify(hiprintTemplate.getJson()) //模板内容
        }).then((response) => {
          this.id = response.result
          this.$notify({
            title: '成功',
            message: '创建成功',
            type: 'success',
            duration: 2000,
          })
        })
      }
    }
  }
}
</script>
<style lang="scss">
.rect-printElement-types .hiprint-printElement-type>li>ul>li>a {
  padding: 4px 4px;
  line-height: 1.5 !important;
  height: auto !important;
  text-overflow: ellipsis;
}

.hiprint-printElement-image-content {
  img {
    content: url("~@/assets/logo.png");
  }
}

.card-design {
  overflow: hidden;
  overflow-x: auto;
  overflow-y: auto;
}
</style>
