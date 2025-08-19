<template>
  <div class="profile-page">

    <!-- 主内容区 -->
    <div class="profile-main">
      <div class="container">
        <el-row :gutter="20">
          <!-- 左侧用户信息区 -->
          <el-col :span="8">
            <div class="user-info-section">
              <!-- 用户头像卡片 -->
              <div class="user-avatar-card">
                <div class="avatar-container">
                  <div class="user-avatar">
                    <i class="el-icon-user-solid"></i>
                  </div>
                  <div class="user-basic-info">
                    <h3 class="user-name">{{temp.name || temp.account}}</h3>
                    <p class="user-account">@{{temp.account}}</p>
                  </div>
                </div>
              </div>

              <!-- 基本信息编辑卡片 -->
              <div class="info-edit-card">
                <div class="card-header">
                  <h4 class="card-title">基本信息</h4>
                </div>
                <div class="card-content">
                  <el-form :model="temp" label-width="80px" class="user-form">
                    <el-form-item label="账号">
                      <div class="readonly-text">{{temp.account}}</div>
                    </el-form-item>
                    <el-form-item label="姓名">
                      <el-input v-model="temp.name" placeholder="请输入姓名" size="medium"></el-input>
                    </el-form-item>
                    <el-form-item label="性别">
                      <el-radio-group v-model="temp.sex">
                        <el-radio :label="0">男</el-radio>
                        <el-radio :label="1">女</el-radio>
                      </el-radio-group>
                    </el-form-item>
                    <el-form-item>
                      <el-button type="primary" @click="changeProfile" size="medium">
                        保存修改
                      </el-button>
                    </el-form-item>
                  </el-form>
                </div>
              </div>

              <!-- 密码修改卡片 -->
              <div class="password-edit-card">
                <div class="card-header">
                  <h4 class="card-title">修改密码</h4>
                </div>
                <div class="card-content">
                  <el-form label-width="80px" class="user-form">
                    <el-form-item label="新密码">
                      <el-input v-model="newpwd" type="password" placeholder="请输入新密码" size="medium" show-password></el-input>
                    </el-form-item>
                    <el-form-item>
                      <el-button type="warning" @click="changePassword" size="medium">
                        修改密码
                      </el-button>
                    </el-form-item>
                  </el-form>
                </div>
              </div>
            </div>
          </el-col>

          <!-- 右侧功能区 -->
          <el-col :span="16">
            <div class="function-section">
              <el-row :gutter="20">
                <!-- 可访问模块 -->
                <el-col :span="12">
                  <div class="function-card modules-card">
                    <div class="card-header">
                      <h4 class="card-title">
                        <i class="el-icon-menu"></i>
                        可访问模块
                      </h4>
                    </div>
                    <div class="card-content tree-content">
                      <el-tree 
                        :data="modulesTree" 
                        :expand-on-click-node="false" 
                        default-expand-all 
                        :props="orgTreeProps"
                        class="access-tree">
                      </el-tree>
                    </div>
                  </div>
                </el-col>

                <!-- 可访问机构 -->
                <el-col :span="12">
                  <div class="function-card orgs-card">
                    <div class="card-header">
                      <h4 class="card-title">
                        <i class="el-icon-office-building"></i>
                        可访问机构
                      </h4>
                      <span class="card-tips">✅当前默认机构，点击切换</span>
                    </div>
                    <div class="card-content tree-content">
                      <el-tree 
                        :data="orgsTree" 
                        :expand-on-click-node="false" 
                        default-expand-all 
                        :props="orgTreeProps"
                        @node-click="handleNodeClick"
                        class="access-tree clickable-tree">
                      </el-tree>
                    </div>
                  </div>
                </el-col>
              </el-row>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
  import {
    listToTreeSelect
  } from '@/utils'
  import * as login from '@/api/login'
  import * as users from '@/api/users'
  import '@riophae/vue-treeselect/dist/vue-treeselect.css'
  import waves from '@/directive/waves' // 水波纹指令
  import {
    mapGetters
  } from 'vuex'
  import store from '@/store'

  export default {
    name: 'profile',
    components: {},
    directives: {
      waves
    },
    data() {
      return {
        orgTreeProps: { // tree配置项
          children: 'children',
          label: 'label'
        },
        listLoading: true,
        orgs: [], // 用户可访问到的组织列表
        orgsTree: [], // 用户可访问到的所有机构组成的树

        modules: [],
        modulesTree: [], // 用户可访问的所有模块组成的树

        temp: {
          account: '',
          name: '',
          sex: 0
        },
        newpwd: ''
      }
    },
    computed: {
      ...mapGetters(['defaultorgid', 'name'])
    },
    filters: {

    },
    mounted() {
      this.getUserProfile()
      this.getOrgTree()
      this.getModulesTree()
    },
    methods: {
      changeProfile() {
        const _this = this
        users.changeProfile(this.temp).then(response => {
          _this.$message({
            message: response.message,
            type: 'success'
          })
        })
      },

      changePassword() {
        const _this = this
        users.changePassword({
          account: _this.temp.account,
          password: _this.newpwd
        }).then(response => {
          _this.$message({
            message: response.message,
            type: 'success'
          })
        })
      },

      handleNodeClick(data) {
        store.commit('SET_DEFAULTORG', data)
        this.getOrgTree()
      },

      getUserProfile() {
        var _this = this // 记录vuecomponent
        login.getUserProfile().then(response => {
          _this.temp = response.data
        })
      },

      getModulesTree() {
        var _this = this // 记录vuecomponent
        login.getModules().then(response => {
          _this.modules = response.data.map(function(item) {
            return {
              id: item.id,
              label: item.name,
              parentId: item.parentId
            }
          })
          var tmp = JSON.parse(JSON.stringify(_this.modules))
          _this.modulesTree = listToTreeSelect(tmp)
        })
      },

      getOrgTree() {
        var _this = this // 记录vuecomponent
        login.getOrgs().then(response => {
          _this.orgs = response.data.map(function(item) {
            var name = item.name
            if (_this.defaultorgid === item.id) {
              name = name + '✅'
            }
            return {
              id: item.id,
              label: name,
              parentId: item.parentId
            }
          })
          var orgstmp = JSON.parse(JSON.stringify(_this.orgs))
          _this.orgsTree = listToTreeSelect(orgstmp)
        })
      }
    }
  }
