<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:24
 * @LastEditTime: 2025-04-07 21:32:10
 * @Description: 用于渲染模块的按钮，简单用法如下：
 *               <permission-btn size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="filter-items">
    <template v-for="btn of buttons">
      <json-excel :key="btn.Id" v-if="btn.domId === 'btnExport'" :fetch="fetchData" :before-finish="finishDownload"
        class="export-excel-wrapper" :fields="excelInfo.json_fields" :name="excelInfo.excelName">
        <el-button :type="btn.class || 'primary'" size="mini" style="margin-left: 10px;"
          :loading="excelLoading">导出EXCEL</el-button>
      </json-excel>
      <el-button v-else :type="btn.class" :size="size" v-bind:key="btn.Id" class="filter-item"
        @click="$emit('btn-event', btn.domId)"><i :class="`iconfont icon-${btn.icon}`"></i>{{ btn.name }}</el-button>
    </template>

    <el-dropdown v-if="modulePlans.length>0" :size="size" @command="handleCommand">
      <el-button :size="size" type="primary">
        打印<i class="el-icon-arrow-down el-icon--right"></i>
      </el-button>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item v-for="plan in modulePlans" :key="plan.id" :command="plan">{{ plan.name }}</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>

    <el-dropdown v-if="flowschemes.length>0" :size="size" @command="handleFlowschemeCommand">
      <el-button :size="size" type="primary">
        送审<i class="el-icon-arrow-down el-icon--right"></i>
      </el-button>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item v-for="flowscheme in flowschemes" :key="flowscheme.id" :command="flowscheme">{{ flowscheme.schemeName }}</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </div>
</template>

<script>
import waves from '@/directive/waves' // 水波纹指令
import JsonExcel from 'vue-json-excel'
import * as modules from '@/api/modules'
export default {
  name: 'permission-btn',
  components: {
    JsonExcel
  },
  props: {
    size: {
      type: String,
      default: ''
    }
  },
  data() {
    // todo:兼容layui的样式、图标
    return {
      excelInfo: {
        json_fields: {},
        excelName: '',
        data: []
      },
      excelLoading: false,
      buttons: [],
      modulePlans: [],  //模块打印方案
      flowschemes: []  //流程设计方案 
    }
  },
  computed: {},
  directives: {
    waves
  },
  mounted() {
    var route = this.$route
    //直接取当前路由的按钮信息
    var elements = route.meta.elements
    var moduleId = route.meta.moduleId
    //加载模块对应的打印方案
    modules.loadPrinterPlans(moduleId).then(response => {
      this.modulePlans = response.data
    })
     //加载模块对应的送审方案
    modules.loadFlowSchemes(moduleId).then(response => {
      this.flowschemes = response.data
    })
    this.buttons = elements.sort((a, b) => {
      return a.sort - b.sort
    })
  },
  methods: {
    fetchData() {
      if (this.excelLoading) return
      this.excelLoading = true
      this.$emit('btn-event', 'btnExport', (val) => {
        this.excelInfo = { ...val }
      })
      return this.excelInfo.data
    },
    handleCommand(plan) { //处理打印按钮
      this.$emit('btn-event', 'btnPrint',plan)
    },
    handleFlowschemeCommand(flowscheme) { //处理送审按钮
      this.$emit('btn-event', 'btnFlowscheme',flowscheme)
    },
    finishDownload() {
      this.excelLoading = false
    }
  }
}
</script>

<style lang="scss" scoped></style>
