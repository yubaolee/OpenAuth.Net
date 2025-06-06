import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/flowinstances/load',
    method: 'get',
    params
  })
}

export function get(params) {
  return request({
    url: '/flowinstances/get',
    method: 'get',
    params
  })
}

export function queryHistories(params) {
  return request({
    url: '/flowinstances/queryHistories',
    method: 'get',
    params
  })
}

export function verify(data) {
  return request({
    url: '/flowinstances/verification',
    method: 'post',
    data
  })
}

export function recall(data) {
  return request({
    url: '/flowinstances/recall',
    method: 'post',
    data
  })
}

export function start(data) {
  return request({
    url: '/flowinstances/start',
    method: 'post',
    data
  })
}

export function add(data) {
  return request({
    url: '/flowinstances/add',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/flowinstances/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/flowinstances/delete',
    method: 'post',
    data
  })
}

