/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2025-04-08 09:03:19
 * @Description: 
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import Vue from 'vue'

import 'normalize.css/normalize.css'// A modern alternative to CSS resets

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import '@/assets/custom-theme/index.css'
import locale from 'element-ui/lib/locale/lang/zh-CN' // lang i18n
import VueContextMenu from 'vue-contextmenu'

import '@/styles/index.scss' // global css

import App from './App'
import router from './router'
import store from './store'

import '@/permission' // permission control

import '@/assets/public/css/comIconfont/iconfont.css'
import '@/assets/public/css/comIconfont/iconfont.js'


import '../public/ueditor/ueditor.config.js'
import '../public/ueditor/ueditor.all.js'
import '../public/ueditor/lang/zh-cn/zh-cn.js'
import '../public/ueditor/formdesign/leipi.formdesign.v4.js'

import vform from '@/lib/vform/VFormDesigner.umd.min.js'
import '@/lib/vform/VFormDesigner.css'

// 引入moment
import moment from 'moment'
// 解决axios请求中Date时间少8小时的问题
Date.prototype.toISOString = function(){
    return moment(this).format('YYYY-MM-DDTHH:mm:ssZZ')
}

//HiPrint默认会自动连接本机安装的客户端，如若不需要直接打印功能，或者不自动连接，需要关闭自动连接
import { disAutoConnect } from 'vue-plugin-hiprint'
disAutoConnect();

Vue.use(ElementUI, { locale })
Vue.use(VueContextMenu)
Vue.use(vform)

Vue.config.productionTip = false
Vue.config.devtools = true
new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
