import { deepClone } from '@/utils'
const flow = {
  state: {
    flowDetails: {},
    addFlowDetail: '',
    isFlowRender: false
  },
  mutations: {
    SAVE_FLOW_DETAILS: (state, val) => {
      state.flowDetails = {...state.flowDetails, ...deepClone(val)}
    },
    SAVE_ADD_FLOW_DETAILS: (state, data) => {
      state.addFlowDetail = data
    },
    UPDATE_FLOW_IS_RENDER(state, val) {
      state.isFlowRender = val
    }
  },
  actions: {
    saveFlowDetails: ({ commit }, data) => {
      commit('SAVE_FLOW_DETAILS',data)
    },
    saveAddFlowDetails: ({ commit }, data) => {
      commit('SAVE_ADD_FLOW_DETAILS',data)
    },
    updateFlowIsRender({commit}, val){
      commit('UPDATE_FLOW_IS_RENDER',val)
    }
  },
  getters: {
    flowDetails: state => state.flowDetails,
    addFlowDetail: state => state.addFlowDetail,
    isFlowRender: state => state.isFlowRender
  }
}

export default flow
