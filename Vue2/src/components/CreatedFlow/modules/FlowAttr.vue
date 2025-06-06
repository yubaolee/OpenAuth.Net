<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:18
 * @LastEditTime: 2025-04-20 12:26:07
 * @Description: 流程设计右侧属性列
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div style="height: 100%" class="flow-attr-box">
    <el-tabs size="small" :value="activeKey" style="height: 100%">
      <el-tab-pane name="node-attr" disabled>
        <span slot="label">
          <i class="el-icon-notebook-2" />
          节点属性
        </span>
        <template v-if="currentSelect && currentSelect.id">
          <el-form :rules="rules" ref="dataForm" :model="currentSelect" :label-position="'left'" label-width="100px">
            <el-divider><el-input size="small" style="width:200px" v-model="currentSelect.id" :disabled="true">
              </el-input></el-divider>

            <el-form-item size="small" :label="'名称'" prop="name">
              <el-input v-model="currentSelect.name"></el-input>
            </el-form-item>
            <template v-if="currentSelect.setInfo">

              <el-form-item size="small" :label="'网关/会签类型'"
                v-if="currentSelect.type == 'multiInstance' || currentSelect.type == 'fork'" prop="NodeConfluenceType">
                <el-select class="filter-item" style="width: 100%" v-model="currentSelect.setInfo.NodeConfluenceType"
                  placeholder="请选择" :popper-append-to-body="false">
                  <el-option v-for="item in MultiInstanceTypes" :key="item.id" :label="item.name"
                    :value="item.id"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item size="small" :label="'执行权限'" prop="NodeDesignate">
                <el-select class="filter-item" style="width: 100%" v-model="currentSelect.setInfo.NodeDesignate"
                  placeholder="请选择" @change="handleChangeRoles" :popper-append-to-body="false">
                  <el-option v-for="item in NodeDesignates" :key="item.id" :label="item.name"
                    :value="item.id"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item size="small" :label="'指定用户'" v-if="currentSelect.setInfo.NodeDesignate === 'SPECIAL_USER'"
                prop="NodeDesignateUsers">
                <select-users :userNames.sync="currentSelect.setInfo.NodeDesignateData.Texts"
                  :users="currentSelect.setInfo.NodeDesignateData.datas" :ignore-auth="true"
                  v-on:users-change="dataChange"></select-users>
              </el-form-item>

              <el-form-item size="small" :label="'指定角色'" v-if="currentSelect.setInfo.NodeDesignate === 'SPECIAL_ROLE'"
                prop="NodeDesignateUsers">
                <select-roles :userNames.sync="currentSelect.setInfo.NodeDesignateData.Texts"
                  :roles="currentSelect.setInfo.NodeDesignateData.datas" :ignore-auth="true"
                  v-on:roles-change="dataChange"></select-roles>
              </el-form-item>

              <el-form-item size="small" :label="'SQL'" v-if="currentSelect.setInfo.NodeDesignate === 'SPECIAL_SQL'">
                <el-input v-model="selSql" @change="sqlChange" type="textarea" :rows="5"></el-input>
                <div class="sql-tags-tip">
                  <div class="tip-content">
                    <i class="el-icon-mouse"></i>
                    <span>点击标签可快速插入，当流程运行时，会将标签自动替换成对应登录人的信息</span>
                  </div>
                </div>
                <div class="sql-tags-container">
                  <el-tag v-for="tag in sqltags" :key="tag.columnName" @click="handleTagClick(tag)" class="sql-tag"
                    effect="plain" size="small">
                    {{ tag.remark }}
                  </el-tag>
                </div>
              </el-form-item>

              <el-form-item size="small" :label="'多级主管审批终点'"
                v-if="currentSelect.setInfo.NodeDesignate === 'RUNTIME_MANY_PARENTS'" prop="NodeDesignateUsers">
                <select-roles :userNames.sync="currentSelect.setInfo.NodeDesignateData.Texts"
                  :roles="currentSelect.setInfo.NodeDesignateData.datas" :ignore-auth="true"
                  v-on:roles-change="dataChange"></select-roles>
              </el-form-item>

              <el-form-item size="small" :label="'所属部门'"
                v-if="currentSelect.setInfo.NodeDesignate === 'RUNTIME_CHAIRMAN'" prop="NodeDesignateUsers">
                <treeselect v-if="currentSelect.setInfo.NodeDesignate === 'RUNTIME_CHAIRMAN'" :options="orgsTree"
                  :default-expand-level="3" :multiple="true" :flat="true" :open-on-click="true" :open-on-focus="true"
                  :clear-on-select="true" v-model="currentSelect.setInfo.NodeDesignateData.datas">
                </treeselect>

              </el-form-item>

              <el-form-item size="small" :label="'可编辑字段'" prop="CanWriteFormItemIds">
                <el-select multiple class="filter-item" style="width: 100%"
                  v-model="currentSelect.setInfo.CanWriteFormItemIds" placeholder="请选择" :popper-append-to-body="false">
                  <el-option v-for="item in formTemplate" :key="item.name" :label="item.title"
                    :value="item.name"></el-option>
                </el-select>
              </el-form-item>

              <el-form-item size="small" :label="'回调URL'" prop="ThirdPartyUrl">
                <el-input v-model="currentSelect.setInfo.ThirdPartyUrl"></el-input>
              </el-form-item>


            </template>
          </el-form>
        </template>
      </el-tab-pane>
      <el-tab-pane name="link-attr" disabled>
        <span slot="label">
          <i class="el-icon-share" />
          连线属性
        </span>
        <el-form :label-position="'left'" label-width="70px">
          <el-divider><el-input size="small" style="width:200px" v-model="currentSelect.id" :disabled="true">
            </el-input></el-divider>
          <el-form-item size="small" label="源节点" :label-col="formItemLayout.labelCol"
            :wrapper-col="formItemLayout.wrapperCol">
            <el-input :value="currentSelect.from" disabled />
          </el-form-item>
          <el-form-item size="small" label="目标节点" :label-col="formItemLayout.labelCol"
            :wrapper-col="formItemLayout.wrapperCol">
            <el-input :value="currentSelect.to" disabled />
          </el-form-item>
          <el-form-item size="small" label="文本" :label-col="formItemLayout.labelCol"
            :wrapper-col="formItemLayout.wrapperCol">
            <el-input v-model="currentSelect.label" @change="linkLabelChange" />
          </el-form-item>

          <el-divider>设置分支条件</el-divider>

          <el-row v-for="(compare, index) in Compares" :key="index">
            <el-col :span="8">
              <el-select size="mini" :popper-append-to-body="false" v-model="compare.FieldName" style="width: 85px"
                placeholder="请选择">
                <el-option v-for="item in formTemplate" :key="item.name" :label="item.title"
                  :value="item.name"></el-option>
              </el-select>
            </el-col>
            <el-col :span="6">
              <el-select size="mini" :popper-append-to-body="false" :disabled="!compare.FieldName"
                v-model="compare.Operation" style="width: 65px" placeholder="请选择">
                <el-option label=">" value=">"></el-option>
                <el-option label=">=" value=">="></el-option>
                <el-option label="<" value="<"></el-option>
                <el-option label="<=" value="<="></el-option>
                <el-option label="=" value="="></el-option>
                <el-option label="!=" value="!="></el-option>
              </el-select>
            </el-col>
            <el-col :span="6">
              <el-input size="mini" v-model="compare.Value" style="width: 60px" :disabled="!compare.FieldName"
                placeholder="值"></el-input>
            </el-col>
            <el-col :span="4">
              <el-button type="primary" size="mini" icon="el-icon-plus" v-if="index === 0" title="并且"
                @click="btnAddCompare"></el-button>
              <el-button type="danger" size="mini" icon="el-icon-delete" v-if="index != 0" title="删除"
                @click="btnDelCompare(index)"></el-button>
            </el-col>
          </el-row>
        </el-form>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
