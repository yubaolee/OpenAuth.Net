import router from './router'
import store from './store'
import NProgress from 'nprogress' // Progress 进度条
import 'nprogress/nprogress.css'// Progress 进度条样式
import { Message } from 'element-ui'
import { getToken } from '@/utils/auth' // 验权

const whiteList = ['/login', '/oidc-callback', '/swagger', '/usermanager/profile'] // 不重定向白名单
router.beforeEach((to, from, next) => {
  NProgress.start()

  store.dispatch('GetIdentityAuth').then(isIdentity => {
    if (isIdentity) { // 采用Identity认证
      // 如果是oidcRedirect必须进入授权
      // 没登录时，如果是白名单页面，可以直接访问
      // 没登录时，如果是非登录页面，则跳转到登录
      if (store.getters.oidcUser == null && to.path !== '/oidcRedirect') {
        if (whiteList.indexOf(to.path) !== -1) {
          next()
          return
        } else {
          next('/login')
          return
        }
      }

      store.dispatch('oidcCheckAccess', to).then(function(hasAccess) {
        if (!hasAccess) {
          return
        }
        if (to.path === '/login') { // 登录后login自动跳转
          next({ path: '/' })
          return
        }
        if (store.getters.modules != null) {
          next()
          return
        }
        store.dispatch('GetModulesTree').then(modules => { // 获取用户可访问的模块
          store.dispatch('GenerateRoutes', { modules }).then(() => { // 根据权限生成可访问的路由表
            store.dispatch('GetDefaultOrg')
            router.addRoutes(store.getters.addRouters) // 动态添加可访问路由表
            next({ ...to, replace: true }) // hack方法 确保addRoutes已完成 ,set the replace: true so the navigation will not leave a history record
          })
        })
      })
    } else { // 普通登录方式
      if (getToken()) {
        if (to.path === '/login') { // 登录后login自动跳转
          next({ path: '/' })
          return
        }
        if (store.getters.modules != null) {
          next()
          return
        }

        store.dispatch('GetInfo').then(() => { // 拉取用户信息
          store.dispatch('GetModulesTree').then(modules => { // 获取用户可访问的模块
            store.dispatch('GenerateRoutes', { modules }).then(() => { // 根据权限生成可访问的路由表
              store.dispatch('GetDefaultOrg')
              router.addRoutes(store.getters.addRouters) // 动态添加可访问路由表
              next({ ...to, replace: true }) // hack方法 确保addRoutes已完成 ,set the replace: true so the navigation will not leave a history record
            })
          })
        }).catch((err) => {
          store.dispatch('FedLogOut').then(() => {
            Message.error(err || '获取用户信息失败')
            next({ path: '/' })
          })
        })

        return
      }
      if (whiteList.indexOf(to.path) !== -1) { // 没登录情况下过滤白名单
        next()
      } else {
        next('/login')
      }
    }
  }).catch((err) => {
    Message.error(err || '获取服务器登录方式失败')
  })
})

router.afterEach(() => {
  NProgress.done() // 结束Progress
})
