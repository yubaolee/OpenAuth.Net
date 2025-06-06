/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2023-09-16 19:59:57
 * @LastEditTime: 2023-10-03 13:11:54
 * @Description: 打印方案相关接口
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/sysPrinterPlans/load',
    method: 'get',
    params
  })
}

/**
 *获取所有表信息
 * @export
 * @return {*} 
 */
export function getTables() {
  return request({
    url: '/sysPrinterPlans/getTables',
    method: 'get'
  })
}
/**
 *根据视图/表名获取列信息
 *
 * @export
 * @param {*} params 视图/表的名称
 * @return {*} 
 */
export function getColumns(params) {
  return request({
    url: '/sysPrinterPlans/getColumns',
    method: 'get',
    params
  })
}

export function get(params) {
  return request({
    url: '/sysPrinterPlans/get',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/sysPrinterPlans/add',
    method: 'post',
    data
  })
}

export function query(data) {
  return request({
    url: '/sysPrinterPlans/query',
    method: 'post',
    data
  })
}

export function update(data) {
  return request({
    url: '/sysPrinterPlans/update',
    method: 'post',
    data
  })
}

export function del(data) {
  return request({
    url: '/sysPrinterPlans/delete',
    method: 'post',
    data
  })
}

