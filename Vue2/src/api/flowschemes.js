/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2024-01-08 17:08:56
 * @Description: 
 * @LastEditTime: 2025-04-08 09:23:47
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */
import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/flowschemes/load',
    method: 'get',
    params
  })
}

/**
 * 获取送审方案，即表单类型为URL表单的流程模板
 * @param {Object} params 
 * @returns 
 */
export function loadUrlFormFlowScheme(params) {
  return request({
    url: '/flowschemes/loadUrlFormFlowScheme',
    method: 'get',
    params,
  })
}

export function get(params) {
  return request({
    url: '/flowschemes/get',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/flowschemes/add',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/flowschemes/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/flowschemes/delete',
    method: 'post',
    data
  })
}

