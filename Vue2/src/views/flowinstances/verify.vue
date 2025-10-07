<!--
 * @description: 流程处理（审批）界面
 * @author: liyubao | xufuxing
 * @version: 1.0
 * @updateDate:2021-07-08 审核时可以根据表单是否只读来修改、提交表单内容
-->
<template>
  <div class="createPost-container">
    <el-card class="box-card" style="text-align: right">
      <el-row>
        <el-col :span="16">
          {{ flowObj.customName }}
          <el-input style="width: 200px" v-model="postObj.verificationOpinion" placeholder="请输入审核意见"></el-input>
          <verify-status v-model="postObj.verificationFinally" />
          <el-select v-model="postObj.NodeRejectType" placeholder="" v-if="postObj.verificationFinally == '3'">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"> </el-option>
          </el-select>
          <el-select v-model="postObj.NodeRejectStep" placeholder=""
            v-if="postObj.NodeRejectType == '2' && postObj.verificationFinally == '3'">
            <el-option v-for="item in FlowNodes" :key="item.id" :label="item.name" :value="item.id"> </el-option>
          </el-select>
        </el-col>
        <el-col :span="6">
          <select-users
            v-if="postObj.verificationFinally == '1' && postObj.NodeDesignateType === 'RUNTIME_SPECIAL_USER'"
            placeholder="*选择下一个节点执行用户" :userNames.sync="postObj.NodeDesignateTxts" :users="postObj.NodeDesignates"
            :ignore-auth="true" v-on:users-change="usersChange">
          </select-users>
          <select-roles
            v-if="postObj.verificationFinally == '1' && postObj.NodeDesignateType === 'RUNTIME_SPECIAL_ROLE'"
            placeholder="*选择下一个节点执行角色" :userNames.sync="postObj.NodeDesignateTxts" :roles="postObj.NodeDesignates"
            :ignore-auth="true" v-on:roles-change="rolesChange">
          </select-roles>
        </el-col>
        <el-col :span="2">
          <el-button v-loading="loading" style="margin-left: 10px" type="success" @click="submitForm">提交 </el-button>
        </el-col>
      </el-row>
    </el-card>
    <!-- 自定义表单 -->
    <el-card class="box-card" v-if="flowObj.frmType == 1">
      <component v-if="userDefineComp" :is="userDefineComp" ref="frmData" :frmData="flowObj.frmData"
        :canWriteFormItemIds="canWriteFormItemIds"></component>
    </el-card>
    <!-- 拖拽表单 -->
    <el-card class="box-card" v-if="flowObj.frmType == 2">
      <div style="padding-right: 25px">
        <v-form-render :form-json="formJson" :form-data="formData" :option-data="optionData" ref="vFormRef">
        </v-form-render>
      </div>
    </el-card>
    <!-- url表单 -->
    <iframe v-if="flowObj.frmType === 3"
      :src="flowObj.frmData.startsWith('http') ? flowObj.frmData : ('/#' + flowObj.frmData)"
      style="width:100%;height:500px;border:none;"></iframe>
    <el-card class="box-card" v-else>
      <!--动态表单渲染-->
      <form ref="frmData">
        <p v-if="canWriteFormItemIds && canWriteFormItemIds.length > 0" v-html="flowObj.frmHtml"></p>
        <div v-else>
          <p v-html="flowObj.frmPreviewHtml"></p>
          <!-- 展示只读的数据，但需要隐藏动态表单，不然提交时没有数据 -->
          <p v-html="flowObj.frmHtml" v-show="false"></p>
        </div>

      </form>
    </el-card>
    <el-card class="box-card">
      <div style="height: 500px">
        <CreatedFlow ref="createdFlow" :form-template="currentForm" :isEdit="true" :isShowContent="isShowContent"
          :scheme-content="flowObj.schemeContent"></CreatedFlow>
      </div>
    </el-card>
  </div>
