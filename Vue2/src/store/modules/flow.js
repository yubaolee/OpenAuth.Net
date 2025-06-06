// import Cookies from 'js-cookie'

const app = {
  state: {
    currentSelect: {}
  },
  mutations: {
    SAVE_CURRENT_SELECT: (state, val) => {
      state.currentSelect = val
    },
    
  },
  actions: {
    saveCurrentSelect: ({ commit }, val) => {
      commit('SAVE_CURRENT_SELECT',val)
    }
  },
  getters: {
    currentSelect: state => state.currentSelect
  }
}

export default app
