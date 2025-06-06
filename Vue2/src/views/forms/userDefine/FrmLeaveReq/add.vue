<!--
 * @description: 系统模拟的一个自定义表单
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-07-10 创建时可以根据开始节点父级组件提供的可写表单项Id信息，控制整个表单哪些表单项可以更改
 *                        如果开始节点没有设置，默认全部可写（🔴正好和审批的设置模式相反）
-->
<template>
  <el-container style="border: 1px solid #eee">
    <el-main>
      <el-form label-width="80px" ref="dataForm" :model="temp" :rules="rules">
        <el-form-item label="请假类型">
          <el-radio-group v-model="temp.requestType">
            <el-radio label="病假"></el-radio>
            <el-radio label="事假"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="'请假人'" prop="userName">
          <el-input name="name" :disabled="disabled('userName')" v-model="temp.userName"></el-input>
        </el-form-item>

        <el-form-item label="开始时间">
          <el-col :span="11">
            <el-date-picker :disabled="disabled('startDate')" type="date" placeholder="选择日期" v-model="temp.startDate" style="width: 100%;"></el-date-picker>
          </el-col>
          <el-col class="line" :span="2">-</el-col>
          <el-col :span="11">
            <el-time-picker :disabled="disabled('startTime')" type="fixed-time" placeholder="选择时间" v-model="temp.startTime" style="width: 100%;"></el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item label="结束时间">
          <el-col :span="11">
            <el-date-picker :disabled="disabled('endDate')" type="date" placeholder="选择日期" v-model="temp.endDate" style="width: 100%;"></el-date-picker>
          </el-col>
          <el-col class="line" :span="2">-</el-col>
          <el-col :span="11">
            <el-time-picker :disabled="disabled('endTime')" type="fixed-time" placeholder="选择时间" v-model="temp.endTime" style="width: 100%;"></el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item size="small" :label="'请假说明'" prop="requestComment">
          <el-input type="textarea" :disabled="disabled('requestComment')" :rows="3" v-model="temp.requestComment"></el-input>
        </el-form-item>

        <el-form-item>
          <el-upload
            class="upload-demo"
            :headers="tokenHeader"
            :on-change="handleChange"
            :action="baseURL + '/Files/Upload'"
            :on-remove="handleRemove"
            :before-remove="beforeRemove"
            multiple
            name="files"
            :limit="3"
            list-type="picture"
            :on-exceed="handleExceed"
          >
            <el-button size="small" type="primary">上传附加，如医院就诊记录</el-button>
            <div slot="tip" class="el-upload__tip">只能上传不超过1Mb</div>
          </el-upload>
        </el-form-item>
      </el-form>
    </el-main>
  </el-container>
</template>

<script>
import * as forms from '@/api/forms'
import { getToken } from '@/utils/auth'

export default {
  name: 'frm-leave-req-add',
  components: {},
  props: {
    isEdit: {
      type: Boolean,
      default: false,
    },

    canWriteFormItemIds: Array,
  },
  data() {
    const validateRequire = (rule, value, callback) => {
      if (value === '') {
        this.$message({
          message: rule.field + '为必传项',
          type: 'error',
        })
        callback(null)
      } else {
        callback()
      }
    }
    return {
      baseURL: process.env.VUE_APP_BASE_API, // api的base_url
      tokenHeader: {'X-Token': getToken()},
      temp: {
        id: '', // ID
        userName: '', // 请假人姓名
        requestType: '', // 请假分类，病假，事假，公休等
        startDate: '', // 开始日期
        startTime: '', // 开始时间
        endDate: '', // 结束日期
        endTime: '', // 结束时间
        requestComment: '', // 请假说明
        attachment: '', // 附件，用于提交病假证据等
        files: [],
        extendInfo: '', // 其他信息,防止最后加逗号，可以删除
      },

      loading: false,
      rules: {
        name: [
          {
            validator: validateRequire,
          },
        ],
      },
    }
  },

  methods: {
    /**
     * 判定表单项是否只读
     */
    disabled: function(id) {
      if (this.canWriteFormItemIds == undefined || this.canWriteFormItemIds.length == 0) {
        return false //在开始节点，如果没有设置，默认全部可写（🔴正好和审批的设置相反）
      }
      let canwrite = this.canWriteFormItemIds.indexOf(id) > -1
      return !canwrite
    },
    handleChange(file, fileList) {
      this.temp.files = fileList
        .filter((u) => u.status === 'success')
        .map((u) => u.response.result[0])
        .map((u) => {
          return {
            fileName: u.fileName,
            filePath: u.filePath,
          }
        })
    },
    handleRemove(file, fileList) {
      console.log(file, fileList)
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 3 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`)
    },
    beforeRemove(file) {
      return this.$confirm(`确定移除 ${file.name}？`)
    },
    fetchData(id) {
      forms
        .get(id)
        .then(() => {})
        .catch((err) => {
          console.log(err)
        })
    },
    getFormInfo() {
      // 用于流程分支条件选择
      return [
        {
          name: 'userName',
          title: '请假人姓名',
        },
        {
          name: 'startDate',
          title: '开始日期',
        },
        {
          name: 'endDate',
          title: '结束日期',
        },
        {
          name: 'requestComment',
          title: '请假说明',
        },
      ]
    },
    getData() {
      return this.temp
    },
  },
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import 'src/styles/mixin.scss';
</style>
