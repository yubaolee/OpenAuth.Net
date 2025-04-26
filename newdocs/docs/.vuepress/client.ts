/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 23:37:29
 * @LastEditTime: 2025-04-26 15:00:36
 * @Description: 
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import { defineClientConfig } from 'vuepress/client'
import { h } from 'vue'
import { Layout } from 'vuepress-theme-plume/client'
// import RepoCard from 'vuepress-theme-plume/features/RepoCard.vue'
// import NpmBadge from 'vuepress-theme-plume/features/NpmBadge.vue'
// import NpmBadgeGroup from 'vuepress-theme-plume/features/NpmBadgeGroup.vue'
// import Swiper from 'vuepress-theme-plume/features/Swiper.vue'

// import CustomComponent from './theme/components/Custom.vue'

// import './theme/styles/custom.css'
import AsideNav from './theme/components/AsideNav.vue'


export default defineClientConfig({
  setup() {
    // setupThemeColors()
  },
  layouts: {
    Layout: h(Layout, null, {
      'aside-outline-after': () => h(AsideNav),
    }),
  },
})
