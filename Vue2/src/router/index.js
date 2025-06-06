/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:27
 * @LastEditTime: 2025-04-07 23:05:29
 * @Description: 固定路由列表
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved.
 */
import Vue from 'vue'
import Router from 'vue-router'
import OidcCallback from '@/views/OidcCallback'
import oidcRedirect from '@/views/OidcRedirect'
import DetailWmsInboundOrderTbls from '@/views/wmsinboundordertbls/detail'
// in development-env not use lazy-loading, because lazy-loading too many pages will cause webpack hot update too slow. so only in production use lazy-loading;
// detail: https://panjiachen.github.io/vue-element-admin-site/#/lazy-loading
Vue.use(Router)
/* Layout */
import Layout from '../views/layout/Layout'
/**
* hidden: true                   if `hidden:true` will not show in the sidebar(default is false)
* alwaysShow: true               if set true, will always show the root menu, whatever its child routes length
*                                if not set alwaysShow, only more than one route under the children
*                                it will becomes nested mode, otherwise not show the root menu
* redirect: noredirect           if `redirect:noredirect` will no redirct in the breadcrumb
* name:'router-name'             the name is used by <keep-alive> (must set!!!)
* meta : {
    title: 'title'               the name show in submenu and breadcrumb (recommend set)
    icon: 'svg-name'             the icon show in the sidebar,
  }
**/
export const constantRouterMap = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    meta: {
      sortNo: 0,
    },
    hidden: true,
  },
  {
    path: '/404',
    component: () => import('@/views/errorPage/404'),
    meta: {
      sortNo: 0,
    },
    hidden: true,
  },
  {
    path: '/401',
    component: () => import('@/views/errorPage/401'),
    meta: {
      sortNo: 0,
    },
    hidden: true,
  },
  {
    path: '/forms',
    component: Layout,
    redirect: 'noredirect',
    name: 'forms',
    meta: {
      title: '表单设计',
      icon: 'form',
    },
    children: [
      {
        path: 'add',
        component: () => import('@/views/forms/add'),
        name: 'formAdd',
        hidden: true,
        meta: {
          notauth: true,
          title: '添加表单',
          icon: 'star',
          code: 'addForm',
          keepAlive: false,
        },
      },
      {
        path: 'edit/:id',
        component: () => import('@/views/forms/edit'),
        name: 'formEdit',
        hidden: true,
        meta: {
          notauth: true,
          title: '编辑表单',
          code: 'editForm',
          keepAlive: false,
          icon: 'list',
        },
      },
    ],
  },
  //流程模版路由
  {
    path: '/flowschemes',
    component: Layout,
    redirect: 'noredirect',
    name: 'flowschemes',
    meta: {
      title: '流程设计',
      icon: 'eye',
    },
    children: [
      {
        path: 'add',
        component: () => import('@/views/flowschemes/add'),
        name: 'schemeAdd',
        hidden: true,
        meta: {
          notauth: true,
          title: '添加模板',
          icon: 'star',
          code: 'addFlowscheme',
          keepAlive: false,
        },
      },
      {
        path: 'edit/:id',
        component: () => import('@/views/flowschemes/edit'),
        name: 'schemeEdit',
        hidden: true,
        meta: {
          notauth: true,
          title: '编辑模板',
          icon: 'list',
          code: 'editFlowscheme',
          keepAlive: false,
        },
      },
    ],
  },
  // 流程实例路由
  {
    path: '/flowinstances',
    component: Layout,
    redirect: 'noredirect',
    name: 'flowinstances',
    meta: {
      title: '流程中心',
      icon: 'guide',
    },
    children: [
      {
        path: 'detail/:id',
        component: () => import('@/views/flowinstances/detail'),
        name: 'flowinstanceDtl',
        hidden: true,
        meta: {
          notauth: true,
          title: '流程详情',
          icon: 'list',
          code: 'flowinstanceDetail',
          keepAlive: true,
        },
      },
      {
        path: 'verify/:id',
        component: () => import('@/views/flowinstances/verify'),
        name: 'verifyFlowinstance',
        hidden: true,
        meta: {
          notauth: true,
          title: '处理流程',
          icon: 'list',
          code: 'flowInstanceDisposed',
          keepAlive: true,
        },
      },
      {
        path: 'update/:id',
        component: () => import('@/views/flowinstances/update'),
        name: 'flowinstanceUpdate',
        hidden: true,
        meta: {
          notauth: true,
          title: '编辑流程',
          icon: 'list',
          code: 'flowinstanceUpdate',
          keepAlive: true,
        },
      },
      {
        path: 'add',
        component: () => import('@/views/flowinstances/add'),
        name: 'instanceAdd',
        meta: {
          notauth: true,
          title: '发起流程',
          icon: 'star',
          code: 'flowinstanceAdd',
          keepAlive: true,
        },
      },
    ],
  },
  //打印方案设计
  {
    path: '/sysprinterplans',
    component: Layout,
    redirect: 'noredirect',
    name: 'sysprinterplans',
    meta: {
      title: '编辑方案',
      icon: 'eye',
    },
    children: [
      {
        path: 'design/:id',
        component: () => import('@/views/sysprinterplans/design'),
        name: 'planDesign',
        hidden: true,
        meta: {
          notauth: true,
          title: '编辑方案',
          icon: 'list',
          code: 'printCustom',
          keepAlive: true,
        },
      },
      {
        path: 'design',
        component: () => import('@/views/sysprinterplans/design'),
        name: 'planDesignAdd',
        hidden: true,
        meta: {
          notauth: true,
          title: '新增方案',
          icon: 'list',
          code: 'printCustom',
          keepAlive: true,
        },
      },
    ],
  },
  {
    path: '/oidc-callback', // Needs to match redirect_uri in you oidcSettings
    name: 'oidcCallback',
    component: OidcCallback,
    meta: {
      sortNo: 0,
      isOidcCallback: true,
      isPublic: true,
    },
  },
  {
    path: '/oidcRedirect', // oidc临时跳转页面
    name: 'oidcRedirect',
    meta: {
      sortNo: 0,
    },
    component: oidcRedirect,
  },
  {
    path: '/wmsinboundordertbls/detail/:id',
    component: DetailWmsInboundOrderTbls,
    name: 'wmsinboundordertbls',
    hidden: true,
    meta: {
      notauth: true,
      title: '入库单详情',
      noCache: true,
      icon: 'list',
    }
  },
  {
    path: '/',
    component: Layout,
    redirect: 'dashboard',
    name: 'layout',
    meta: {
      sortNo: 0,
    },
    children: [
      {
        path: '/dashboard',
        name: 'dashboard',
        meta: {
          title: '主页',
          icon: 'iconfont icon-zhuyeicon',
          sortNo: 0,
        },
        component: () => import('@/views/dashboard/index'),
      },
      {
        path: '/profile',
        name: 'profile',
        hidden: true,
        meta: {
          title: '个人中心',
          icon: 'guide',
          sortNo: 0,
        },
        component: () => import('@/views/usermanager/profile'),
      },
      {
        // path: '/iframePage/:url/:name',
        path: '/iframePage/:code',
        name: 'iframePage',
        hidden: true,
        meta: {
          title: '接口文档',
          icon: 'guide',
          sortNo: 0,
        },
        component: () => import('@/views/iframePage/index'),
      },
    ],
  },
]
var router = new Router({
  // mode: 'history', //后端支持可开
  scrollBehavior: () => ({
    y: 0,
  }),
  routes: constantRouterMap,
})
export default router
