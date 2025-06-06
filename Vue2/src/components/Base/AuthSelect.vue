<!--
 * @description: 通用下拉选择框
 * @author: liyubao | xufuxing
 * @version: 1.1
 * @updateDate:2021-08-25 增加传入value/label数组的支持
 *             2021-08-26 增加动态下拉列表支持
*  @description: 用于通用的下拉框选择，简单用法如下：
*             字典获取： <auth-select :isEdit="isEdit" @change="change" :data-source="'SYS_STATUS'" v-model="val" size="mini"></auth-select>
*             动态列表： <auth-select :isEdit="isEdit" @change="change" :type="'dynamic'" :data-source="'/CategoryTypes/Load'" v-model="val" size="mini"></auth-select>
-->

<template>
  <div>
    <span v-if="!isEdit">{{ labelName }}</span>
    <el-select filterable allow-create clearable v-else :size="size" :disabled="disabled" :value="value" @change="handleChange">
      <el-option v-for="(item, index) in typeDatas" :key="index" :value="item[defaultProps.value]" :label="item[defaultProps.label]"></el-option>
    </el-select>
  </div>
</template>

<script>
import * as categorys from '@/api/categorys'
import { mapGetters, mapActions } from 'vuex'
import request from '@/utils/request'

export default {
  name: 'authSelect',
  components: {},
  props: {
    /**
     * 下拉的类型：
     * static：从数据字典Category按字典类型加载
     * dynamic：从接口中获取
     */
    type: {
      type: String,
      default: 'static'
    },

    /**
     * 搜索关键字
     * 当style为dynamic时，该值为传入的搜索关键字
     */
    searchKey: {
      type: Object,
      defalut: {}
    },
    /**
     * 下拉框数据来源，
     * 当为字符串时，表示字典类型，下拉框的选项为该字典类型下所有的字典列表
     * 当为value/label列表时，下拉框的选项为value/label列表
     * 当sytle为dynamic时，下拉框的选项从dataSource接口地址中获取列表
     */
    dataSource: [String, Number, Array],
    /**
     * 绑定值，直接同步v-model
     */
    value: {
      type: [String, Number],
      default: ''
    },
    /*
     * 是否禁用
     */
    disabled: {
      type: Boolean,
      default: false
    },
    /**
     * 是否为编辑状态
     */
    isEdit: {
      type: Boolean,
      default: true
    },
    size: {
      type: String,
      default: 'mini'
    },
    defaultProps: {
      type: Object,
      default() {
        return {
          label: 'label',
          value: 'value'
        }
      }
    }
  },
  data() {
    return {}
  },
  destroyed() {
    this.clearTypeDatas()
  },
  computed: {
    ...mapGetters({
      typeDataLists: 'typeDataLists',
      typeIds: 'typeIds'
    }),
    typeDatas() {
      if (Array.isArray(this.dataSource)) {
        //如果直接输入的是key/value对象数组
        return this.dataSource
      }
      const object = this.typeDataLists.length > 0 && this.typeDataLists.find((item) => item.typeId === this.dataSource)
      return (object && object.typeDatas) || []
    },
    labelName() {
      //当前值对应的名称

      var item = {}

      if (Array.isArray(this.dataSource)) {
        //如果直接输入的是key/value对象数组
        item = this.dataSource.find((item) => item[this.defaultProps.value] === this.value)
      } else {
        item = this.typeDatas.find((item) => item[this.defaultProps.value] === this.value)
      }
      return (item && item[this.defaultProps.label]) || this.value
    }
  },
  watch: {
    typeId() {
      this.getList()
    }
  },
  created() {
    this.initView()
  },
  methods: {
    ...mapActions({
      saveTypeDataLists: 'saveTypeDataLists',
      saveTypeIds: 'saveTypeIds',
      clearTypeDatas: 'clearTypeDatas'
    }),
    initView() {
      if (Array.isArray(this.dataSource)) {
        //如果是直接输入的是key/value对象数组
        return
      }

      const type = this.typeDataLists.find((item) => item.typeId === this.dataSource)
      this.saveTypeIds(this.dataSource) //这句为什么不能删除？？😨😨😨😨
      if (type) {
        return
      }
      this.getList()
    },
    getList() {
      if (Array.isArray(this.dataSource)) {
        //如果输入的是key/value对象数组
        return
      }
      if (this.type == 'dynamic') {
        let _this = this;
        request({
          url: this.dataSource,
          method: 'get',
          params: this.searchKey
        }).then((res) => {
          const obj = {
            typeId: this.dataSource, //todo:暂时用url地址作为缓存的key，如果换了搜索关键字会有BUG
            typeDatas: res.data.map((item) => {
              var o = {}
              /** 
               * 这里转换的原因如下：
               * 如果外部使用:default-props="{label:'tableName', value:'id'}" 传值，则使用外部的定义
               * 如果外部没有使用:default-props，则外部需要传id/name形式的数据（如动态表单部分）
              */
              o[_this.defaultProps.label] = item[_this.defaultProps.label] ?? item.name
              o[_this.defaultProps.value] = item[_this.defaultProps.value] ?? item.id
              return o
            })
          }
          this.saveTypeDataLists(obj)
        })
      } else {  //从字典表里面按照字典类型获取
        const listQuery = {
          page: 1,
          limit: 9999,
          TypeId: this.dataSource
        }
        return categorys.getList(listQuery).then((res) => {
          const obj = {
            typeId: this.dataSource,
            typeDatas: res.data.map((item) => {
              var o = {
                label: item.name,
                value: item.dtValue
              }
              return o
            })
          }
          this.saveTypeDataLists(obj)
        })
      }
    },
    handleChange(val) {
      this.$emit('input', val)
      this.$emit('change', val)
    }
  }
}
</script>

<style scoped></style>
