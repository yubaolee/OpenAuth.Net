<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2023-09-16 12:51:45
 * @LastEditTime: 2023-10-05 16:13:00
 * @Description: 打印预览
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <el-dialog v-el-drag-dialog :destroy-on-close="true" class="dialog-mini custom-dialog user-dialog" :visible="visible"
    :maskClosable="false" @close="hideModal" :width="width + 'mm'">
    <div style="text-align:left;">
      <el-button :loading="waitShowPrinter" type="primary" size="small" icon="printer" @click.stop="print">打印</el-button>
      <el-button type="primary" icon="printer" size="small" @click.stop="toPdf">导出PDF</el-button>
      <el-button key="close" type="danger" size="small" @click="hideModal">
        关闭
      </el-button>
    </div>
    <div id="preview_content"></div>
  </el-dialog>
</template>
<script>
import elDragDialog from '@/directive/el-dragDialog'
export default {
  name: "printPreview",
  props: {},
  directives: {
    elDragDialog
  },
  data() {
    return {
      visible: false,
      spinning: true,
      waitShowPrinter: false,
      // 纸张宽 mm
      width: 0,
      // 模板
      hiprintTemplate: {},
      // 数据
      printData: {}
    }
  },
  computed: {},
  watch: {},
  created() {
  },
  mounted() {
  },
  methods: {
    hideModal() {
      this.visible = false
    },
    show(hiprintTemplate, printData, width = '210') {
      this.visible = true
      this.spinning = true
      this.width = width
      this.hiprintTemplate = hiprintTemplate
      this.printData = printData
      setTimeout(() => {
        // eslint-disable-next-line no-undef
        $('#preview_content').html(hiprintTemplate.getHtml(printData))
        this.spinning = false
      }, 500)
    },
    print() {
      this.waitShowPrinter = true
      this.hiprintTemplate.print(this.printData, {}, {
        callback: () => {
          this.waitShowPrinter = false
        }
      })
    },
    toPdf() {
      this.hiprintTemplate.toPdf(this.printData, '打印预览');
    },
  }
}
</script>
<!-- <style lang="less" scoped>
/deep/ .ant-modal-body {
  padding: 0px;
}
/deep/ .ant-modal-content {
  margin-bottom: 24px;
}
</style> -->
