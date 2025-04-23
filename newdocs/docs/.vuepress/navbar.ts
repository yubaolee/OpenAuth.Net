/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 20:26:48
 * @LastEditTime: 2025-04-23 20:51:49
 * @Description: 顶部超链接
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import { defineNavbarConfig } from 'vuepress-theme-plume'

export const navbar = defineNavbarConfig([
  { text: '首页', link: '/' },
  { text: '开源后端', link: '/notes/core/README.md' },
  { text: 'vue3版本', link: '/notes/pro/README.md' },
  { text: 'vue2版本', link: '/notes/vue2/README.md' }
])
