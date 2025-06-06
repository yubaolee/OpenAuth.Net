import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/wmsInboundOrderDtbls/load',
    method: 'get',
    params
  })
}

export function loadForRole(roleId) {
  return request({
    url: '/wmsInboundOrderDtbls/loadForRole',
    method: 'get',
    params: { appId: '', firstId: roleId }
  })
}

export function add(data) {
  return request({
    url: '/wmsInboundOrderDtbls/add',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/wmsInboundOrderDtbls/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/wmsInboundOrderDtbls/delete',
    method: 'post',
    data
  })
}

