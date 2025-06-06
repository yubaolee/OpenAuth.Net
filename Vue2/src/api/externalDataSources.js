import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/externalDataSources/load',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/externalDataSources/add',
    method: 'post',
    data
  })
}

export function testConnection(data) {
  return request({
    url: '/externalDataSources/testConnection',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/externalDataSources/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/externalDataSources/delete',
    method: 'post',
    data
  })
}

