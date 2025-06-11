<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-02-23 11:36:24
 * @Description: 处于草稿和驳回状态的流程，可以进行编辑
 *               可以编辑流程的基本信息和提交的表单内容
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div>
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-button v-loading="loading" size="mini" style="margin-left: 10px" type="success" @click="submitForm">保存
        </el-button>
      </div>
    </sticky>
    <div class="createPost-container">
      <el-form class="form-container" :model="postObj" :rules="rules" ref="postObj">
        <el-row>
          <el-col :span="12">
            <el-form-item label="标题" label-width="100px" prop="schemeNameRule">
              <el-input name="name" v-model="postObj.customName" required style="max-width: 200px"> </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label-width="100px" label="实例编号:">
              <el-input type="text" v-model="postObj.code" style="max-width: 200px"> </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label-width="100px" label="发布时间:" class="postInfo-container-item">
              <el-date-picker v-model="postObj.createDate" type="datetime" format="yyyy-MM-dd HH:mm:ss"
                placeholder="选择日期时间"> </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label-width="100px" label="重要性(占位):" class="postInfo-container-item">
              <el-rate style="margin-top: 8px" :max="3" :colors="['#99A9BF', '#F7BA2A', '#FF9900']" :low-threshold="1"
                :high-threshold="3"> </el-rate>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label-width="100px" label="摘要:">
              <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="postObj.description"> </el-input>
              <span class="word-counter" v-if="contentShortLength">{{ contentShortLength }}字</span>
            </el-form-item>
          </el-col>
        </el-row>

        <!--运行时选定用户-->
        <el-form-item label="选择下一个节点执行用户" v-if="postObj.NodeDesignateType === 'RUNTIME_SPECIAL_USER'">
          <select-users placeholder="*选择下一个节点执行用户" :userNames.sync="postObj.NodeDesignateTxts"
            :users="postObj.NodeDesignates" v-on:users-change="usersChange"> </select-users>
        </el-form-item>

        <el-form-item label="选择下一个节点执行角色" v-if="postObj.NodeDesignateType === 'RUNTIME_SPECIAL_ROLE'">
          <select-roles placeholder="*选择下一个节点执行角色" :userNames.sync="postObj.NodeDesignateTxts"
            :roles="postObj.NodeDesignates" v-on:roles-change="rolesChange"> </select-roles>
        </el-form-item>
        <!--运行时选定用户 end-->

        <el-collapse v-model="activeNames" style="padding: 0 15px; background: #fff">
          <el-collapse-item name="1">
            <!--开发者自定义表单-->
            <el-card class="box-card" v-if="postObj.frmType == 1">
              <component v-if="userDefineComp" :is="userDefineComp" ref="frmData" :frmData="postObj.frmData"></component>
            </el-card>
            <!--可拖动表单-->
            <template v-else-if="postObj.frmType === 2">
              <div style="padding-right: 25px">
                <v-form-render :form-json="formJson" :form-data="formData" :option-data="optionData" ref="vFormRef">
                </v-form-render>
              </div>
            </template>
            <el-card class="box-card" v-else>
              <form ref="frmData">
                <p v-html="postObj.frmPreviewHtml"></p>
              </form>
            </el-card>
          </el-collapse-item>

          <el-collapse-item title="流程图" name="3">
            <span slot="title" style="font-size: 16px; font-weight: 600">流程图</span>
            <div style="height: 500px">
              <CreatedFlow ref="createdFlow" :form-template="currentForm" :isEdit="true" :isShowContent="isShowContent"
                :scheme-content="postObj.schemeContent"></CreatedFlow>
            </div>
          </el-collapse-item>
        </el-collapse>
      </el-form>
    </div>
  </div>
</template>

<script>
import Sticky from '@/components/Sticky' // 粘性header组件
import * as apiFlowinstances from '@/api/flowinstances'
import CreatedFlow from '@/components/CreatedFlow'
import { jump } from '@/utils/jumpRoute'
import { mapGetters } from 'vuex'
export default {
  name: 'flowinstanceUpdate',
  components: {
    Sticky,
    CreatedFlow,
  },
  computed: {
    ...mapGetters(['defaultorgid']),
    contentShortLength() {
      return this.postObj.description ? this.postObj.description.length : 0
    },
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
      formJson: {}, //表单中的控件属性描述
      formData: {}, //表单数据
      optionData: {},
      isShowContent: true,
      currentForm: null,
      userDefineComp: null, //用户自定义表单
      postObj: {
        id: '',
        customName: '',
        schemeContent: '',
        createDate: '',
        activityName: '',
        code: '',
        dbName: '',
        frmType: 0,
        frmData: '',
        activityId: '',
        NodeDesignateType: '', //如果下个执行节点是运行时指定执行者。需要传指定的类型.RUNTIME_SPECIAL_ROLE、RUNTIME_SPECIAL_USER
        NodeDesignates: [], //如果下个执行节点是运行时指定执行者。该值表示具体的执行者
        NodeDesignateTxts: '', //选中执行者显示的文本
      },
      rules: {
        schemeNameRule: [
          {
            validator: validateRequire,
          },
        ],
        frmRule: [
          {
            validator: validateRequire,
          },
        ],
      },
      activeNames: ['1', '2', '3'], // 展开的信息
      loading: false,
    }
  },
  created() {
    const id = this.$route.params && this.$route.params.id
    apiFlowinstances
      .get({
        id: id,
      })
      .then((response) => {
        this.postObj = response.data
        this.formData = JSON.parse(response.data.frmData)
        this.formJson = JSON.parse(response.data.frmContentData)

        if (this.postObj.frmType === 1) {
          // 用户自定义的页面,即Vue组件
          let loadComp = () => import(`@/views/forms/userDefine/${this.postObj.dbName}/update`)
          loadComp().then(res => {
            this.userDefineComp = res.default
          })
        }
      })
      .catch((err) => {
        console.log(err)
      })
  },
  methods: {
    handleUpdate() {
      const _this = this
      _this.postObj.OrgId = this.defaultorgid
      apiFlowinstances.update(_this.postObj).then(() => {
        _this.loading = false
        _this.$notify({
          title: '成功',
          message: '修改成功',
          type: 'success',
          duration: 2000,
        })
      })
      _this.loading = false
      jump(_this, '/flowInstances/Index')
    },
    submitForm() {
      var _this = this
      _this.$refs.postObj.validate((valid) => {
        if (!valid) return false
        _this.loading = true
        if (_this.postObj.frmType === 1) {
          // 使用的是自定义的页面提交
          _this.postObj.frmData = JSON.stringify(_this.$refs.frmData.getData())
        } else if (_this.postObj.frmType === 0) {
          // 动态表单提交数据
          const frmdata = {}
          for (let i = 0; i < _this.$refs.frmData.elements.length; i++) {
            frmdata[_this.$refs.frmData[i].name] = _this.$refs.frmData[i].value
          }
          _this.postObj.frmData = JSON.stringify(frmdata)
        } else {
          //拖动表单处理
          _this.$refs.vFormRef
            .getFormData()
            .then((res) => {
              _this.postObj.frmData = JSON.stringify(res)
              _this.handleUpdate()
            })
            .catch(() => {
              _this.loading = false
            })
          return
        }
        _this.handleUpdate()
      })
    },
  },
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
}</style>
