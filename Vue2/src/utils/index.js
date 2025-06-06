/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:29
 * @LastEditTime: 2023-09-20 21:56:17
 * @Description: 
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
*/


/**
 * 按字段给数组分组
 * @param {*} list 
 * @param {*} groupBy 
 * @returns 
 */
export function groupBy(list, groupBy) {
  result = list.reduce(function (result, item) {
      let groupVal = item[groupBy]
      result[groupVal] = result[groupVal] || []
      result[groupVal].push(item)
      return result
  }, Object.create(null))

  var result = Object.entries(result) //转成keyvalue

  let finalresult = []
  result.forEach((element) => {
      let orgin = Object.assign(
          {},
          list.find((u) => u[groupBy] == element[0])
      )
      orgin['details'] = element[1].slice()  //明细列表
      finalresult.push(orgin)
  })

  return finalresult
}


/**
 * 去重
 * @param {Array} arr 含有重复元素的数组
 * @returns
 */
export function unique(arr) {
  var obj = {}
  return arr.filter(function(item) {
    return Object.prototype.hasOwnProperty.call(obj, typeof item + item) ? false : (obj[typeof item + item] = true)
  })
}

/**
 * 判断两个对象是否相同
 * @param {Object} x 
 * @param {Object} y 
 * @returns 
 */
export function deepEqual(x, y) {
  const ok = Object.keys, tx = typeof x, ty = typeof y;
  return x && y && tx === 'object' && tx === ty ? (
    ok(x).length === ok(y).length &&
      ok(x).every(key => deepEqual(x[key], y[key]))
  ) : (x === y);
}

/**
 * 获取类型默认值
 * @param {string} type 类型名称
 * @returns
 */
export function defaultVal(type) {
  if (typeof type !== 'string') throw new TypeError('Type must be a string.')

  // Handle simple types (primitives and plain function/object)
  switch (type) {
    case 'decimal':
      return 0
    case 'bool':
      return false
    case 'int':
      return 0
    case 'null':
      return null
    case 'number':
      return 0
    case 'object':
      return {}
    case 'string':
      return ''
    case 'DateTime':
      return parseTime(new Date())
    case 'symbol':
      return Symbol()
    case 'undefined':
      return void 0
  }

  try {
    // Look for constructor in this or current scope
    var ctor = typeof this[type] === 'function' ? this[type] : eval(type)

    return new ctor()

    // Constructor not found, return new object
  } catch (e) {
    return {}
  }
}

export function parseTime(time, cFormat) {
  if (arguments.length === 0) {
    return null
  }
  const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
  let date
  if (typeof time === 'object') {
    date = time
  } else {
    if (('' + time).length === 10) time = parseInt(time) * 1000
    date = new Date(time)
  }
  const formatObj = {
    y: date.getFullYear(),
    m: date.getMonth() + 1,
    d: date.getDate(),
    h: date.getHours(),
    i: date.getMinutes(),
    s: date.getSeconds(),
    a: date.getDay()
  }
  const time_str = format.replace(/{(y|m|d|h|i|s|a)+}/g, (result, key) => {
    let value = formatObj[key]
    if (key === 'a') return ['一', '二', '三', '四', '五', '六', '日'][value - 1]
    if (result.length > 0 && value < 10) {
      value = '0' + value
    }
    return value || 0
  })
  return time_str
}

export function formatTime(format) {
  const now = new Date()
  var o = {
    'M+': now.getMonth() + 1, // month
    'd+': now.getDate(), // day
    'h+': now.getHours(), // hour
    'm+': now.getMinutes(), // minute
    's+': now.getSeconds(), // second
    'q+': Math.floor((now.getMonth() + 3) / 3), // quarter
    S: now.getMilliseconds() // millisecond
  }
  if (/(y+)/.test(format)) {
    format = format.replace(RegExp.$1, (now.getFullYear() + '').substr(4 - RegExp.$1.length))
  }
  for (var k in o) {
    if (new RegExp('(' + k + ')').test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length === 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length))
    }
  }
  return format
}

// 将list转成tree，使用前注意把array进行深拷贝
export function listToTreeSelect(array, parent, tree) {
  tree = typeof tree !== 'undefined' ? tree : []
  parent =
    typeof parent !== 'undefined'
      ? parent
      : {
          id: null
        }

  var children = array.filter((val) => {
    return val.parentId === parent.id
  })

  if (children.length > 0) {
    if (parent.id === null) {
      tree = children
    } else {
      parent['children'] = children
    }

    children.forEach((val) => {
      listToTreeSelect(array, val)
    })
  }

  return tree
}

// 深拷贝
export const deepClone = (obj) => {
  var objArray = Array.isArray(obj) ? [] : {}
  if (obj && typeof obj === 'object') {
    for (let key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        if (obj[key] && typeof obj[key] === 'object') {
          objArray[key] = deepClone(obj[key])
        } else {
          objArray[key] = obj[key]
        }
      }
    }
  }
  return objArray
}

export const local = {
  setItem(item, data) {
    localStorage.setItem(`INTERNAL_${item}`, JSON.stringify(data))
  },
  getItem(item) {
    return (localStorage.getItem(`INTERNAL_${item}`) && JSON.parse(localStorage.getItem(`INTERNAL_${item}`))) || ''
  },
  removeItem(item) {
    localStorage.removeItem(`INTERNAL_${item}`)
  },
  removeAll() {
    localStorage.clear()
  }
}
