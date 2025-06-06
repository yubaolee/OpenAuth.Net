/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2021-06-01 14:10:29
 * @LastEditTime: 2024-02-21 19:34:06
 * @Description: 顶部tag缓存
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import { local } from '@/utils'
const tagsView = {
  state: {
    visitedViews: [],
    iframeViews: {},
  },
  mutations: {
    ADD_VISITED_VIEWS: (state, view) => {
      if (state.visitedViews.length <= 0) {
        state.visitedViews = local.getItem('visitedViews') || []
      }

      if (state.visitedViews.some(v => v.path === view.path)) return

      var visit = {
        //如果这个地方用view.name，当name相同（即模块名称相同）时，visitedViews所有的path都是相同的，且都是SysLogs/Index，很诡异的BUG😂
        name: view.path.replaceAll('/', '_'), 
        path: view.path,
        params: view.params,
        meta: view.meta,
        title:
          view.name === 'iframePage'
            ? state.iframeViews[view.params.code].name
            : view.meta.title || 'no-name',
      }

      state.visitedViews.push(visit)

      local.setItem('visitedViews', state.visitedViews)
    },
    DEL_VISITED_VIEWS: (state, view) => {
      for (const [i, v] of state.visitedViews.entries()) {
        if (v.path.toLowerCase() === view.path.toLowerCase()) {
          state.visitedViews.splice(i, 1)
          local.setItem('visitedViews', state.visitedViews)
          break
        }
      }
    },
    DEL_OTHERS_VIEWS: (state, view) => {
      for (const [i, v] of state.visitedViews.entries()) {
        if (v.path === view.path) {
          state.visitedViews = state.visitedViews.slice(i, i + 1)
          local.setItem('visitedViews', state.visitedViews)
          break
        }
      }
    },
    DEL_ALL_VIEWS: (state) => {
      state.visitedViews = []
      local.setItem('visitedViews', state.visitedViews)
    },
    SET_IFRAME_TAGVIEWS(state, data) {
      state.iframeViews = { ...state.iframeViews, ...data }
    },
  },
  actions: {
    setIframeTagViews({ commit }, data) {
      commit('SET_IFRAME_TAGVIEWS', data)
    },
    addVisitedViews({ commit }, view) {
      commit('ADD_VISITED_VIEWS', view)
    },
    delVisitedViews({ commit, state }, view) {
      return new Promise((resolve) => {
        commit('DEL_VISITED_VIEWS', view)
        resolve([...state.visitedViews])
      })
    },
    delOthersViews({ commit, state }, view) {
      return new Promise((resolve) => {
        commit('DEL_OTHERS_VIEWS', view)
        resolve([...state.visitedViews])
      })
    },
    delAllViews({ commit, state }) {
      return new Promise((resolve) => {
        commit('DEL_ALL_VIEWS')
        resolve([...state.visitedViews])
      })
    },
  },
  getters: {
    iframeViews: (state) => state.iframeViews,
  },
}

export default tagsView