// import jsplumb from 'jsplumb'
import SelectUsers from '@/components/SelectUsers'
import SelectRoles from '@/components/SelectRoles'
import * as login from '@/api/login'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import {
  listToTreeSelect
} from '@/utils'
import { mapGetters, mapActions } from 'vuex'

export default {
  props: ['plumb', 'flowData', 'formTemplate'],
  components: {
    // jsplumb,
    SelectUsers,
    SelectRoles,
    Treeselect
  },
  data() {
    return {
      selSql: '', // 运行时SQL
      orgsTree: [], // 用户可访问到的所有机构组成的树
      currentSelect: '',
      Compares: '',
      flag: false,
      formItemLayout: {
        labelCol: {
          span: 6,
        },
        wrapperCol: {
          span: 10,
        },
      },
      MultiInstanceTypes: [],
      NodeDesignates: [],
      NodeRejectTypes: [
        {
          id: '0',
          name: '前一步',
        },
        {
          id: '1',
          name: '第一步',
        },
        {
          id: '2',
          name: '某一步',
        },
        {
          id: '3',
          name: '用户指定',
        },
        {
          id: '4',
          name: '不处理',
        },
      ],
      //预设的sql标签
      sqltags: [
        {
          remark: '{当前登录用户的角色}',
          columnName: '{loginRole}',
        },
        {
          remark: '{当前登录的用户}',
          columnName: '{loginUser}',
        },
        {
          remark: '{当前登录用户的部门}',
          columnName: '{loginOrg}',
        },
      ],
      rules: {
        name: [
          {
            required: true,
            message: '名称不能为空',
            trigger: 'blur',
          },
        ],
      },
      activeKey: 'node-attr',
    }
  },
  computed: {
    ...mapGetters({
      currentSelectData: 'currentSelect',
    }),
  },
  mounted() {
    this.currentSelect = Object.assign({}, this.currentSelectData)
    if (this.currentSelect.setInfo.NodeDesignate === 'SPECIAL_SQL') {
      this.selSql = this.currentSelect.setInfo.NodeDesignateData.datas[0]
    }
    this.Compares = this.currentSelect.Compares
    this.changeAttrType()
    var _this = this // 记录vuecomponent
    login.getOrgs().then(response => {
      _this.orgs = response.result.map(function (item) {
        return {
          id: item.id,
          label: item.name,
          parentId: item.parentId || null
        }
      })
      var orgstmp = JSON.parse(JSON.stringify(_this.orgs))
      _this.orgsTree = listToTreeSelect(orgstmp)
    })
  },
  methods: {
    ...mapActions({
      saveCurrentSelect: 'saveCurrentSelect',
    }),
    nodeNameChange(e) {
      this.currentSelect.name = e.target.value
    },
    btnAddCompare() {
      this.Compares.push({
        FieldName: '',
        Operation: '',
        Value: '',
      })
    },
    handleTagClick(tag) {
      this.selSql += ' ' + tag.columnName
      this.sqlChange()
    },
    btnDelCompare(e) {
      this.Compares.splice(e, 1)
    },
    linkLabelChange(value) {
      const that = this
      const label = value

      that.currentSelect.label = label
      const conn = that.plumb.getConnections({
        source: that.currentSelect.from,
        target: that.currentSelect.to,
      })[0]
      if (label !== '') {
        conn.setLabel({
          label: label,
          cssClass: 'linkLabel',
        })
      } else {
        const labelOverlay = conn.getLabelOverlay()
        if (labelOverlay) conn.removeOverlay(labelOverlay.id)
      }
    },
    sqlChange(val) {
      this.currentSelect.setInfo.NodeDesignateData.datas[0] = val
    },
    dataChange(name, val) {
      if (name !== 'Texts') {
        this.currentSelect.setInfo.NodeDesignateData.datas = val
      } else {
        this.currentSelect.setInfo.NodeDesignateData.Texts = val
      }
    },

    handleChangeRoles() {
      this.currentSelect.setInfo.NodeDesignateData.Texts = ''
      this.currentSelect.setInfo.NodeDesignateData.datas = []
    },
    changeAttrType() {
      if (this.currentSelectData.type === 'sl') {
        this.activeKey = 'link-attr'
      } else {
        this.activeKey = 'node-attr'
      }
    }
  },
  watch: {
    currentSelectData: {
      deep: true,
      handler(val) {
        if (this.flag) {
          this.flag = false
          return
        }
        this.currentSelect = Object.assign(
          {},
          {
            ...val,
          }
        )
        this.changeAttrType();
      },
    },
    currentSelect: {
      handler(val) {
        this.Compares = val.Compares
        this.saveCurrentSelect(val)
        this.flag = true

        if (val.type == 'multiInstance') { //如果是会签节点，则只显示指定角色和指定用户
          this.NodeDesignates = [
            {
              id: 'SPECIAL_ROLE',
              name: '指定角色',
            },
            {
              id: 'SPECIAL_USER',
              name: '指定用户',
            },
            {
              id: 'SPECIAL_SQL',
              name: '指定SQL',
            }
          ]
          this.MultiInstanceTypes = [  //会签比网关多一个依次的类型
            {
              id: 'sequential',
              name: '依次',
            },
            {
              id: 'all',
              name: '全部通过',
            },
            {
              id: 'one',
              name: '至少一个通过',
            },
          ]
        } else {
          this.MultiInstanceTypes = [
            {
              id: 'all',
              name: '全部通过',
            },
            {
              id: 'one',
              name: '至少一个通过',
            }
          ]

          if (val.type == 'fork' || val.type == 'join') { //网关只能指定所有人
            this.NodeDesignates = [
              {
                id: 'ALL_USER',
                name: '所有人',
              }
            ]
          } else {
            this.NodeDesignates = [
              {
                id: 'ALL_USER',
                name: '所有人',
              },
              {
                id: 'SPECIAL_ROLE',
                name: '指定角色',
              },
              {
                id: 'SPECIAL_USER',
                name: '指定用户',
              },
              {
                id: 'SPECIAL_SQL',
                name: '指定SQL',
              },
              {
                id: 'RUNTIME_PARENT',
                name: '上一节点执行人的直属上级',
              },
              {
                id: 'RUNTIME_MANY_PARENTS',
                name: '连续多级直属上级',
              },
              {
                id: 'RUNTIME_CHAIRMAN',
                name: '部门负责人',
              },
              {
                id: 'RUNTIME_SPECIAL_ROLE',
                name: '运行时选定角色',
              },
              {
                id: 'RUNTIME_SPECIAL_USER',
                name: '运行时选定用户',
              }
            ]
          }
        }
      },
      deep: true,
    },
  },
}
</script>

<style lang="scss">
@import '../style/flow-attr.scss';

.flow-attr-box {
  .el-tabs__header {
    margin-bottom: 0;
  }

  .el-tabs__item.is-active {
    color: #409eff !important;
  }

  .el-tabs__item.is-disabled {
    color: #333;
  }

  .el-tabs__content {
    height: calc(100% - 40px);
    overflow: auto;
    padding: 0 10px;
  }

  .sql-tags-tip {
    margin: 10px 0;
    padding: 8px;
    background-color: #f4f4f5;
    border-radius: 4px;


    .tip-content {
      display: flex;
      align-items: center;

      i {
        color: #909399;
        margin-right: 5px;
      }

      span {
        color: #606266;
        font-size: 12px;
      }
    }
  }

  .sql-tags-container {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 8px;

    .sql-tag {
      cursor: pointer;
      transition: all 0.3s;

      &:hover {
        background-color: #ecf5ff;
        color: #409eff;
      }
    }
  }
}
</style>
