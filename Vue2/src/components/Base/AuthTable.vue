<!--
 * @description: 通用表格组件
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-09-26 增加自定义模版的支持
* @description: 用于渲染给定列定义，给定数据的表格，简单用法如下：
*               <auth-table ref="tableName" :table-fields="tableFields" :data="dataList" ></auth-table>
*               支持的事件：row-click selection-change
*               支持的方法：exportExcel clearSelection
-->

<template>
  <el-table ref="mainTable" border :data="data" v-loading="vLoading" tooltip-effect="dark" style="width: 100%;" height="100%" @row-click="rowClick" @selection-change="selectionChange">
    <!--单选-->
    <el-table-column v-if="selectType == 'radio'" width="55" align="center">
      <template slot-scope="scope">
        <el-radio :label="scope.row.id" v-model="currentSelected">{{ '' }}</el-radio>
      </template>
    </el-table-column>
    <!--多选-->
    <el-table-column v-if="selectType == 'checkbox'" width="55" type="selection" align="center"> </el-table-column>

    <!--使用服务器返回的表头，如果复杂的表头和格式解析，请自己定义表格格式-->
    <template v-for="(headerItem, index) in tableFields.filter((u) => u.isList).sort((a, b) => a.sort - b.sort)">
      <!-- 用父类传进来的自定义模版来处理显示 -->
      <el-table-column v-if="templates.some((x) => x == headerItem.columnName)" :key="index" :label="headerItem.remark">
        <template slot-scope="scope">
          <component :row="scope.row" v-bind:is="headerItem.columnName"> </component>
        </template>
      </el-table-column>

      <!-- 静态下拉框处理 -->
      <el-table-column v-else-if="headerItem.editType == 'select' || headerItem.editType == 'selectDynamic'" :key="index" :label="headerItem.remark">
        <template slot-scope="scope">
          <auth-select :isEdit="editModel && headerItem.isEdit" :type="headerItem.editType == 'select' ? 'static' : 'dynamic'" :search-key="searchKey" @change="itemChange(scope.row)" :data-source="headerItem.dataSource" v-model="scope.row[headerItem.columnName]" size="mini"></auth-select>
        </template>
      </el-table-column>

      <!--switch框处理bool类型-->
      <el-table-column v-else-if="headerItem.editType == 'switch'" :prop="headerItem.columnName" :label="headerItem.remark" :key="index" show-overflow-tooltip>
        <template slot-scope="scope">
          <el-switch @change="itemChange(scope.row)" v-model="scope.row[headerItem.columnName]" :active-value="true" :inactive-value="false" :disabled="!editModel || !headerItem.isEdit" size="mini"> </el-switch>
        </template>
      </el-table-column>

      <!--日期选择框处理-->
      <el-table-column v-else-if="headerItem.editType == 'date'" :prop="headerItem.columnName" :label="headerItem.remark" :key="index" show-overflow-tooltip>
        <template slot-scope="scope">
          <el-date-picker @change="itemChange(scope.row)" v-if="editModel && headerItem.isEdit" v-model="scope.row[headerItem.columnName]" type="date" :placeholder="scope.row[headerItem.remark]" style="width: 130px;" value-format="yyyy-MM-dd" size="mini"> </el-date-picker>
          <span v-else>{{ scope.row[headerItem.columnName] }}</span>
        </template>
      </el-table-column>

      <!--时间选择框处理-->
      <el-table-column v-else-if="headerItem.editType == 'datetime'" :prop="headerItem.columnName" :label="headerItem.remark" :key="index" show-overflow-tooltip>
        <template slot-scope="scope">
          <el-date-picker @change="itemChange(scope.row)" v-if="editModel && headerItem.isEdit" v-model="scope.row[headerItem.columnName]" type="datetime" :placeholder="scope.row[headerItem.remark]" style="width: 130px;" size="mini"> </el-date-picker>
          <span v-else>{{ scope.row[headerItem.columnName] }}</span>
        </template>
      </el-table-column>

      <!--普通的处理方式-->
      <el-table-column v-else :prop="headerItem.columnName" :label="headerItem.remark" :key="index" show-overflow-tooltip>
        <template slot-scope="scope">
          <el-input @keyup.enter.native="itemChange(scope.row)" v-if="editModel && headerItem.isEdit" v-model="scope.row[headerItem.columnName]" size="mini"> </el-input>
          <span v-else>{{ scope.row[headerItem.columnName] }}</span>
        </template>
      </el-table-column>
    </template>
  </el-table>
