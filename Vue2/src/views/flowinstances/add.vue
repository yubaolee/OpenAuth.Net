<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-02-23 11:23:00
 * @Description: 发起流程实例
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div>
    <sticky :className="'sub-navbar '">
      <el-button v-if="active > 0" size="mini" style="margin-left: 10px" type="primary" @click="pre">上一步</el-button>
      <el-button v-if="active < 1" size="mini" style="margin-left: 10px" @click="next">下一步</el-button>
      <el-button v-loading="loading" size="mini" style="margin-left: 10px" type="success" @click="submitForm">保存 </el-button>
    </sticky>
    <div class="createPost-container">
      <el-form class="form-container" :model="postObj" :rules="rules" ref="postObj">
        <el-steps class="steps" :active="active" finish-status="success">
          <el-step title="选择模板"></el-step>
          <el-step title="基础信息"></el-step>
        </el-steps>
        <!--选择模板-->
        <div class="createPost-main-container" v-show="active == 0">
          <el-form-item label=" ">
            <el-select style="width: 400px" v-model="currentSchemeId" size="small" placeholder="请选择">
              <el-option v-for="item in flowschemes" :key="item.id" :label="item.schemeName" :value="item.id"> </el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="选择下一个节点执行用户" v-if="postObj.NodeDesignateType === 'RUNTIME_SPECIAL_USER'">
            <select-users placeholder="*选择下一个节点执行用户" :userNames.sync="postObj.NodeDesignateTxts" :users="postObj.NodeDesignates" :ignore-auth="true" v-on:users-change="usersChange">
            </select-users>
          </el-form-item>

          <el-form-item label="选择下一个节点执行角色" v-if="postObj.NodeDesignateType === 'RUNTIME_SPECIAL_ROLE'">
            <select-roles placeholder="*选择下一个节点执行角色" :userNames.sync="postObj.NodeDesignateTxts" :roles="postObj.NodeDesignates" :ignore-auth="true" v-on:roles-change="rolesChange">
            </select-roles>
          </el-form-item>

          <div class="flow-form-content">
            <el-card class="box-card" v-if="postObj.frmType == 1">
              <component v-if="userDefineComp" :is="userDefineComp" ref="frmData" :canWriteFormItemIds="canWriteFormItemIds"></component>
            </el-card>
            <template v-else-if="postObj.frmType === 2">
              <v-form-render v-if="reLoadVform" :form-json="formJson" :form-data="formData" :option-data="optionData" ref="vFormRef"> </v-form-render>
            </template>
            <form ref="frmData" v-else>
              <p v-html="frmPreview"></p>
            </form>
          </div>
          <div class="flow-form-content" style="height: 500px">
            <CreatedFlow ref="createdFlow" :form-template="currentForm" :isEdit="true" :isShowContent="isShowContent" :scheme-content="currentScheme.schemeContent"></CreatedFlow>
          </div>
        </div>
        <!--编辑基础信息-->
        <div class="createPost-main-container" v-show="active == 1">
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
                <el-date-picker v-model="postObj.createDate" type="datetime" format="yyyy-MM-dd HH:mm:ss" placeholder="选择日期时间"> </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label-width="100px" label="重要性(占位):" class="postInfo-container-item">
                <el-rate style="margin-top: 8px" :max="3" :colors="['#99A9BF', '#F7BA2A', '#FF9900']" :low-threshold="1" :high-threshold="3"> </el-rate>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label-width="100px" label="摘要:">
                <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="postObj.description"> </el-input>
                <span class="word-counter" v-if="contentShortLength">{{ contentShortLength }}字</span>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
      </el-form>
    </div>
  </div>
</template>
<script>
import { formatTime } from '@/utils/index'
import Sticky from '@/components/Sticky' // 粘性header组件
import * as apiFlowschemes from '@/api/flowschemes'
import * as apiFlowinstances from '@/api/flowinstances'
import * as apiForms from '@/api/forms'
import CreatedFlow from '@/components/CreatedFlow'
import { mapGetters, mapActions } from 'vuex'
import SelectUsers from '@/components/SelectUsers'
import SelectRoles from '@/components/SelectRoles'

