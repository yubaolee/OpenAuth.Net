import { getModules } from '@/api/modules'

const user = {
  state: {
    checkModules: []
  },

  mutations: {
    SET_CHECK_MODULES: (state, modules) => {
      state.checkModules = modules
    }
  },

  actions: {
    // 获取模块
    getCheckModules({ commit, state }) {
      return new Promise((resolve, reject) => {
        getModules(state.token).then(response => {
          commit('SET_CHECK_MODULES', response.result)
          resolve(response)
        }).catch(error => {
          reject(error)
        })
      })
    }
  },
  getters: {
    checkModules: state => state.checkModules
  }
}

export default user
