import { isIdentityAuth } from '@/api/serverConf'

const serverConf = {
  state: {
    isIdentityAuth: undefined
  },
  mutations: {
    SET_IDENTITYAUTH: (state,isIdentityAuth) => {
      state.isIdentityAuth = isIdentityAuth
    }
  },
  actions: {
    // 获取服务器是否启用了Identity
    GetIdentityAuth({ commit, state,reject }) {
      return new Promise((resolve) => {
        if (state.isIdentityAuth !== undefined) {
          resolve(state.isIdentityAuth)
          return
        }

        isIdentityAuth().then(response => {
          commit('SET_IDENTITYAUTH', response.result)
          resolve(response.result)
        }).catch(error => {
          reject(error)
        })

      })
    }
  }
}

export default serverConf
