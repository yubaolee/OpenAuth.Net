/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:27
 * @LastEditTime: 2025-04-07 21:22:09
 * @Description: 通用扩展，使用mixins引入
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
*/
import { groupBy } from '@/utils/index'
import * as sysPrinterPlans from '@/api/sysPrinterPlans'
import * as flowinstances from '@/api/flowinstances'
import { hiprint } from 'vue-plugin-hiprint'
import printPreview from '@/views/sysprinterplans/preview'

let extension = {
  components: {
    //组件扩展
    printPreview
  },

  methods: {
    /**
     * 删除选中行
     * @param {*} objs 表格对应的实体API
     * @param {*} rows 要删除的行
     * @param {*} callback 删除后的回调
     */
    delrows(objs, rows, callback) {
      var _this = this
      _this
        .$confirm('是否确认删除?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
        .then(() => {
          objs.del(rows.map((u) => u.id)).then(() => {
            _this.$notify({
              title: '成功',
              message: '删除成功',
              type: 'success',
              duration: 2000,
            })
            rows.forEach((row) => {
              const index = _this.list.indexOf(row)
              _this.list.splice(index, 1)
            })
            if (callback != undefined) {
              callback()
            }
          })
        })
        .catch(() => {
          _this.$message({
            type: 'info',
            message: '已取消',
          })
        })
    },
    /**
     *打印预览
     * @param {*} preView 预览的view引用界面
     * @param {*} plan  打印方案
     * @param {*} obj  参数
     */
    printPreview(preView, plan, obj) {
      hiprint.init()
      var template = JSON.parse(plan.planContent)
      var hiprintTemplate = new hiprint.PrintTemplate({
        template: template,
      })

      sysPrinterPlans
        .query({
          sourceSql: plan.sourceSql,
          paramJsonStr: JSON.stringify(obj),
        })
        .then((response) => {
          var result = []
          if (plan.groupBy && plan.groupBy != '') {
            result = groupBy(response.data, plan.groupBy)
          } else {
            result = response.data
          }

          preView.show(hiprintTemplate, result, template.panels[0].width)
        })
    },

      /**
     * 送审（创建流程实例）
     * @param {*} flowscheme 选中的流程模板
     * @param {*} obj 业务单据
     * @param {*} customName 送审的流程名称
     */
    createFlowInstance(flowscheme, obj, customName) {
      flowinstances.add({
        schemeId: flowscheme.id,
        code: new Date().getTime(),
        customName: customName?? '业务单据' + obj.id + '送审',
        businessId: obj.id
        }).then((response) => {
          if(response.code == 200){
            this.$message({
              message: '送审成功',
              type: 'success'
            })
          }else{
            this.$message({
              message: response.message,
              type: 'error'
            })
          }
        })
      }
  },
}
export default extension
