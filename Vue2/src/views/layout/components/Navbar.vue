<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:33
 * @LastEditTime: 2023-12-27 21:57:18
 * @Description: 个人信息
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <el-menu class="navbar" mode="horizontal">
    <div class="logo">
      <img class="user-avatar" :src="logo">OpenAuth.Net Vue2
    </div>
    <hamburger class="hamburger-container" :toggleClick="toggleSideBar" :isActive="sidebar.opened"></hamburger>
    <el-dropdown class="avatar-container" @command="handleCommand" trigger="click">
      <div class="avatar-wrapper">
        欢迎您， {{ name }}
        <el-badge class="mark" :value="msgcount" />
        <i class="el-icon-caret-bottom"></i>
      </div>
      <el-dropdown-menu class="user-dropdown" slot="dropdown">
        <el-dropdown-item command="handleGoProfile">
          <span>个人中心</span>
        </el-dropdown-item>
        <el-dropdown-item>
          <span>切换主题 <el-switch :active-value="1" :inactive-value="0" style="margin-left: 5px;" v-model="theme" /></span>
        </el-dropdown-item>
        <el-dropdown-item command="logout" divided>
          <span>退出</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </el-menu>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Hamburger from '@/components/Hamburger'
import logo from '@/assets/logo.png?imageView2/1/w/80/h/80'
import * as sysMessages from '@/api/sysmessages'

export default {
  data: function () {
    return {
      logo: logo,
      theme: 1,
      msgcount: 0
    }
  },
  components: {
    Hamburger
  },
  computed: {
    ...mapGetters(['sidebar', 'isIdentityAuth', 'name', 'themeStatus'])
  },
  watch: {
    theme() {
      this.toggleClass(document.body, 'custom-theme')
    }
  },
  mounted() {
    this.theme = Number(this.themeStatus)
    this.toggleClass(document.body, 'custom-theme')
    sysMessages.getList({
      page: 1,
      limit: 20,
      status: 999, //999为全部，0为未读，1为已读
      key: undefined
    }).then(response => {
      this.msgcount = response.count
    })
  },
  methods: {
    ...mapActions([
      'signOutOidc',
      'saveTheme'
    ]),
    toggleClass(element, className) {
      if (!element || !className) {
        return
      }
      let classString = element.className
      const nameIndex = classString.indexOf(className)
      if (nameIndex === -1) {
        classString += '' + className
      } else if (this.theme !== 1) {
        classString =
          classString.substr(0, nameIndex) +
          classString.substr(nameIndex + className.length)
      }
      element.className = this.theme === 1 ? classString : ''
      this.saveTheme(this.theme)
    },
    toggleSideBar() {
      this.$store.dispatch('ToggleSideBar')
    },
    logout() {
      if (this.isIdentityAuth) {
        this.signOutOidc()
      } else {
        this.$store.dispatch('LogOut').then(() => {
          location.reload() // 为了重新实例化vue-router对象 避免bug
        })
      }
    },
    handleGoProfile() {
      this.$router.push('/profile')
    },
    handleCommand(name) {
      if (!name) return
      this[name]()
    }
  }
}
</script>

