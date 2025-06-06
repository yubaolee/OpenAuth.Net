import { deepClone } from '@/utils'
const flow = {
  state: {
    instancesDetails: {},
    addInstancesDetail: '',
    veriyDetails: {},
    isWaitRender: false,
    isDisposedRender: false,
    isMineRender: false
  },
  mutations: {
    SAVE_INSTANCES_DETAILS: (state, val) => {
      state.instancesDetails = {...state.instancesDetails, ...deepClone(val)}
    },
    SAVE_ADD_INSTANCES_DETAILS: (state, data) => {
      state.addInstancesDetail = data
    },
    SAVE_VERIY_DETAILS: (state, val) => {
      state.veriyDetails = {...state.veriyDetails, ...deepClone(val)}
    },
    UPDATE_INSTANCES_IS_RENDER(state, { type, val }) {
      if(!type){
        state.isDisposedRender = val
        state.isMineRender = val
        state.isWaitRender = val
        return
      }
      state[type] = val
    }
  },
  actions: {
    saveInstancesDetails: ({ commit }, data) => {
      commit('SAVE_INSTANCES_DETAILS',data)
    },
    saveVeriyDetails: ({ commit }, data) => {
      commit('SAVE_VERIY_DETAILS',data)
    },
    saveAddInstancesDetail: ({ commit }, data) => {
      commit('SAVE_ADD_INSTANCES_DETAILS',data)
    },
    updateInstancesIsRender({commit}, data){
      commit('UPDATE_INSTANCES_IS_RENDER',data)
    }
  },
  getters: {
    instancesDetails: state => state.instancesDetails,
    addInstancesDetail: state => state.addInstancesDetail,
    veriyDetails: state => state.veriyDetails,
    isWaitRender: state => state.isWaitRender,
    isDisposedRender: state => state.isDisposedRender,
    isMineRender: state => state.isMineRender
  }
}

export default flow