</template>

<script>
import extend from '@/extensions/filterCategory.js'
import AuthSelect from '@/components/Base/AuthSelect'
export default {
  name: 'authTable',
  components: {
    AuthSelect
  },
  mixins: [extend],
  props: {
    /**
     * 表格列模版列表，用来处理有特殊列显示的需求
     */
    templates: {
      type: Array,
      default: () => {
        return []
      }
    },

    /**
     * 表格选择方式：checkbox/radio
     * 默认为checkbox
     */
    selectType: {
      type: String,
      default: 'checkbox'
    },
    /**
     * 是否可编辑
     */
    editModel: {
      type: Boolean,
      default: false
    },
    /**
     * 加载状态
     */
    vLoading: {
      type: Boolean,
      default: false
    },

    /**
     * 列表头定义
     */
    tableFields: {
      type: Array,
      default: () => {
        return []
      }
    },
    /**
     * 列表数据
     */
    data: {
      type: Array,
      default: () => {
        return []
      }
    }
  },
  watch: {},
  data() {
    return {
      searchKey: {
        //动态下拉框搜索关键字
        page: 1,
        limit: 9999,
        key: ''
      },
      currentSelected: '' //当前选中的数据
    }
  },
  mounted() {},
  computed: {
    json_fields() {
      let obj = {}

      this.tableFields
        .filter((u) => u.isList)
        .forEach((item) => {
          if (!item.remark) return
          if (item.editType === 'select') {
            //下拉需要选择的
            obj[item.remark] = {
              field: item.columnName,
              callback: (value) => {
                return this.filterSelect(value, item.dataSource)
              }
            }
            return
          }
          if (item.editType === 'switch') {
            obj[item.remark] = {
              field: item.columnName,
              callback: (value) => {
                return this.filterSwitch(value, item.dataSource)
              }
            }
            return
          }
          obj[item.remark] = item.columnName
        })
      return obj
    }
  },
  methods: {
    /**
     * 点击行事件
     */
    rowClick(row) {
      this.currentSelected = row.id
      this.$emit('row-click', row)
    },
    /**
     * 选择行发生变化事件
     */
    selectionChange(val) {
      this.$emit('selection-change', val)
    },

    /**
     * 表单项值变化事件
     */
    itemChange(val) {
      this.$emit('item-change', val)
    },
    /**
     * 清空选择项
     */
    clearSelection() {
      this.$refs.mainTable.clearSelection()
    },
    /**
     * 选中当前行
     */
    toggleRowSelection(row) {
      this.$refs.mainTable.toggleRowSelection(row)
    },
    /**
     * 导出excel
     * @fileName 导出文件名
     */
    exportExcel(fileName, callback) {
      let obj = {}
      obj.json_fields = this.json_fields
      obj.data = this.data
      obj.excelName = fileName
      callback(obj)
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
</style>

<style scoped>
.el-form-item {
  margin-bottom: 15px !important;
}

.m-t-lg {
  margin-top: 20px;
}

.pagination-container {
  border: 0;
  padding-left: 0 !important;
}

.times .el-date-editor.el-input,
.times .el-date-editor.el-input__inner {
  width: 120px;
}

.times .el-select {
  width: 120px;
}

.box-flex .label {
  width: 50px;
}

.m-b-sm {
  margin-bottom: 5px;
}

.p-l-m {
  padding-left: 10px;
}

.p-r-m {
  padding-right: 10px;
}
.edit-button {
  position: absolute !important;
  top: 2px;
  right: 5px;
}
.delete-button {
  right: 90px;
}
.show-title-button {
  cursor: pointer;
  padding: 0 10px 0 0;
}
</style>
