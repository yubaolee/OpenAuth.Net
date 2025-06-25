/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2025-04-23 20:26:48
 * @LastEditTime: 2025-06-25 15:12:53
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
      text: '基础开发',
      collapsed: false,
      items: [
        'start', 'specialist', 'deployapi', 'devnew', 'multidbs', 'multitenant', 'unitwork','sqlsugar', 'entity','dynamicapi', 'datavalidation', 'log', 'identity', 'job', 'cache', 'unittest','changesdk'
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
      text: '其他',
      collapsed: true,
      items: ['changelog', 'routineupdate','faq']
    }
  ],
})

// vue3版本
const proNote = defineNoteConfig({
  dir: 'pro',
  link: '/pro',
  sidebar: [
    '',
    {
      text: '基础开发',
      collapsed: false,
      items: ['start','deploy','structure','multilangs','devnew','devnewmulti', 'router','openurl','keepalive','datapropertyrule']
    },
    {
      text: '内置组件',
      collapsed: false,
      items: ['table','querybuilder','columnsetting','authselect','authform','selectusercom']
    },
    'printerplan',
    {
      text: '表单设计',
      collapsed: true,
      items: ['startform','urlform','dragform','dragformdetail']
    },
    {
      text: '工作流',
      collapsed: true,
      items: ['startflow','form']
    },
    {
      text: '其他',
      collapsed: true,
      items: ['faq']
    }
    
  ]
})

// vue2版本
const vue2Note = defineNoteConfig({
  dir: 'vue2',
  link: '/vue2',
  sidebar: [
    '',
    {
      text: '基础开发',
      collapsed: false,
      items: [  'deploy', 'structure', 'devnew','router','openurl','keepalive']
    },
    'datapropertyrule',
    'printerplan',
    {
      text: '表单设计',
      collapsed: true,
      items: ['startform','dragform','dragformdetail']
    },
    {
      text: '工作流',
      collapsed: true,
      items: ['startflow','form']
    },
    {
      text: '其他',
      collapsed: true,
      items: ['components','faq']
    }
    
  ]
})

// 移动UniApp版本
const mobileNote = defineNoteConfig({
  dir: 'mobile',
  link: '/mobile',
  sidebar: [
    '',
    {
      text: '基础开发',
      collapsed: false,
      items: ['start', 'structure']
    }
  ]
})


export const notes = defineNotesConfig({
  dir: 'notes',
  link: '/',
  notes: [coreNote, proNote, vue2Note, mobileNote],
})
