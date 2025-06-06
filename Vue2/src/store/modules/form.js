import { deepClone } from '@/utils'
const form = {
  state: {
    formDetails: {},
    addFormDetail: '',
    isRender: false
  },
  mutations: {
    SAVE_FORM_DETAILS: (state, val) => {
      state.formDetails = {...state.formDetails, ...deepClone(val)}
    },
    SAVE_Add_FORM_DETAILS: (state, data) => {
      state.addFormDetail = data
    },
    UPDATE_IS_RENDER(state, val) {
      state.isRender = val
    }
  },
  actions: {
    saveFormDetails: ({ commit }, data) => {
      commit('SAVE_FORM_DETAILS',data)
    },
    saveAddFormDetails: ({ commit }, data) => {
      commit('SAVE_Add_FORM_DETAILS',data)
    },
    updateIsRender({commit}, val){
      commit('UPDATE_IS_RENDER',val)
    }
  },
  getters: {
    formDetails: state => state.formDetails,
    addFormDetail: state => state.addFormDetail,
    isRender: state => state.isRender
  }
}

export default form
