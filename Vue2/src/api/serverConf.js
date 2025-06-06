import request from '@/utils/request'

export function isIdentityAuth() {
  return request({
    url: '/sysConf/isIdentityAuth',
    method: 'get'
  })
}

