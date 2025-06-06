/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-06-01 08:46:19
 * @LastEditTime: 2025-04-05 14:25:47
 * @Description: 模块管理接口API
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import request from '@/utils/request'

export function get(params) {
  return request({
    url: '/modules/get',
    method: 'get',
    params,
  })
}

export function loadMenus(moduleId) {
  return request({
    url: '/modules/loadmenus',
    method: 'get',
    params: { moduleId: moduleId },
  })
}

/**
 * 获取模块对应的打印方案
 * @param {string} moduleId 模块id
 * @returns 
 */
export function loadPrinterPlans(moduleId) {
  return request({
    url: '/modules/loadPrinterPlans',
    method: 'get',
    params: { moduleId: moduleId }
  })
}

/**
 * 获取模块对应的送审方案
 * @param {string} moduleId 模块id
 * @returns 
 */
export function loadFlowSchemes(moduleId) {
  return request({
    url: '/modules/LoadFlowSchemes',
    method: 'get',
    params: { moduleId: moduleId }
  })
}

export function loadForRole(roleId) {
  return request({
    url: '/modules/loadforrole',
    method: 'get',
    params: { firstId: roleId },
  })
}

export function add(data) {
  return request({
    url: '/modules/add',
    method: 'post',
    data,
  })
}

export function update(data) {
  return request({
    url: '/modules/update',
    method: 'post',
    data,
  })
}

export function del(data) {
  return request({
    url: '/modules/delete',
    method: 'post',
    data,
  })
}

export function addMenu(data) {
  return request({
    url: '/modules/addmenu',
    method: 'post',
    data,
  })
}

export function updateMenu(data) {
  return request({
    url: '/modules/updatemenu',
    method: 'post',
    data,
  })
}

export function delMenu(data) {
  return request({
    url: '/modules/deletemenu',
    method: 'post',
    data,
  })
}

export function loadMenusForRole(roleId) {
  return request({
    url: '/modules/loadmenusforrole',
    method: 'get',
    params: { moduleId: '', firstId: roleId },
  })
}

export function getProperties(code) {
  return request({
    url: '/Check/GetProperties',
    method: 'get',
    params: { moduleCode: code },
  })
}

export function getModules(code) {
  return request({
    url: '/Check/GetModules',
    method: 'get',
    params: { moduleCode: code },
  })
}

export function loadPropertiesForRole(code, roleId) {
  return request({
    url: '/Modules/LoadPropertiesForRole',
    method: 'get',
    params: { moduleCode: code, roleId: roleId },
  })
}

export function assignDataProperty(code, roleId, properties) {
  return request({
    url: '/AccessObjs/AssignDataProperty',
    method: 'post',
    data: { moduleCode: code, roleId: roleId, properties: properties },
  })
}

export function unAssignDataProperty(code, roleId) {
  return request({
    url: '/AccessObjs/UnAssignDataProperty',
    method: 'post',
    data: { moduleCode: code, roleId: roleId, properties: [] },
  })
}