</template>
<script>
import SelectUsers from '@/components/SelectUsers'
import SelectRoles from '@/components/SelectRoles'
import Sticky from '@/components/Sticky' // 粘性header组件
import VerifyStatus from './Dropdown/VerifyStatus'
import * as apiFlowinstances from '@/api/flowinstances'
import CreatedFlow from '@/components/CreatedFlow'
import { mapActions } from 'vuex'
import { jump } from '@/utils/jumpRoute'
export default {
  name: 'verify-flowinstance',
  components: {
    Sticky,
    VerifyStatus,
    CreatedFlow,
    SelectUsers,
    SelectRoles,
  },
  data() {
    return {
      formJson: {}, //表单中的控件属性描述
      formData: {}, //表单数据
      optionData: {},
      userDefineComp: null, //用户自定义表单
      isShowContent: true,
      currentForm: null,
      loading: false, // 按钮加载loading
      /**
       * 当前实例的所有节点
       */
      FlowNodes: [],
      /**
       * 当前节点可写的表单项Id
       */
      canWriteFormItemIds: [],
      postObj: {
        flowInstanceId: '',
        verificationOpinion: '',
        verificationFinally: 1,
        NodeRejectStep: '',
        NodeRejectType: '0', // 默认上一步
        NodeDesignateType: '', //如果下个执行节点是运行时指定执行者。需要传指定的类型.RUNTIME_SPECIAL_ROLE、RUNTIME_SPECIAL_USER
        NodeDesignates: [], //如果下个执行节点是运行时指定执行者。该值表示具体的执行者
        NodeDesignateTxts: '',
        frmData: '', //表单数据
        frmType: 0,
      },
      options: [
        {
          value: '0',
          label: '上一步',
        },
        {
          value: '1',
          label: '第一步',
        },
        {
          value: '2',
          label: '指定步骤',
        },
      ],
      flowObj: {
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
    }
  },
  created() {
    const id = this.$route.params && this.$route.params.id
    this.postObj.flowInstanceId = id
    apiFlowinstances
      .get({
        id: id,
      })
      .then((response) => {
        this.flowObj = response.data
        if (this.flowObj.frmType === 2) {
          //拖动表单
          if (!response.data.frmContentData.includes('widgetList')) {
            this.$message({
              message: '最新版表单设计不支持v4.4及以前版本的拖动表单，新增个表单试试~~',
              type: 'error',
            })
            return
          }
          this.formJson = JSON.parse(response.data.frmContentData)
          this.formData = JSON.parse(response.data.frmData)
        } else if (this.flowObj.frmType === 1) { //用户自定义表单
          let loadComp = () => import(`@/views/forms/userDefine/${this.flowObj.dbName}/detail`)
          loadComp().then(res => {
            this.userDefineComp = res.default
          })
        }
        this.postObj.frmType = response.data.frmType
        this.postObj.NodeDesignateType = response.data.nextNodeDesignateType //节点的执行权限类型，如执行时选定用户或设计时确定用户
        var nodes = JSON.parse(this.flowObj.schemeContent).nodes
        this.FlowNodes = nodes // 需要过滤条件，应该退回到已经处理过的某个节点
        this.canWriteFormItemIds = response.data.canWriteFormItemIds

        if (this.flowObj.frmType === 2) {
          //控制拖动表单字段读写权限
          this.$nextTick(function () {
            this.$refs.vFormRef.disableForm()
            this.$refs.vFormRef.enableWidgets(this.canWriteFormItemIds)
          })
        }
      })
      .catch((err) => {
        console.log(err)
      })
  },
  methods: {
    ...mapActions(['updateInstancesIsRender']),
    async submitForm() {
      let _this = this
      _this.loading = true

      await _this.updateFrmData()

      apiFlowinstances.verify(this.postObj).then(
        () => {
          _this.loading = false
          _this.updateInstancesIsRender({
            type: '',
            val: true,
          })
          _this.$notify({
            title: '成功',
            message: '执行成功',
            type: 'success',
            duration: 2000,
          })

          jump(this, '/flowInstances/wait')
        },
        () => {
          _this.loading = false
        }
      )
    },
    /**
     * 更新表单内容
     */
    async updateFrmData() {

      let _this = this

      if (_this.postObj.frmType === 1) {
        // 使用的是自定义的页面提交
        _this.postObj.frmData = JSON.stringify(_this.$refs.frmData.getData())
      } else if (_this.postObj.frmType === 0) {
        // 动态表单
        const frmdata = {}
        for (let i = 0; i < _this.$refs.frmData.elements.length; i++) {
          frmdata[_this.$refs.frmData[i].name] = _this.$refs.frmData[i].value
        }
        _this.postObj.frmData = JSON.stringify(frmdata)
      } else if (_this.postObj.frmType === 2) {
        var frmdata = await _this.$refs.vFormRef.getFormData()
        _this.postObj.frmData = JSON.stringify(frmdata)

        return
      } else {
        //URL表单暂时没有获取数据的方式
      }
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
<style rel="stylesheet/scss" lang="scss" scoped>
@import 'src/styles/mixin.scss';

.createPost-container {
  position: relative;

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
