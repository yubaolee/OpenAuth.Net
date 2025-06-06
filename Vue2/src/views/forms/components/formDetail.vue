<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-02-23 12:16:40
 * @Description: 添加/编辑表单公用界面
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="createPost-container">
    <el-container style="height: 100%">
      <el-header style="padding: 0; height: 42px">
        <sticky :className="'sub-navbar '">
          <div class="filter-container">
            <el-form :inline="true" :model="postForm" :rules="rules" ref="postForm">
              <el-form-item prop="name" label="标题">
                <el-input style="width: 200px" size="mini" name="name" v-model="postForm.name" required> </el-input>
              </el-form-item>

              <el-form-item label="表单类型">
                <el-select size="mini" v-model="postForm.frmType" @change="onFrmTypeChange" placeholder=""
                  style="width: 100%">
                  <el-option label="可拖拽动态表单" :value="2"></el-option>
                  <el-option label="动态表单" :value="0"></el-option>
                  <el-option label="自定义开发页面" :value="1"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item label="系统自定义表单" v-if="postForm.frmType == 1">
                <el-select size="mini" v-model="postForm.webId" v-if="postForm.frmType == 1" @change="onFrmChange"
                  placeholder="请选择系统内置的页面">
                  <el-option label="请假条" value="FrmLeaveReq"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item label="关联数据库表">
                <auth-select :default-props="{ label: 'tableName', value: 'tableName' }" :type="'dynamic'"
                  :data-source="'/BuilderTables/Load'" v-model="postForm.dbName" size="mini"></auth-select>
              </el-form-item>

              <el-form-item label="表单描述">
                <el-input style="width: 300px" size="mini" v-model="postForm.description"> </el-input>
              </el-form-item>

              <el-form-item>
                <el-button v-loading="loading" size="mini" @click="submitForm">保存 </el-button>
              </el-form-item>
            </el-form>
          </div>
        </sticky>
      </el-header>
      <el-main style="padding: 0; height: calc(100% - 42px)">
        <div class="editor-container" style="height: 100%" v-if="postForm.frmType === 0 || postForm.frmType === 2">
          <v-form-designer v-if="postForm.frmType === 2" :designer-config="designerconfig"
            ref="vfDesigner"></v-form-designer>
          <template v-if="postForm.frmType === 0">
            <Ueditor ref="ue" v-bind:content="postForm.content" :formType="postForm.frmType"
              v-bind:fileds="postForm.fields" @ready="ueReady"></Ueditor>
          </template>
        </div>

        <el-card class="box-card" v-if="postForm.frmType == 1">
          <component v-if="userDefineComp" :is="userDefineComp"></component>
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import Ueditor from '@/components/Ueditor'
import Sticky from '@/components/Sticky' // 粘性header组件
import * as forms from '@/api/forms'
import { mapGetters, mapActions } from 'vuex'
import { jump } from '@/utils/jumpRoute'
import AuthSelect from '../../../components/Base/AuthSelect.vue'

const defaultForm = {
  id: undefined,
  description: '',
  webId: '', // 用户开发的页面ID
  frmType: 2, // 表单类型，默认为0动态表单，1为用户开发的页面
  name: '',
  fields: 0, // 字段个数
  delete: 0, // 删除标记
  disabled: 0,
  contentData: '', // 表单中的控件属性描述
  contentParse: '', // 表单控件位置模板
  content: '', // 未处理的HTML
}

