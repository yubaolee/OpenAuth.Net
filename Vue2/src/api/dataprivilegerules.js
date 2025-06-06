import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/dataPrivilegeRules/load',
    method: 'get',
    params
  })
}

export function loadForRole(roleId) {
  return request({
    url: '/dataPrivilegeRules/loadForRole',
    method: 'get',
    params: { appId: '', firstId: roleId }
  })
}

export function add(data) {
  return request({
    url: '/dataPrivilegeRules/add',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/dataPrivilegeRules/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/dataPrivilegeRules/delete',
    method: 'post',
    data
  })
}

