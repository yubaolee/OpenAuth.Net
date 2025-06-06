<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:33
 * @LastEditTime: 2023-12-30 10:55:01
 * @Description: 
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <section class="app-main" ref="appMain">
    <transition name="fade-transform" mode="out-in">
      <keep-alive :include="keepAliveData">
        <router-view :key="key" v-if="$route.meta.keepAlive"></router-view>
      </keep-alive>
    </transition>
    <transition name="fade-transform" mode="out-in">
      <router-view :key="key" v-if="!$route.meta.keepAlive"></router-view>
    </transition>
  </section>
</template>

<script>
export default {
  name: 'AppMain',
  data: () => (
    {
      keepAliveData: []
    }
  ),
  computed: {
    key() {
      return this.$route.fullPath
    }
  },
  watch: {
    $route(to) {
      this.$refs.appMain.scrollTop = 0
      //如果 要 to(进入) 的页面是需要 keepAlive 缓存的，把 code push 进 include数组
      if (to.meta.keepAlive) {
        let code = to.meta.code;
        code && (code = code.replace(code[0],code[0].toLowerCase()))
        code && code !== undefined &&(!this.keepAliveData.includes(code))&& this.keepAliveData.push(code)
      }
    }
  }
}
</script>

<style scoped>
.app-main {
  width: 100%;
  height: calc(100% - 35px);
  position: relative;
  overflow: auto;
  background-color: #efefef;
  box-sizing: border-box;
}
</style>