export default {
  name: 'form-detail',
  components: {
    Sticky,
    Ueditor,
    AuthSelect,
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
      } else {
        callback()
      }
    }
    return {
      designerconfig: {
        logoHeader: false,
        generateSFCButton: false,
      },
      postForm: Object.assign({}, defaultForm),
      loading: false,
      userDefineComp: null, //用户自定义表单
      rules: {
        name: [
          {
            validator: validateRequire,
            trigger: 'blur',
          },
        ],
      },
    }
  },
  computed: {
    ...mapGetters(['defaultorgid', 'formDetails', 'addFormDetail']),
  },
  beforeDestroy() {
    if (this.postForm.frmType === 0) {
      // 动态表单需要获取ue中的值
      this.postForm = Object.assign(this.postForm, this.$refs.ue.getObj())
    } else if (this.postForm.frmType === 2) {
      this.postForm.contentData = JSON.stringify(this.$refs.vfDesigner.getFormJson())
    }
    if (!this.postForm.id) {
      this.saveAddFormDetails(this.postForm)
      return
    }
    let data = {}
    data[this.postForm.id] = this.postForm
    this.saveFormDetails(data)
  },
  mounted() {
    this.init()
  },

  methods: {
    ...mapActions(['saveFormDetails', 'saveAddFormDetails', 'updateIsRender']),
    init() {
      this.postForm.frmType = this.$route.query['frmType'] !== undefined ? this.$route.query['frmType'] : 2
      if (!this.isEdit) {
        this.postForm = Object.assign({}, this.addFormDetail || defaultForm)
        if (Number(this.postForm.frmType) === 2) {
          //如果是拖动表单，清空画布
          this.$refs.vfDesigner.clearDesigner()
        }
      } else {
        // ueditor需要准备好了调用数据，frmtype为2时，不调用ueditor
        if (Number(this.postForm.frmType) !== 0) {
          const id = this.$route.params && this.$route.params.id
          this.postForm = this.formDetails[id]

          if (Number(this.postForm.frmType) === 2) {
            this.$refs.vfDesigner.clearDesigner()

            if (!this.postForm.contentData.includes('widgetList')) {
              this.$message({
                message: '最新版表单设计不支持v4.4及以前版本的拖动表单，新增个表单试试~~',
                type: 'error',
              })
              return
            }
            // 拖动表单
            let formJson = JSON.parse(this.postForm.contentData)
            this.$refs.vfDesigner.setFormJson(formJson)
          }
        }
      }

      if (Number(this.postForm.frmType) === 1) { //自定义表单
        this.loadUserDefineComp()
      }
    },
    onFrmTypeChange() { //表单类型切换
      if (this.postForm.frmType == 1) {
        this.loadUserDefineComp()
      }
    },
    onFrmChange() { //表单切换
      this.loadUserDefineComp()
    },

    loadUserDefineComp() { //加载用户自定义表单
      if(this.postForm.webId == null || this.postForm.webId==''){
        return;
      }
      let loadComp = () => import(`@/views/forms/userDefine/${this.postForm.webId}/add`)
      loadComp().then(res => {
        this.userDefineComp = res.default
      })
    },

    ueReady() {
      // ueditor准备好了，来数据吧
      if (this.isEdit && !this.postForm.contentData) {
        const id = this.$route.params && this.$route.params.id
        this.fetchData({
          id: id,
        })
      }
    },
    fetchData(id) {
      forms
        .get(id)
        .then((response) => {
          this.postForm = response.result
        })
        .catch((err) => {
          console.log(err)
        })
    },
    submitForm() {
      var _this = this
      if (_this.postForm.frmType === 0) {
        // 动态表单需要获取ue中的值
        _this.postForm = Object.assign(_this.postForm, _this.$refs.ue.getObj())
      } else if (_this.postForm.frmType === 2) {
        let content = _this.$refs.vfDesigner.getFormJson()
        _this.postForm.contentData = JSON.stringify(content)
      }
      _this.$refs.postForm.validate((valid, fields) => {
        if (valid) {
          _this.loading = true
          _this.postForm.OrgId = _this.defaultorgid
          _this.updateIsRender(true)
          if (_this.isEdit) {
            _this.postForm.id = _this.$route.params && _this.$route.params.id
            forms.update(_this.postForm).then(() => {
              _this.loading = false
              _this.$notify({
                title: '成功',
                message: '修改成功',
                type: 'success',
                duration: 2000,
              })

              jump(_this, '/forms/index')
            })
          } else {
            forms.add(_this.postForm).then(() => {
              _this.loading = false
              _this.$notify({
                title: '成功',
                message: '创建成功',
                type: 'success',
                duration: 2000,
              })

              jump(_this, '/forms/index')
            })
          }
        } else {
          _this.loading = false
          _this.$notify({
            title: '异常',
            message: '表单验证失败' + fields,
            type: 'error',
            duration: 2000,
          })
          return false
        }
      })
    },
  },
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import 'src/styles/mixin.scss';

.main-container {
  margin-left: 0px !important;
}

.createPost-container {
  position: relative;
  height: 100%;
  overflow: hidden;
  margin: 0;

  .createPost-main-container {
    margin: 10px;
    background-color: white;
    padding: 10px;
    padding-top: 0;

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
