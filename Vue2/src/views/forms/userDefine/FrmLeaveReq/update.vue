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
          <el-input name="name" v-model="temp.userName"></el-input>
        </el-form-item>

        <el-form-item label="开始时间">
          <el-col :span="11">
            <el-date-picker type="date" placeholder="选择日期" v-model="temp.startDate" style="width: 100%;">
            </el-date-picker>
          </el-col>
          <el-col class="line" :span="2" style="text-align: center;">-</el-col>
          <el-col :span="11">
            <el-time-picker type="fixed-time" placeholder="选择时间" v-model="temp.startTime" style="width: 100%;">
            </el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item label="结束时间">
          <el-col :span="11">
            <el-date-picker type="date" placeholder="选择日期" v-model="temp.endDate" style="width: 100%;"></el-date-picker>
          </el-col>
          <el-col class="line" :span="2" style="text-align: center;">-</el-col>
          <el-col :span="11">
            <el-time-picker type="fixed-time" placeholder="选择时间" v-model="temp.endTime" style="width: 100%;">
            </el-time-picker>
          </el-col>
        </el-form-item>

        <el-form-item size="small" :label="'请假说明'" prop="requestComment">
          <el-input type="textarea" :rows="3" v-model="temp.requestComment"></el-input>
        </el-form-item>


        <el-carousel :interval="4000" type="card" height="150px">
          <el-carousel-item v-for="file in temp.files" :key="file.filePath">
            <a :href="baseURL +'/' + file.filePath" target="_blank"><img height="150"
                :src="baseURL +'/' + file.filePath" :title="file.fileName" /></a>
          </el-carousel-item>
        </el-carousel>

      </el-form>
    </el-main>
  </el-container>

</template>

<script>
  export default {
    name: 'frm-leave-req-update',
    props: ['frmData','canWriteFormItemIds'],
    data() {
      return {
        baseURL: process.env.BASE_IMG_URL,
        temp: {}
      }
    },
    created() {
      this.temp = JSON.parse(this.frmData)
    },
    methods: {
      handleChange(file, fileList) {
        this.temp.files = fileList.filter(u => u.status === 'success')
          .map(u => u.response.data[0])
          .map(u => {
            return {
              fileName: u.fileName,
              filePath: u.filePath
            }
          })
      },
      handleRemove(file, fileList) {
        console.log(file, fileList)
      },

      getFormInfo() { // 用于流程分支条件选择
        return [{
            name: 'userName',
            title: '请假人姓名'
          },
          {
            name: 'startDate',
            title: '开始日期'
          },
          {
            name: 'endDate',
            title: '结束日期'
          },
          {
            name: 'requestComment',
            title: '请假说明'
          }
        ]
      },
      getData() {
        return this.temp
      }
    }
  }
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
  @import "src/styles/mixin.scss";
</style>