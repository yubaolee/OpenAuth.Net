<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2025-04-07 22:59:00
 * @Description: 流程设计详情
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="createPost-container">
    <el-form class="form-container" :model="postObj" :rules="rules" ref="postObj">
      <el-steps :active="active" simple finish-status="success">
        <el-step title="基础信息"></el-step>
        <el-step title="选择表单"></el-step>
        <el-step title="流程设计"></el-step>
      </el-steps>
      <div class="createdPost-content">
        <!--基础信息-->
        <div class="createPost-main-container basic" v-show="active == 0">
          <div class="form-flex-container">
            <div class="form-flex-item">
              <el-form-item label="标题" label-width="100px" prop="schemeNameRule">
                <el-input name="name" v-model="postObj.schemeName" required style="max-width: 200px"> </el-input>
              </el-form-item>
            </div>
            <div class="form-flex-item">
              <el-form-item label-width="100px" label="模板编号:">
                <el-input type="text" v-model="postObj.schemeCode" style="max-width: 200px"> </el-input>
              </el-form-item>
            </div>
            <div class="form-flex-item">
              <el-form-item label-width="100px" label="发布时间:" class="postInfo-container-item">
                <el-date-picker v-model="postObj.createDate" type="datetime" format="yyyy-MM-dd HH:mm:ss" placeholder="选择日期时间"> </el-date-picker>
              </el-form-item>
            </div>
            <div class="form-flex-item">
              <el-form-item label-width="100px" label="重要性(占位):" class="postInfo-container-item">
                <el-rate style="margin-top: 8px" :max="3" :colors="['#99A9BF', '#F7BA2A', '#FF9900']" :low-threshold="1" :high-threshold="3"> </el-rate>
              </el-form-item>
            </div>
            <div class="form-flex-item full-width">
              <el-form-item label-width="100px" label="摘要:">
                <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="postObj.description"> </el-input>
                <span class="word-counter" v-if="contentShortLength">{{ contentShortLength }}字</span>
              </el-form-item>
            </div>

            <div class="form-flex-item full-width">
              <el-form-item label-width="120px" label="启用URL表单:">
                <el-switch
                  v-model="postObj.useUrlForm"
                  @change="handleUrlFormChange">
                </el-switch>
              </el-form-item>
            </div>

            <div class="form-flex-item full-width" v-if="postObj.useUrlForm">
              <el-form-item label-width="100px" label="URL表单:">
                <el-input type="textarea" :rows="3" placeholder="请输入URL表单模板，例如: /business/detail/{id}" v-model="postObj.frmUrlTemplate"> </el-input>
                <el-alert
                  title="URL表单使用业务系统的详情页展示，你可以预先设置一个URL模板（例如：/business/detail/{id}），在业务系统发起【送审】时，会自动将业务单据的id赋值到该模板，并记录到流程实例中。你也可以不用填写该模板，在业务系统发起送审时，传递一个具体的URL地址到流程实例中。"
                  type="info"
                  :closable="false"
                  show-icon
                  style="margin-top: 10px">
                </el-alert>
              </el-form-item>
            </div>
          </div>
        </div>

        <div class="createPost-main-container" v-show="active == 1">
          <el-tabs type="border-card" v-model="postObj.frmId" @tab-click="handleTabClick">
            <div class="createPost-main-model"></div>
            <template v-for="item in forms">
              <el-tab-pane :label="item.name" :name="item.id" :id="item.id" :key="item.id">
                <!-- 自定义表单 -->
                <el-card class="box-card" v-if="item.frmType == 1">
                  <component v-if="userDefineComp" :is="userDefineComp" ref="frmData"></component>
                </el-card>
                <el-card v-else-if="item.frmType === 2">
                  <v-form-render :form-json="formJson" :form-data="formData" :option-data="optionData" ref="vFormRef"> </v-form-render>
                </el-card>
                <p v-html="frmPreview" v-else></p>
              </el-tab-pane>
            </template>
          </el-tabs>
        </div>
        <!--流程设计-->
        <div class="editor-container" style="height: 100%" v-if="active == 2">
          <CreatedFlow ref="createdFlow" :form-template="currentForm" :isEdit="isEdit" :scheme-content="postObj.schemeContent"></CreatedFlow>
        </div>
      </div>
      <div class="edit-btns text-center">
        <el-button size="small" v-if="active > 0" style="margin-left: 10px" type="primary" @click="pre">上一步</el-button>
        <el-button size="small" v-if="active < 2" style="margin-left: 10px" type="primary" @click="next">下一步</el-button>
        <el-button size="small" v-if="active === 2" v-loading="loading" style="margin-left: 10px" type="success" @click="submitForm">保存 </el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
