/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 20:26:48
 * @LastEditTime: 2025-04-23 23:30:36
 * @Description: 笔记配置
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import { defineNoteConfig, defineNotesConfig } from 'vuepress-theme-plume'

//开源后端文档
const coreNote = defineNoteConfig({
  dir: 'core',
  link: '/core',
  sidebar: [
    '',
    {
      text: '基础功能',
      collapsed: false,
      items: [
        'start', 'specialist', 'deploy', 'deployapi', 'devnew', 'multidbs', 'multitenant', 'unitwork','sqlsugar', 'entity','dynamicapi', 'datavalidation', 'log', 'identity', 'job', 'cache', 'unittest','changesdk'
      ]
    },
    {
      text: '权限控制',
      collapsed: true,
      items: [
        'moduleauth','apiauth', 'logininfo', 'dataprivilege', 'datapropertyrule'
      ]
    },
    {
      text: '工作流',
      collapsed: true,
      items: ['form','flowinstance','flowinstanceconcept','flowinstancedev', 'thirdparty' ]
    },
    {
      text: '前端开发',
      collapsed: true,
      items: ['wwwarchitect']
    },
    {
      text: '其他',
      collapsed: true,
      items: ['changelog', 'routineupdate','faq']
    }
  ],
})

export const notes = defineNotesConfig({
  dir: 'notes',
  link: '/',
  notes: [coreNote],
})
