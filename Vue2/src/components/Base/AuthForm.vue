<!--
 * @description: 通用表单
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-08-18
               2021-09-15 -liyubao:增加v-model的支持
               2021-09-22 -liyubao: fix issue https://gitee.com/yubaolee/OpenAuth.Core/issues/I4BBIG
 * @description: 通用的表单项，简单的用法如下：
                 <auth-form ref="dataForm" :edit-model="editModel" :form-fields="firstHeaderList" :data="firstTemp" :col-num="3"></auth-form>
-->

<template>
  <el-form ref="dataForm" :rules="rules" :model="data" label-position="right" label-width="100px" style="height:calc(100% - 34px);overflow: auto;">
    <el-row v-for="(row, findex) in formFieldsExchange" :key="findex">
      <el-col :span="span" v-for="(col, cindex) in row" :key="cindex">

         <!--静态下拉列表选项-->
        <el-form-item v-if="col.editType == 'select' ||col.editType == 'selectDynamic'" size="mini" :label="col.remark" :prop="col.columnName">
          <auth-select :isEdit="true" :type="col.editType=='select'?'static':'dynamic'" :search-key="searchKey" :disabled="!editModel" :data-source="col.dataSource" v-model="data[col.columnName]"></auth-select>
        </el-form-item>

         <!--switch框处理bool类型-->
        <el-form-item v-else-if="col.editType == 'switch'" size="mini" :label="col.remark" :prop="col.columnName">
          <el-switch v-model="data[col.columnName]" :active-value="true" :disabled="!editModel" :inactive-value="false"> </el-switch>
        </el-form-item>

        <!--日期渲染-->
        <el-form-item v-else-if="col.editType == 'date'" size="mini" :label="col.remark" :prop="col.columnName">
          <el-date-picker v-model="data[col.columnName]" value-format="yyyy-MM-dd" type="date" style="width: 185px;" size="mini" :disabled="!editModel"> </el-date-picker>
        </el-form-item> 

         <!--时间-->
        <el-form-item v-else-if="col.editType == 'datetime'" size="mini" :label="col.remark" :prop="col.columnName">
          <el-date-picker v-model="data[col.columnName]" type="datetime" style="width: 185px;" size="mini" :disabled="!editModel"> </el-date-picker>
        </el-form-item>

         <!--多行文本-->
        <el-form-item v-else-if="col.editType == 'textarea'" size="mini" :label="col.remark" :prop="col.columnName">
          <el-input type="textarea" v-model="data[col.columnName]" :disabled="!editModel"></el-input>
        </el-form-item>

        
        <!--普通文本框渲染-->
        <el-form-item v-else size="mini" :label="col.remark" :prop="col.columnName">
          <el-input v-model="data[col.columnName]" :disabled="!editModel"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
import AuthSelect from '@/components/Base/AuthSelect'
export default {
  name: 'authForm',
  components: {
    AuthSelect,
  },
  model: {
    prop: 'data'
  },
  props: {
    width: {
      //表单宽度
      type: Number,
      default: 0,
    },
    /**
     * 表单左边label文字标签的宽度
     */
    labelWidth: {
      type: Number,
      default: 100,
    },
    /**
     * 是否可编辑
     */
    editModel: {
      type: Boolean,
      default: false,
    },
    /**
     * 列数,需要可以被24整除
     */
    colNum: {
      type: Number,
      default: 1,
    },
    /**
     * 表单绑定的数据
     */
    data: {
      type: Object,
    },
    /**
     * 表单字段定义
     */
    formFields: {
      type: Array,
      default: () => {
        return []
      },
    },
    /**
     * 数据验证规则
     */
    rules: {
      type: Object,
    },
  },
  watch: {
    formFields: function(newVal) {
      this.setFormFieldsExchange(newVal)
    },
  },
  data() {
    return {
      searchKey: {
        //动态下拉框搜索关键字
        page: 1,
        limit: 9999,
        key: ''
      },
      /**
       * 表单项属性定义，将外部传来的一维数组转换为二维数组，方便渲染
       */
      formFieldsExchange: [],
    }
  },
  mounted() {
    // 第一次加载时，formFields无变化，watch无法监听变化
    this.setFormFieldsExchange(this.formFields)
  },
  computed: {
    span() {
      //按传入的列数，计算每列的宽度
      return 24 / this.colNum
    },
  },
  methods: {
    setFormFieldsExchange(newVal) {
      let index = 0
      let row = []
      let _this = this
      _this.formFieldsExchange =[]
      newVal.filter((u) => u.isEdit)
      .sort((a, b) => b.sort - a.sort)
      .forEach((item) => {
        row.push(item)
        index++

        if (index >= _this.colNum) {
          index = 0
          _this.formFieldsExchange.push(row)
          row = []
        }
      })

      if(row.length > 0) { 
        _this.formFieldsExchange.push(row)
      }
    },
    validate(callback) {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          callback()
        }
      })
    },

    clearValidate() {
      this.$refs['dataForm'].clearValidate()
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