import CreatedFlow from '@/components/CreatedFlow'
import Sticky from '@/components/Sticky' // 粘性header组件
import * as flowschemes from '@/api/flowschemes'
import * as forms from '@/api/forms'
import { jump } from '@/utils/jumpRoute'
import { mapGetters, mapActions } from 'vuex'

const defaultScheme = {
  id: undefined,
  schemeCode: new Date().getTime(),
  frmId: '',
  frmType: 0,
  description: '',
  schemeName: '',
  delete: 0, // 删除标记
  enabled: 1,
  frmUrlTemplate: '', // URL表单模板
  schemeContent: '', // 表单中的控件属性描述
  useUrlForm: false, // 是否启用URL表单
}

export default {
  name: 'flow-scheme-dtl',
  components: {
    Sticky,
    CreatedFlow,
  },
  props: {
    isEdit: {
      type: Boolean,
      default: false,
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
      //表单中的控件属性描述
      formJson: {},
      formData: {},
      optionData: {},
      postObj: Object.assign({}, defaultScheme),
      loading: false,
      forms: [],
      currentForm: null, // 当前选中的form表单字段信息。name/title格式
      frmPreview: '',
      userDefineComp: null, //用户自定义表单
      active: 0,
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
    }
  },
  computed: {
    ...mapGetters(['defaultorgid', 'flowDetails', 'addFlowDetail']),
    contentShortLength() {
      return this.postObj.description ? this.postObj.description.length : 0
    },
  },
  created() {
    forms.getList().then((response) => {
      // 获取表单列表
      this.forms = response.data
      if (this.isEdit) {
        const id = this.$route.params && this.$route.params.id
        this.postObj = this.flowDetails[id].data
        this.active = this.flowDetails[id].active
        if(this.postObj.frmUrlTemplate){
          this.postObj.useUrlForm = true
        }else{
          this.onFrmChange(this.postObj.frmId)
        }
      } else {
        this.postObj = Object.assign({}, (this.addFlowDetail && this.addFlowDetail.data) || defaultScheme)
        this.active = (this.addFlowDetail && this.addFlowDetail.active) || 0
        this.postObj.frmId = this.forms[0].id
        this.onFrmChange(this.postObj.frmId)
      }
    })
  },
  beforeDestroy() {
    this.postObj.schemeContent = (this.$refs.createdFlow && JSON.stringify(this.$refs.createdFlow.flowData)) || this.postObj.schemeContent
    if (!this.postObj.id) {
      this.saveAddFlowDetails({
        data: this.postObj,
        active: this.active,
      })
      return
    }
    let data = {}
    data[this.postObj.id] = {
      data: this.postObj,
      active: this.active,
    }
    this.saveFlowDetails(data)
  },
  methods: {
    ...mapActions(['saveFlowDetails', 'saveAddFlowDetails', 'updateFlowIsRender']),
    next() {
      if (this.active === 0 && this.postObj.useUrlForm) {
        // 如果当前是基础信息步骤，且启用了URL表单，直接跳到流程设计步骤
        this.active = 2
      } else {
        if (this.active++ > 1) this.active = 0
      }
    },
    pre() {
      if (this.active === 2 && this.postObj.useUrlForm) {
        // 如果当前是流程设计步骤，且启用了URL表单，直接返回到基础信息步骤
        this.active = 0
      } else {
        if (this.active-- < 0) this.active = 0
      }
    },
    handleTabClick(tab) {
      this.onFrmChange(tab.$attrs.id)
    },
    onFrmChange(val) {
      // 预览表单
      var _this = this
      forms
        .get({
          id: val,
        })
        .then((response) => {
          _this.postObj.frmType = response.result.frmType
          if (response.result.frmType === 1) {// 自定义表单
            let loadComp = () => import(`@/views/forms/userDefine/${response.result.webId}/add`)
            loadComp().then(res => {
              _this.userDefineComp = res.default
              _this.$nextTick(() => {
                var obj = _this.$refs.frmData[0].getFormInfo()
                _this.currentForm = obj
              })
            })

            return
          }
          if (response.result.frmType === 2) {
            if (!response.result.contentData.includes('widgetList')) {
              this.$message({
                message: '最新版表单设计不支持v4.4及以前版本的拖动表单，新增个表单试试~~',
                type: 'error',
              })
              return;
            }
            // 拖动表单
            _this.formJson = JSON.parse(response.result.contentData)
            _this.$refs.vFormRef[0].setFormJson(_this.formJson)
            _this.$nextTick(()=>{
            _this.currentForm = _this.$refs.vFormRef[0].getFieldWidgets().map(item=>{return {name:item.field.options.name, title:item.field.options.label}})
            })
            return
          }
          _this.frmPreview = response.result.html // 默认动态表单
          _this.currentForm = JSON.parse(response.result.contentData)
        })
    },
    submitForm() {
      this.$refs.postObj.validate((valid) => {
        if (valid) {
          this.loading = true
          this.postObj.schemeContent = JSON.stringify(this.$refs.createdFlow.flowData)
          if (this.postObj.schemeContent === '-1') {
            this.$message({
              message: '请调整流程设计',
              type: 'error',
            })
            this.loading = false
            return
          }

          this.postObj.OrgId = this.defaultorgid

          if (this.isEdit) {
            flowschemes.update(this.postObj).then(() => {
              this.loading = false
              this.updateFlowIsRender(true)
              this.$notify({
                title: '成功',
                message: '修改成功',
                type: 'success',
                duration: 2000,
              })

              jump(this, '/flowSchemes/index')
            })
          } else {
            flowschemes.add(this.postObj).then(() => {
              this.loading = false
              this.updateFlowIsRender(true)
              this.$notify({
                title: '成功',
                message: '创建成功',
                type: 'success',
                duration: 2000,
              })

              jump(this, '/flowSchemes/index')
            })
          }

          this.loading = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    handleUrlFormChange(val) {
      if (val) {
        // 启用URL表单时，清空表单ID
        this.postObj.frmId = ''
        this.postObj.frmType = 3 //类型为url表单
      } else {
        // 禁用URL表单时，恢复默认表单
        this.postObj.frmId = this.forms[0]?.id || ''
        this.onFrmChange(this.postObj.frmId)
      }
    },
  },
}
</script>

<style rel="stylesheet/scss" lang="scss">
@import 'src/styles/mixin.scss';

.createPost-container {
  margin: 5px;
  padding: 5px;
  background-color: white;
  height: calc(100% - 10px);

  .form-container {
    height: 100%;
  }

  .createdPost-content {
    height: calc(100% - 90px);
    overflow: auto;
  }

  .createPost-main-container {
    max-width: 800px;
    margin: 0 auto;
    margin-top: 40px;
    position: relative;

    .createPost-main-model {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      z-index: 1;
      cursor: not-allowed;
    }
  }

  .form-flex-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    padding: 0 10px;

    .form-flex-item {
      flex: 1;
      min-width: 300px;
      max-width: calc(50% - 10px);

      &.full-width {
        flex: 0 0 100%;
        max-width: 100%;
      }
    }
  }
}

.edit-btns {
  padding: 10px;
}

.el-tabs--border-card {
  background: #fff;
  border: 1px solid #dcdfe6;
  -webkit-box-shadow: 0 0px 0px 0 rgba(0, 0, 0, 0.12), 0 0 6px 0 rgba(0, 0, 0, 0.04);
  box-shadow: 0 0px 0px 0 rgba(0, 0, 0, 0.12), 0 0 6px 0 rgba(0, 0, 0, 0.04);
}
</style>
