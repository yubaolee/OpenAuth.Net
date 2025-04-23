/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 20:26:48
 * @LastEditTime: 2025-04-24 01:14:49
 * @Description: 顶部超链接
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import { defineNavbarConfig } from 'vuepress-theme-plume'

export const navbar = defineNavbarConfig([
  { text: '文档首页', link: '/', icon: 'material-symbols:home-outline' },
  { text: '开源版文档', link: '/notes/core/README.md', icon: 'logos:opensource' },
  { text: 'vue3版文档', link: '/notes/pro/README.md', icon: 'material-icon-theme:vue' },
  { text: 'vue2版文档', link: '/notes/vue2/README.md', icon: 'material-icon-theme:vue' }
])
