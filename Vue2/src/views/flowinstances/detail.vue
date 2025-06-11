<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2025-04-07 23:00:07
 * @Description: 流程实例详情
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div>
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        {{ postObj.customName }}
        <el-tag size="mini" style="margin-left: 10px">{{ postObj.createDate }}</el-tag>
        <el-tag size="mini">{{ postObj.activityName }}</el-tag>
      </div>
    </sticky>
    <div class="createPost-container">
      <el-collapse v-model="activeNames" style="padding: 0 15px; background: #fff">
        <el-collapse-item name="1">
          <el-card class="box-card" v-if="postObj.frmType == 1">
            <component v-if="userDefineComp" :is="userDefineComp" :frmData="postObj.frmData">
            </component>
          </el-card>

          <template v-else-if="postObj.frmType === 2">
            <div style="padding-right: 25px">
              <v-form-render :form-json="formJson" :form-data="formData" :option-data="optionData" ref="vFormRef">
              </v-form-render>
            </div>
          </template>
          <!-- URL表单 -->
          <el-card class="box-card" v-else-if="postObj.frmType === 3">
            <iframe v-if="postObj.frmType === 3"
              :src="postObj.frmData.startsWith('http') ? postObj.frmData : ('/#' + postObj.frmData)"
              style="width:100%;height:500px;border:none;"></iframe>
          </el-card>
          <el-card class="box-card" v-else>
            <p v-html="postObj.frmPreviewHtml"></p>
          </el-card>
        </el-collapse-item>
        <el-collapse-item title="流转记录" name="2">
          <span slot="title" style="font-size: 16px; font-weight: 600">流转记录</span>
          <el-timeline>
            <el-timeline-item v-for="(history, index) in histories" :key="index" :timestamp="history.createDate">
              {{ history.content }}
            </el-timeline-item>
          </el-timeline>
        </el-collapse-item>
        <el-collapse-item title="流程图" name="3">
          <span slot="title" style="font-size: 16px; font-weight: 600">流程图</span>
          <div style="height: 500px">
            <CreatedFlow ref="createdFlow" :form-template="currentForm" :isEdit="true" :isShowContent="isShowContent"
              :scheme-content="postObj.schemeContent"></CreatedFlow>
          </div>
        </el-collapse-item>
      </el-collapse>
    </div>
  </div>
</template>

<script>
import Sticky from '@/components/Sticky' // 粘性header组件
import * as apiFlowinstances from '@/api/flowinstances'
import CreatedFlow from '@/components/CreatedFlow'
export default {
  name: 'flowinstanceDetail',
  components: {
    Sticky,
    CreatedFlow,
  },
  data() {
    return {
      formJson: {}, //表单中的控件属性描述
      formData: {}, //表单数据
      optionData: {},
      userDefineComp: null, //用户自定义表单
      isShowContent: true,
      currentForm: null,
      postObj: {
        customName: '',
        schemeContent: '',
        createDate: '',
        activityName: '',
        code: '',
        dbName: '',
        frmType: 0,
        frmData: '',
        activityId: '',
      },
      activeNames: ['1', '2', '3'], // 展开的信息
      loading: false,
      histories: [],
    }
  },
  created() {
    const id = this.$route.params && this.$route.params.id
    let _this = this
    apiFlowinstances
      .get({
        id: id,
      })
      .then((response) => {
        _this.postObj = response.data
        if (_this.postObj.frmType === 2) {
          //拖动表单
          if (!response.data.frmContentData.includes('widgetList')) {
            _this.$message({
              message: '最新版表单设计不支持v4.4及以前版本的拖动表单，新增个表单试试~~',
              type: 'error',
            })
            return
          }
          _this.formJson = JSON.parse(response.data.frmContentData)
          _this.formData = JSON.parse(response.data.frmData)

          _this.$nextTick(function () {
            this.$refs.vFormRef.disableForm()
          })
        } else if (_this.postObj.frmType === 1) { //用户自定义表单
          let loadComp = () => import(`@/views/forms/userDefine/${_this.postObj.dbName}/detail`)
          loadComp().then(res => {
            _this.userDefineComp = res.default
          })
        }

      })
      .catch((err) => {
        console.log(err)
      })

    apiFlowinstances
      .queryHistories({
        flowInstanceId: id,
      })
      .then((response) => {
        this.histories = response.data
      })
      .catch((err) => {
        console.log(err)
      })
  },
  methods: {},
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import 'src/styles/mixin.scss';

.createPost-container {
  position: relative;
  padding: 10px;

  .createPost-main-container {
    padding: 40px 45px 20px 50px;

    .postInfo-container {
      position: relative;
      @include clearfix;
      margin-bottom: 10px;

      .postInfo-container-item {
        float: left;
      }
    }

    .editor-container {
      min-height: 500px;
      margin: 0 0 30px;

      .editor-upload-btn-container {
        text-align: right;
        margin-right: 10px;

        .editor-upload-btn {
          display: inline-block;
        }
      }
    }
  }

  .word-counter {
    width: 40px;
    position: absolute;
    right: -10px;
    top: 0px;
  }
}
</style>
