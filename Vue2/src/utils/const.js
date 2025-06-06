export const statusOptions = [
  {
    key: -1,
    display_name: "草稿",
  },
  {
    key: 0,
    display_name: "正在运行",
  },
  {
    key: 1,
    display_name: "完成",
  },
  {
    key: 2,
    display_name: "未知",
  },
  {
    key: 3,
    display_name: "没有通过",
  },
  {
    key: 4,
    display_name: "驳回",
  },
]

/**
 * 代码生成器中定义的编辑类型
 */
export const  typeLists= [
  {
    label: '文本框',
    value: 'text'
  },
  {
    label: '多行文本框',
    value: 'textarea'
  },
  {
    label: '开关', //用于修改bool类型的switch
    value: 'switch'
  },
  {
    label: '下拉列表',  //静态数据
    value: 'select'
  },
  {
    label: '动态下拉列表', //动态选择，数据时从接口中获取
    value: 'selectDynamic'
  },
  {
    label: '日期',
    value: 'date'
  },
  {
    label: '日期时间',
    value: 'datetime'
  },
  {
    label: 'checkbox',
    value: 'checkbox'
  },
  {
    label: 'mail',
    value: 'mail'
  },
  {
    label: 'number',
    value: 'number'
  },
  {
    label: 'decimal',
    value: 'decimal'
  },
  {
    label: 'phone',
    value: 'phone'
  },
  {
    label: 'img',
    value: 'img'
  },
  {
    label: 'excel',
    value: 'excel'
  },
  {
    label: 'file',
    value: 'file'
  }
]
