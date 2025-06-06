/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:11
 * @LastEditTime: 2023-09-29 11:50:35
 * @Description:统一关联处理
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved.
 */
import request from '@/utils/request'

export function assign(data) {
  return request({
    url: '/accessobjs/assign',
    method: 'post',
    data,
  })
}

export function unassign(data) {
  return request({
    url: '/accessobjs/unassign',
    method: 'post',
    data
  })
}

/**
 *先按firstId取消关联，再建立新的关联
 * @param {*} data
 * @return {*} 
 */
export function unAssignAndAssign(data) {
  var obj = data
  return request({
    url: '/accessobjs/unassign',
    method: 'post',
    data: {
      type: obj.type,
      firstId: obj.firstId,
    },
  }).then(function () {
    request({
      url: '/accessobjs/assign',
      method: 'post',
      data,
    })
  })
}
