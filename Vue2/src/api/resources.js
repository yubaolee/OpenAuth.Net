import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/resources/load',
    method: 'get',
    params
  })
}

export function loadForRole(roleId) {
  return request({
    url: '/resources/loadForRole',
    method: 'get',
    params: { appId: '', firstId: roleId }
  })
}

export function add(data) {
  return request({
    url: '/resources/add',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/resources/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/resources/delete',
    method: 'post',
    data
  })
}