import { jump } from '@/utils/jumpRoute'
export default {
  name: 'flowinstanceAdd',
  components: {
    Sticky,
    CreatedFlow,
    SelectUsers,
    SelectRoles,
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
      userDefineComp: null, //用户自定义表单
      isShowContent: true,
      currentForm: null,
      reLoadVform: false,  //重新加载vform组件，可以触发onCreated等事件
      /**
       * 开始节点可写的表单项Id
       */
      canWriteFormItemIds: [],
      postObj: {
        id: undefined,
        code: new Date().getTime(),
        dbName: '', // 关联的数据库名
        frmType: 0, // 表单类型 0：默认动态表单，1：用户自定义页面
        description: '',
        customName: '',
        frmData: '',
        schemeId: '',
        NodeDesignateType: '', //如果下个执行节点是运行时指定执行者。需要传指定的类型.RUNTIME_SPECIAL_ROLE、RUNTIME_SPECIAL_USER
        NodeDesignates: [], //如果下个执行节点是运行时指定执行者。该值表示具体的执行者
        NodeDesignateTxts: '', //选中执行者显示的文本
      },
      loading: false,
      flowschemes: [], // 选择的流程模板列表
      fields: 0, // 表单数据元素个数
      currentSchemeId: '',
      currentScheme: {
        schemeContent: '',
      }, // 当前选中的流程模板
      frmPreview: '',
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
  watch: {
    currentSchemeId(id) {
      this.currentScheme.schemeContent = ''
      this.onSchemeChange(id)
    },
  },
  computed: {
    ...mapGetters(['defaultorgid']),
    contentShortLength() {
      return this.postObj.description ? this.postObj.description.length : 0
    },
  },
  created() {
    apiFlowschemes.getList().then((response) => {
      // 获取模板列表
      this.flowschemes = response.data
      // 初始化值
      this.currentSchemeId = this.flowschemes[0].id
    })
  },
  methods: {
    ...mapActions(['updateInstancesIsRender']),
    next() {
      if (this.active++ > 1) this.active = 0
    },
    pre() {
      if (this.active-- < 0) this.active = 0
    },
    onSchemeChange(schemeId) {
      // 预览表单和流程
      var _this = this
      this.currentScheme = Object.assign(
        {},
        this.flowschemes.find((u) => u.id === schemeId)
      )
      this.postObj.customName = this.currentScheme.schemeName + formatTime('yyyy-MM-dd hh:mm:ss')
      this.postObj.schemeId = schemeId
      var schemeContent = JSON.parse(this.currentScheme.schemeContent)

      //判定开始节点可编辑的表单项内容
      var startNode = schemeContent.nodes.find((i) => i.id.indexOf('start') > -1)
      this.canWriteFormItemIds = startNode.setInfo.CanWriteFormItemIds

      //需要判定开始节点的下一个节点是否为执行时选定执行人
      var startline = schemeContent.lines.find((i) => i.from.indexOf('start') > -1)
      var startNextNode = schemeContent.nodes.find((i) => i.id == startline.to)
      if (startNextNode && startNextNode.setInfo) {
        _this.postObj.NodeDesignateType = startNextNode.setInfo.NodeDesignate
      }
      apiForms
        .get({
          id: this.currentScheme.frmId,
          canWriteFormItemIds: JSON.stringify(_this.canWriteFormItemIds),
        })
        .then((response) => {
          if (response.data.frmType === 1) {
            // 用户自定义的页面,即Vue组件
            _this.postObj.frmType = 1
            _this.postObj.dbName = response.data.webId
            let loadComp = () => import(`@/views/forms/userDefine/${this.postObj.dbName}/add`)
            loadComp().then(res => {
              _this.userDefineComp = res.default
            })

          } else if (response.data.frmType === 2) {
            _this.reLoadVform = false;
            // 拖拽界面
            _this.postObj.frmType = 2
            _this.postObj.dbName = ''
            response.data.html = response.data.content // 暂无用content替代一下html

            //拖动表单
            if (!response.data.contentData.includes('widgetList')) {
              this.$message({
                message: '最新版表单设计不支持v4.4及以前版本的拖动表单，新增个表单试试~~',
                type: 'error',
              })
              return
            }

            this.formJson = JSON.parse(response.data.contentData)
            this.$nextTick(()=>{
              _this.reLoadVform = true;
              _this.$nextTick(()=>{
                _this.$refs.vFormRef.setFormJson(_this.formJson)
              })
            })

            //读写权限控制
            if (response.data.canWriteFormItemIds && response.data.canWriteFormItemIds.length > 0) {
              _this.$nextTick(function () {
                _this.$refs.vFormRef.disableForm()
                _this.$refs.vFormRef.enableWidgets(response.data.canWriteFormItemIds)
              })
            }

            _this.frmPreview = response.data.html // 表单预览的数据
            _this.fields = response.data.fields // 表单属性的个数
          } else {
            _this.postObj.frmType = 0
            _this.postObj.dbName = ''
            _this.frmPreview = response.data.htmlWithCanWriteIds // 表单预览的数据
            _this.fields = response.data.fields // 表单属性的个数
          }
        })
    },
    handleAdd() {
      const _this = this
      _this.postObj.OrgId = this.defaultorgid
      apiFlowinstances.add(_this.postObj).then(() => {
        _this.loading = false
        _this.updateInstancesIsRender({
          type: '',
          val: true,
        })
        _this.$notify({
          title: '成功',
          message: '创建成功',
          type: 'success',
          duration: 2000,
        })

        jump(_this, '/flowInstances/Index')
      })
      _this.loading = false
    },
    submitForm() {
      var _this = this
      _this.$refs.postObj.validate((valid) => {
        if (valid) {
          _this.loading = true
          if (_this.postObj.schemeContent === '') {
            _this.$message({
              message: '请选择一个流程模板',
              type: 'error',
            })
            _this.loading = false
            return
          }
          if (_this.postObj.frmType === 1) {
            // 使用的是自定义的页面提交
            _this.postObj.frmData = JSON.stringify(_this.$refs.frmData.getData())
          } else if (_this.postObj.frmType === 0) {
            // 解析表单中提交的数据
            const frmdata = {}
            for (let i = 0; i < _this.$refs.frmData.elements.length; i++) {
              frmdata[_this.$refs.frmData[i].name] = _this.$refs.frmData[i].value
            }
            _this.postObj.frmData = JSON.stringify(frmdata)
          } else {
            _this.$refs.vFormRef
              .getFormData()
              .then((res) => {
                _this.postObj.frmData = JSON.stringify(res)
                _this.handleAdd()
              })
              .catch(() => {
                _this.loading = false
              })
            return
          }
          _this.handleAdd()
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    usersChange(name, val) {
      if (name == 'users') {
        //用户数据发生改动
        this.postObj.NodeDesignates = val
      } else {
        this.postObj.NodeDesignateTxts = val
      }
    },
    rolesChange(name, val) {
      // 可执行角色
      if (name == 'roles') {
        //角色发生改变
        this.postObj.NodeDesignates = val
      } else {
        this.postObj.NodeDesignateTxts = val
      }
    },
  },
}
</script>
<style rel="stylesheet/scss" lang="scss">
@import 'src/styles/mixin.scss';

iframe {
  border: 0;
}

.createPost-container {
  margin: 10px;
  padding: 10px;
  background-color: white;
  min-height: 100%;

  .createPost-main-container {
    max-width: 1000px;
    margin: 0 auto;
    margin-top: 40px;
  }
}

.steps {
  max-width: 1000px;
  margin: 0 auto;

  .el-step__main {
    margin-left: -21px;
  }
}

.edit-btns {
  padding: 20px;
}

.el-tabs--border-card {
  border: 1px solid #dcdfe6;
  -webkit-box-shadow: 0 0px 0px 0 rgba(0, 0, 0, 0.12), 0 0 0px 0 rgba(0, 0, 0, 0.04);
  box-shadow: 0 0px 0px 0 rgba(0, 0, 0, 0.12), 0 0 0px 0 rgba(0, 0, 0, 0.04);
}

.el-tabs--border-card.border-b-none {
  border-bottom: 0 !important;
}

.editor {
  padding: 15px;
  border: 1px solid #dcdfe6;
  border-top: 0;
}

.flow-form-content {
  margin-top: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 10px;
}
</style>
