/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 20:26:48
 * @LastEditTime: 2025-05-29 15:48:50
 * @Description: 顶部超链接
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import { defineNavbarConfig } from 'vuepress-theme-plume'

export const navbar = defineNavbarConfig([
  { text: '主页', link: 'http://www.openauth.net.cn', icon: 'mdi:home' },
  { text: '文档首页', link: '/', icon: 'mdi:book-open-page-variant' },
  { text: '开源版文档', link: '/notes/core/README.md', icon: 'logos:opensource' },
  { text: 'vue3版文档', link: '/notes/pro/README.md', icon: 'material-icon-theme:vue' },
  { text: 'vue2版文档', link: '/notes/vue2/README.md', icon: 'material-icon-theme:vue' },
  { text: '移动UniApp文档', link: '/notes/mobile/README.md', icon: 'ri:smartphone-line' },
])
