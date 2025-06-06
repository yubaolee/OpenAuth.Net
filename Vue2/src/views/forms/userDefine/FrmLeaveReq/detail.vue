<!--
 * @description: 系统模拟的一个自定义表单
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-07-08 审核时可以根据父级组件提供的可写表单项Id信息，控制整个表单哪些表单项可以更改
-->

<template>
  <el-container style="border: 1px solid #eee">
    <el-main>
      <el-form label-width="80px">
        <el-form-item label="">
          <el-tag>这是一个表单详情展示样例，你可以完全根据客户的需求进行排版</el-tag>
        </el-form-item>
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
          <el-col class="line" :span="2" style="text-align: center;">-</el-col>
          <el-col :span="11">
            <el-time-picker :disabled="disabled('startTime')" type="fixed-time" placeholder="选择时间" v-model="temp.startTime" style="width: 100%;"></el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item label="结束时间">
          <el-col :span="11">
            <el-date-picker :disabled="disabled('endDate')" type="date" placeholder="选择日期" v-model="temp.endDate" style="width: 100%;"></el-date-picker>
          </el-col>
          <el-col class="line" :span="2" style="text-align: center;">-</el-col>
          <el-col :span="11">
            <el-time-picker :disabled="disabled('endTime')" type="fixed-time" placeholder="选择时间" v-model="temp.endTime" style="width: 100%;"></el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item size="small" :label="'请假说明'" prop="requestComment">
          <el-input type="textarea" :disabled="disabled('requestComment')" :rows="3" v-model="temp.requestComment"></el-input>
        </el-form-item>

        <el-carousel :interval="4000" type="card" height="150px">
          <el-carousel-item v-for="file in temp.files" :key="file.filePath">
            <a :href="baseURL + '/' + file.filePath" target="_blank"><img height="150" :src="baseURL + '/' + file.filePath" :title="file.fileName"/></a>
          </el-carousel-item>
        </el-carousel>
      </el-form>
    </el-main>
  </el-container>
</template>

<script>
export default {
  name: 'frm-leave-req-detail',
  props: ['frmData', 'canWriteFormItemIds'],
  data() {
    return {
      baseURL: process.env.BASE_IMG_URL,
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
    }
  },
  mounted() {
    this.temp = JSON.parse(this.frmData)
  },
  watch: {
    temp: function(val) {
      this.$emit('update:frmData', JSON.stringify(val))
    },
  },
  methods: {
    /**
     * 判定表单项是否只读
     */
    disabled: function(id) {
      if (this.canWriteFormItemIds == undefined || this.canWriteFormItemIds.length == 0) {
        return true //在审批节点，如果没有设置，默认全部只读（🔴正好和开始的设置相反）
      }
      let canwrite = this.canWriteFormItemIds.indexOf(id) > -1
      return !canwrite
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
