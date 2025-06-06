<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-03-23 18:36:41
 * @Description: 
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div>
    <el-input @click.native="selectDialog = true" :readonly="true" v-model="names" :placeholder="placeholder"></el-input>
    <el-dialog :destroy-on-close="true" class="dialog-mini custom-dialog user-dialog" width="850px" title="选择用户"
      :visible.sync="selectDialog">
      <!-- 使用v-if的原因：dialog在关闭的时候会执行组件里面的mounted，所以需要关闭dialog时销毁子组件 -->
      <selectUsersCom ref="selectUser" :hiddenFooter="true" v-if="selectDialog" :orgId="orgId" :show.sync="selectDialog"
        :ignore-auth="ignoreAuth" :single ="single" :users.sync="selectUsers" :loginKey="'loginUser'" :userNames.sync="names">
      </selectUsersCom>
      <div slot="footer" style="text-align:right;">
        <el-button size="small" type="cancel" @click="selectDialog = false">取消</el-button>
        <el-button size="small" type="primary" @click="handleSaveUsers">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import selectUsersCom from '@/components/SelectUsersCom'
import * as usersApi from '@/api/users'
export default {
  name: 'select-users',
  components: {
    selectUsersCom
  },
  props: ['users', 'userNames', 'orgId', 'placeholder', 'ignoreAuth', 'single'],
  data() { // todo:兼容layui的样式、图标
    return {
      defaultSelectUsers: this.users,
      names: '', //文本框中显示的用户名
      orgUsers: [],
      orgs: [],
      selectDialog: false
    }
  },
  mounted() {
    this.loadUserNames()
  },
  computed: {
    selectUsers: {
      get() {
        return Array.isArray(this.users) ? this.users: [this.users]
      },
      set(val) {
        this.$emit('users-change', 'users', val)
      }
    },
  },
  watch: {
    userNames() { //监听props属性变化，赋值到本地变量
      this.names = this.userNames
    },
    names() {
      //通知父组件名称变化（通常用于父组件保存临时变量，当两次users没有变化不执行loadUserNames时，能正常显示）
      // if (!this.names && this.names !='') { //本来想加这句减少交互，竟然造成无法更新-_-||
        this.$emit('users-change', 'Texts', this.names)
      // }
    },
    users() {
      this.loadUserNames()
    }
  },
  methods: {
    handleSaveUsers() {
      this.$refs.selectUser.handleSaveUsers()
    },
    loadUserNames() { //通过用户id来加载用户名字
      if (this.userNames && this.userNames!='') {
        this.names = this.userNames
        return;
      }

      if ((this.userNames == undefined || this.userNames=='') && this.users) {
        // 获取用户
        let queryFn = this.ignoreAuth ? usersApi.loadAll : usersApi.getList
        queryFn({
          page: 1,
          limit: 99999
        }).then((response) => {
          this.names = [...response.data].filter((x) => this.selectUsers.indexOf(x.id) > -1).map((item) => item.name)[0]
        })
      }
    }
  }
}
</script>
<style lang="scss">
.el-transfer {
  margin-top: 10px;
}

.user-dialog {
  &.custom-dialog {
    .el-dialog {
      height: 70%;

      .el-icon-close {
        padding-top: 10px;
      }

      .el-dialog__body {
        height: calc(100% - 35px - 40px);
      }

      .el-dialog__headerbtn {
        top: 0;
      }
    }
  }
}
</style>
