<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2022-12-15 20:57:58
 * @Description: 左侧菜单导航
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <el-scrollbar wrapClass="scrollbar-wrapper" style="border-right: 1px solid #f5f5f5;">
    <el-menu
      mode="vertical"
      :show-timeout="200"
      :default-active="$route.path"
      :collapse="isCollapse"
      router
      :background-color="themeStatus ? '#304156' : ''"
      :text-color="themeStatus ? '#bfcbd9' : ''"
      :active-text-color="themeStatus ? '#409EFF' : '#409eff'"
    >
      <sidebar-item v-for="route in routes" :key="route.path.replaceAll('/', '_')" :item="route" :base-path="route.path"></sidebar-item>
    </el-menu>
  </el-scrollbar>
</template>

<script>
import { mapGetters } from 'vuex'
import SidebarItem from './SidebarItem'

export default {
  components: { SidebarItem },
  data() {
    return {
      routes: []
    }
  },
  computed: {
    ...mapGetters(['sidebar', 'permission_routers', 'themeStatus']),
    isCollapse() {
      return !this.sidebar.opened
    }
  },
  created() {
    this.permission_routers.length > 0 && this.permission_routers.forEach(item => {
      if(item.name === 'layout'){
        this.routes = item.children.sort((a, b) => a.meta.sortNo - b.meta.sortNo)
      }
    })
  },
}
</script>
