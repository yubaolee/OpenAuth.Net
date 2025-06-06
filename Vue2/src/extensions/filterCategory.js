//description: 转换字典扩展
//author: liyubao | xufuxing
//version: 1.0
//createDate:2021-08-24

import { mapGetters } from 'vuex'

let extension = {
  components: {
    //组件扩展
  },
  computed: {
    ...mapGetters(['typeDataLists'])
  },

  methods: {
    /**
     * 渲染switch的值
     */
    filterSwitch(val, typeid) {
      if (typeid != undefined && typeid != '') {
        //swith带有数据来源字典
        return this.filterSelect(val, typeid)
      } else if (val == 1 || val == true) return '是'
      else if (val == 0 || val == false) return '否'
      else return '未知'
    },
    /**
     * 渲染下拉选择框的值
     */
    filterSelect(val, typeid) {
      const obj = this.typeDataLists.length > 0 && this.typeDataLists.find((item) => item.typeId === typeid)
      const arr = (obj && obj.typeDatas) || []
      const item = (arr.length > 0 && arr.find((item) => item.dtCode === val) && arr.find((item) => item.dtCode === val).name) || ''
      return item || val || ''
    }
  }
}
export default extension
