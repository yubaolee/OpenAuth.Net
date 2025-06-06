/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-10-05 11:35:02
 * @LastEditTime: 2025-04-06 20:44:17
 * @Description:物流入库订单总单
 * @
 * @Copyright (c) 2022 by yubaolee | ahfu~ , All Rights Reserved.
 */
import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/wmsinboundordertbls/load',
    method: 'get',
    params,
  })
}

export function get(params) {
  return request({
    url: '/wmsinboundordertbls/get',
    method: 'get',
    params,
  })
}

export function add(data) {
  return request({
    url: '/wmsinboundordertbls/add',
    method: 'post',
    data,
  })
}

export function update(data) {
  return request({
    url: '/wmsinboundordertbls/update',
    method: 'post',
    data,
  })
}

export function del(data) {
  return request({
    url: '/wmsinboundordertbls/delete',
    method: 'post',
    data,
  })
}
