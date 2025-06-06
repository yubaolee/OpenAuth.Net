import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/files/load',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/files/upload',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/files/delete',
    method: 'post',
    data
  })
}