</script>

<style scoped>
/* 页面整体样式 */
.profile-page {
  min-height: 100vh;
  background: #f5f5f5;
}

/* 顶部导航 */
.profile-header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px 24px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  font-weight: 500;
  color: #262626;
}

/* 主内容区 */
.profile-main {
  padding: 24px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

/* 左侧用户信息区 */
.user-info-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* 用户头像卡片 */
.user-avatar-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 24px;
  text-align: center;
}

.avatar-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.user-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}

.user-avatar i {
  font-size: 36px;
  color: #fff;
}

.user-name {
  margin: 0 0 8px 0;
  font-size: 20px;
  font-weight: 500;
  color: #262626;
}

.user-account {
  margin: 0;
  font-size: 14px;
  color: #8c8c8c;
}

/* 通用卡片样式 */
.info-edit-card,
.password-edit-card,
.function-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.card-header {
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-title {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
  color: #262626;
}

.card-title i {
  margin-right: 8px;
  color: #1890ff;
}

.card-tips {
  font-size: 12px;
  color: #8c8c8c;
}

.card-content {
  padding: 20px;
}

/* 表单样式 */
.user-form .el-form-item {
  margin-bottom: 20px;
}

.user-form .el-form-item:last-child {
  margin-bottom: 0;
}

.readonly-text {
  color: #8c8c8c;
  background: #fafafa;
  padding: 8px 12px;
  border-radius: 4px;
  font-size: 14px;
}

.user-form .el-input .el-input__inner {
  border-radius: 4px;
  border: 1px solid #d9d9d9;
}

.user-form .el-input .el-input__inner:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.user-form .el-radio {
  margin-right: 16px;
}

.user-form .el-button {
  padding: 8px 20px;
  border-radius: 4px;
  font-weight: 400;
}

/* 右侧功能区 */
.function-section {
  height: 100%;
}

.function-card {
  height: 600px;
  display: flex;
  flex-direction: column;
}

.tree-content {
  flex: 1;
  overflow: hidden;
  padding: 16px 20px 20px;
}

/* 树形组件样式 */
.access-tree {
  height: 100%;
  overflow-y: auto;
}

.access-tree .el-tree-node__content {
  height: auto;
  padding: 6px 0;
  font-size: 14px;
  color: #595959;
}

.access-tree .el-tree-node__content:hover {
  background: #f5f5f5;
}

.clickable-tree .el-tree-node__content {
  cursor: pointer;
}

.clickable-tree .el-tree-node__content:hover {
  background: #e6f7ff;
  color: #1890ff;
}

/* 滚动条样式 */
.access-tree::-webkit-scrollbar {
  width: 6px;
}

.access-tree::-webkit-scrollbar-track {
  background: #f5f5f5;
  border-radius: 3px;
}

.access-tree::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.access-tree::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .container {
    padding: 0 16px;
  }
}

@media (max-width: 768px) {
  .profile-main {
    padding: 16px 0;
  }
  
  .container {
    padding: 0 12px;
  }
  
  .header-content {
    padding: 16px 12px;
  }
  
  .page-title {
    font-size: 20px;
  }
}
</style>
