/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2024-01-08 17:08:56
 * @LastEditTime: 2024-01-08 17:18:43
 * @Description: 使用cookie缓存登录的cookie
 * @
 * @Copyright (c) 2024 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import Cookies from 'js-cookie'

const TokenKey = 'X-Token'

export function getToken() {
  return Cookies.get(TokenKey)
}

export function setToken(token) {
  return  Cookies.set(TokenKey, token, { expires: 10 })
}

export function removeToken() {
  return Cookies.remove(TokenKey)
}
