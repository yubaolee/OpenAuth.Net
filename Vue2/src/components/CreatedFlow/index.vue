<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2024-01-08 17:08:56
 * @LastEditTime: 2024-06-21 10:16:05
 * @Description: 
 * @
 * @Copyright (c) 2024 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div style="height: 100%;">
    <el-container class="container">
      <el-aside width="130px" theme="light" class="select-area" v-if="!isShowContent">
        <el-row>
          <el-checkbox-button v-model="tag.checked0" class="tag">工具</el-checkbox-button>
          <div align="center" v-if="tag.checked0">
            <el-button-group>
              <el-button v-for="(tool, index) in field.tools" :key="index" size="mini" :icon="tool.icon"
                :type="currentTool.type == tool.type ? 'primary' : 'default'" @click="selectTool(tool.type)"
                style="font-size: 16px;width: 50px;">
              </el-button>
            </el-button-group>
          </div>
        </el-row>
        <el-row>
          <el-checkbox-button v-model="tag.checked1" class="tag">基础节点</el-checkbox-button>
          <div align="center" v-if="tag.checked1">
            <draggable tag="el-row" :list="field.commonNodes"
              v-bind="{ group: { name: 'flow', pull: 'clone', put: false }, sort: false }" @end="handleMoveEnd"
              @start="handleMoveStart" :move="handleMove">
              <template v-for="(commonNode, index) in field.commonNodes">
                <el-col :span="24" :key="index">
                  <div class="node-item" :type="commonNode.type" belongto="commonNodes">
                    <i style="font-size: 16px;" :class="commonNode.icon" /> {{ commonNode.name }}
                  </div>
                </el-col>
              </template>
            </draggable>
          </div>
        </el-row>
        <el-row>
          <el-checkbox-button v-model="tag.checked3" class="tag">泳道节点</el-checkbox-button>
          <div align="center">
            <draggable tag="el-row" :list="field.laneNodes" :grid="{ gutter: 8, column: 2 }" v-if="tag.checked3"
              v-bind="{ group: { name: 'flow', pull: 'clone', put: false }, sort: false }" @end="handleMoveEnd"
              @start="handleMoveStart" :move="handleMove">
              <el-col :span="24" v-for="(laneNode, index) in field.laneNodes" :key="index">
                <div class="node-item" :type="laneNode.type" belongto="laneNodes">
                  <i style="font-size: 16px;" :class="laneNode.icon" /> {{ laneNode.name }}
                </div>
              </el-col>
            </draggable>
          </div>
        </el-row>
        <el-row>
          <div align="center">
          <el-popover title="确认要重新绘制吗？" placement="bottom" v-model="isShowPopover">
            <div style="text-align: center;">
              <el-button size="small" @click="isShowPopover = false">取消</el-button>
              <el-button type="primary" size="small" @click="clear">确认</el-button>
            </div>
            <el-tooltip slot="reference" content="清空当前画布，重新绘制" placement="bottom">
              <el-button size="mini" icon="el-icon-refresh-left">重新绘制</el-button>
            </el-tooltip>
          </el-popover>
        </div>
        </el-row>
      </el-aside>
      <el-main style="padding:0;">
        <el-container style="height: 100%;">
          <el-main class="content" style="padding: 0;">
            <flow-area v-if="loadFlowArea && flowData" ref="flowArea" :browserType="browserType" :flowData="flowData"
              :select.sync="currentSelect" :selectGroup.sync="currentSelectGroup" :plumb="plumb"
              :isShowContent="isShowContent" :currentTool="currentTool" :isDrag="isDrag"
              @findNodeConfig="findNodeConfig" @selectTool="selectTool" @getShortcut="getShortcut" @saveFlow="saveFlow">
            </flow-area>
            <vue-context-menu :contextMenuData="linkContextMenuData" @deleteLink="deleteLink">
            </vue-context-menu>
          </el-main>
        </el-container>
      </el-main>
      <el-aside width="300px" theme="light" class="attr-area" @mousedown.stop="loseShortcut"
        v-if="isShowAttr && (!isShowContent)">
        <flow-attr :plumb="plumb" :flowData="flowData" :formTemplate="formTemplate"></flow-attr>
      </el-aside>
    </el-container>
    <el-dialog :title="'流程设计图_' + flowData.attr.id + '.png'" centered width="90%" :closable="flowPicture.closable"
      :maskClosable="flowPicture.maskClosable" :visible="flowPicture.modalVisible" okText="下载到本地" cancelText="取消"
      @ok="downLoadFlowPicture" @cancel="cancelDownLoadFlowPicture">
      <div align="center">
        <img :src="flowPicture.url" />
      </div>
    </el-dialog>
  </div>
</template>

<script>

import Draggable from 'vuedraggable'
import FlowArea from './modules/FlowArea'
import { jsPlumb } from 'jsplumb'
import { tools, commonNodes, highNodes, laneNodes } from './config/basic-node-config.js'
import { flowConfig } from './config/args-config.js'
import { ZFSN } from './util/ZFSN.js'
import FlowAttr from './modules/FlowAttr'
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'vfd',
  components: {
    Draggable,
    FlowArea,
    FlowAttr
  },
  props: ['schemeContent', 'isEdit', 'formTemplate', 'isShowContent'],
  mounted() {
    const that = this
    that.dealCompatibility()
    if (this.schemeContent) {
      this.flowData = this.groupSchemeContent()
      this.flowData.status = flowConfig.flowStatus.MODIFY
      this.initJsPlumb()
      this.loadFlow()
    } else {
      this.initJsPlumb()
      this.loadFlow()
    }
    that.listenShortcut()
  },
  data() {
    return {
      isDrag: false,
      loadFlowArea: false,
      isShowPopover: false,
      isShowAttr: false,  //是否显示右边属性框
      tag: {
        checked0: true,
        checked1: true,
        checked2: true,
        checked3: true
      },
      browserType: 3,
      plumb: '',
      field: {
        tools: tools,
        commonNodes: commonNodes,
        highNodes: highNodes,
        laneNodes: laneNodes
      },
      flowData: {
        nodes: [],
        lines: [],
        attr: {
          id: ''
        },
        config: {
          showGrid: true,
          showGridText: '隐藏网格',
          showGridIcon: 'el-icon-view'
        },
        status: flowConfig.flowStatus.CREATE,
        remarks: []
      },
      currentTool: {
        type: 'drag',
        icon: 'drag',
        name: '拖拽'
      },
      currentSelectGroup: [],
      activeShortcut: true,
      linkContextMenuData: flowConfig.contextMenu.sl,
      flowPicture: {
        url: '',
        modalVisible: false,
        closable: false,
        maskClosable: false
      }
    }
  },
  computed: {
    ...mapGetters({
      currentSelect: 'currentSelect'
    })
  },
  watch: {
    currentSelect: {
      deep: true,
      handler() {
        const list = this.currentSelect.type === 'sl' ? this.flowData.lines : this.flowData.nodes
        const index = list.findIndex(item => item.id === this.currentSelect.id)
        if (index >= 0) {
          this.$set(list, index, this.currentSelect)
          this.isShowAttr = true;
        }
        else {
          this.isShowAttr = false;
        }

      }
    },
    schemeContent() {
      if (this.schemeContent && this.isEdit) {
        this.flowData = this.groupSchemeContent()
        this.flowData.status = flowConfig.flowStatus.MODIFY
        this.plumb && this.plumb.deleteEveryConnection()
        this.initJsPlumb()
        this.loadFlow()
      }
    }
  },
  methods: {
    ...mapActions({
      saveCurrentSelect: 'saveCurrentSelect'
    }),
    groupSchemeContent() {
      const obj = Object.assign({}, JSON.parse(this.schemeContent))
      if (!obj.attr || !obj.attr.id) {
        const { lines, nodes } = obj
        nodes.length > 0 && nodes.forEach(item => {
          item.setInfo = item.setInfo || {
            NodeRejectType: 0,
            NodeConfluenceType: '',
            NodeDesignate: '',
            ThirdPartyUrl: '',
            NodeDesignateData: {
              users: [],
              roles: [],
              Texts: ''
            }
          }
        })
        lines.length > 0 && lines.forEach(item => {
          item.label = item.label || item.name
          item.cls = {
            linkType: 'Flowchart',
            linkColor: '#2a2929',
            linkThickness: 2
          }
        })
        obj.attr = {
          id: obj.id || ''
        }
        obj.config = {
          showGrid: true,
          showGridText: '隐藏网格',
          showGridIcon: 'el-icon-view'
        }
      }
      return obj
    },
    handleMoveEnd() {
      this.isDrag = false
    },
    handleMoveStart({ oldIndex }) {
      console.log('oldIndex', oldIndex)
      this.isDrag = true
    },
    handleMove() {
      return true
    },
    getBrowserType() {
      const userAgent = navigator.userAgent
      const isOpera = userAgent.indexOf('Opera') > -1
      if (isOpera) {
        return 1
      }
      if (userAgent.indexOf('Firefox') > -1) {
        return 2
      }
      if (userAgent.indexOf('Chrome') > -1) {
        return 3
      }
      if (userAgent.indexOf('Safari') > -1) {
        return 4
      }
      if (userAgent.indexOf('compatible') > -1 && userAgent.indexOf('MSIE') > -1 && !isOpera) {
        alert('IE浏览器支持性较差，推荐使用Firefox或Chrome')
        return 5
      }
      if (userAgent.indexOf('Trident') > -1) {
        alert('Edge浏览器支持性较差，推荐使用Firefox或Chrome')
        return 6
      }
    },
    dealCompatibility() {
      const that = this

      that.browserType = that.getBrowserType()
      if (that.browserType === 2) {
        flowConfig.shortcut.scaleContainer = {
          code: 16,
          codeName: 'SHIFT(chrome下为ALT)',
          shortcutName: '画布缩放'
        }
      }
    },
    initJsPlumb() {
      const that = this

      that.plumb = jsPlumb.getInstance(flowConfig.jsPlumbInsConfig)
      this.loadFlowArea = true
      this.plumb.ready(() => {
        that.plumb.bind('beforeDrop', function (info) {
          const from = info.sourceId
          const to = info.targetId

          if (from === to) return false
          const filter = that.flowData.lines.filter(link => (link.from === from && link.to === to))
          if (filter.length > 0) {
            that.$message.error('同方向的两节点连线只能有一条！')
            return false
          }
          return true
        })
        let conunt = 0
        that.plumb.bind('connection', (conn) => {
          const connObj = conn.connection.canvas
          const o = {}
          let id = ''
          let label
          if (that.flowData.status === flowConfig.flowStatus.CREATE || that.flowData.status === flowConfig.flowStatus.MODIFY) {
            id = 'link-' + ZFSN.getId()
            label = ''
          } else if (that.flowData.status === flowConfig.flowStatus.LOADING) {
            const l = that.flowData.lines[conunt]
            id = l.id
            label = l.label
            conunt++
          }
          connObj.id = id
          o.type = 'sl'
          o.id = id
          o.from = conn.sourceId
          o.to = conn.targetId
          o.label = label
          o.cls = {
            linkType: flowConfig.jsPlumbInsConfig.Connector[0],
            linkColor: flowConfig.jsPlumbInsConfig.PaintStyle.stroke,
            linkThickness: flowConfig.jsPlumbInsConfig.PaintStyle.strokeWidth
          }
          document.getElementById(id).addEventListener('contextmenu', function (e) {
            that.showLinkContextMenu(e)
            const currentSelect = that.flowData.lines.filter(l => l.id === id)[0]
            that.saveCurrentSelect(currentSelect)
          })
          document.getElementById(id).addEventListener('click', function (e) {
            const event = window.event || e
            event.stopPropagation()
            const currentSelect = that.flowData.lines.filter(l => l.id === id)[0]
            const Compares = [{
              FieldName: '',
              Operation: '',
              Value: ''
            }]
            currentSelect.Compares = currentSelect.Compares || Compares
            that.saveCurrentSelect(currentSelect)
          })
          if (that.flowData.status !== flowConfig.flowStatus.LOADING) that.flowData.lines.push(o)
        })

        that.plumb.importDefaults({
          ConnectionsDetachable: flowConfig.jsPlumbConfig.conn.isDetachable
        })
      })
    },
    listenShortcut() {
      const that = this
      document.onkeydown = function (e) {
        const event = window.event || e

        if (!that.activeShortcut) return
        const key = event.keyCode

        switch (key) {
          case flowConfig.shortcut.multiple.code:
            that.$refs.flowArea.rectangleMultiple.flag = true
            break
          case flowConfig.shortcut.dragContainer.code:
            that.$refs.flowArea.container.dragFlag = true
            break
          case flowConfig.shortcut.scaleContainer.code:
            that.$refs.flowArea.container.scaleFlag = true
            break
          case flowConfig.shortcut.dragTool.code:
            that.selectTool('drag')
            break
          case flowConfig.shortcut.connTool.code:
            that.selectTool('connection')
            break
          case flowConfig.shortcut.zoomInTool.code:
            that.selectTool('zoom-in')
            break
          case flowConfig.shortcut.zoomOutTool.code:
            that.selectTool('zoom-out')
            break
          case 37:
            that.moveNode('left')
            break
          case 38:
            that.moveNode('up')
            break
          case 39:
            that.moveNode('right')
            break
          case 40:
            that.moveNode('down')
            break
          default:
            break
        }

        if (event.ctrlKey) {
          if (event.altKey) {
            switch (key) {
              case flowConfig.shortcut.settingModal.code:
                that.setting()
                break
              case flowConfig.shortcut.testModal.code:
                that.openTest()
                break
            }
          }
        }
      }
      document.onkeyup = function (e) {
        const event = window.event || e

        const key = event.keyCode
        if (key === flowConfig.shortcut.dragContainer.code) {
          that.$refs.flowArea.container.dragFlag = false
        } else if (key === flowConfig.shortcut.scaleContainer.code) {
          event.preventDefault()
          that.$refs.flowArea.container.scaleFlag = false
        } else if (key === flowConfig.shortcut.multiple.code) {
          that.$refs.flowArea.rectangleMultiple.flag = false
        }
      }
    },
    listenPage() {
      window.onbeforeunload = function (e) {
        e = e || window.event
        if (e) {
          e.returnValue = '关闭提示'
        }
        return '关闭提示'
      }
    },
    initFlow() {
      const that = this

      if (that.flowData.status === flowConfig.flowStatus.CREATE) {
        that.flowData.attr.id = 'flow-' + ZFSN.getId()
      } else {
        // that.loadFlow()
      }
    },
    loadFlow() {
      const that = this
      that.flowData.status = flowConfig.flowStatus.LOADING
      this.plumb.ready(() => {
        const lines = Object.assign([], that.flowData.lines)
        that.$nextTick(() => {
          lines.forEach((link) => {
            const conn = that.plumb.connect({
              source: link.from,
              target: link.to,
              anchor: flowConfig.jsPlumbConfig.anchor.default,
              connector: [
                link.cls.linkType,
                {
                  gap: 5,
                  cornerRadius: 8,
                  alwaysRespectStubs: true
                }
              ],
              paintStyle: {
                stroke: link.cls.linkColor,
                strokeWidth: link.cls.linkThickness
              }
            })
            if (link.label !== '') {
              conn.setLabel({
                label: link.label,
                cssClass: 'linkLabel'
              })
            }
          })
          const currentSelect = {}
          that.saveCurrentSelect(currentSelect)
          that.currentSelectGroup = []
          that.flowData.status = flowConfig.flowStatus.MODIFY
        })
      })
    },
    findNodeConfig(belongto, type, callback) {
      let node = null
      switch (belongto) {
        case 'commonNodes':
          node = commonNodes.filter(n => n.type === type)
          break
        case 'highNodes':
          node = highNodes.filter(n => n.type === type)
          break
        case 'laneNodes':
          node = laneNodes.filter(n => n.type === type)
          break
      }
      if (node && node.length >= 0) node = node[0]
      callback(node)
    },
    selectTool(type) {
      if (this.currentTool.type === type) {
        return
      }
      const tool = tools.filter(t => t.type === type)
      if (tool && tool.length >= 0) this.currentTool = tool[0]

      switch (type) {
        case 'drag':
          this.changeToDrag()
          break
        case 'connection':
          this.changeToConnection()
          break
        case 'zoom-in':
          this.changeToZoomIn()
          break
        case 'zoom-out':
          this.changeToZoomOut()
          break
      }
    },
    changeToDrag() {
      const that = this
      this.$nextTick(() => {
        that.flowData.nodes.forEach(function (node) {
          const f = that.plumb.toggleDraggable(node.id)
          if (!f) {
            that.plumb.toggleDraggable(node.id)
          }
          if (node.type !== 'x-lane' && node.type !== 'y-lane') {
            that.plumb.unmakeSource(node.id)
            that.plumb.unmakeTarget(node.id)
          }
        })
      })
    },
    changeToConnection() {
      const that = this
      that.flowData.nodes.forEach(function (node) {
        const f = that.plumb.toggleDraggable(node.id)
        if (f) {
          that.plumb.toggleDraggable(node.id)
        }
        if (node.type !== 'x-lane' && node.type !== 'y-lane') {
          that.plumb.makeSource(node.id, flowConfig.jsPlumbConfig.makeSourceConfig)
          that.plumb.makeTarget(node.id, flowConfig.jsPlumbConfig.makeTargetConfig)
        }
      })

      const currentSelect = {}
      that.saveCurrentSelect(currentSelect)
      that.currentSelectGroup = []
    },
    changeToZoomIn() {
      console.log('切换到放大工具')
    },
    changeToZoomOut() {
      console.log('切换到缩小工具')
    },
    checkFlow() {
      const that = this
      const nodes = that.flowData.nodes

      if (nodes.length <= 0) {
        this.$message.error('流程图中无任何节点！')
        return false
      }
      return true
    },
    saveFlow() {
      const that = this
      const flowObj = Object.assign({}, that.flowData)

      if (!that.checkFlow()) return
      flowObj.status = flowConfig.flowStatus.SAVE
      const d = JSON.stringify(flowObj)
      this.$message.success('保存流程成功！请查看控制台。')
      return d
    },
    // toImage() {
    //   const canvasSize = this.computeCanvasSize()
    //   const pbd = flowConfig.defaultStyle.photoBlankDistance
    //   const offsetPbd = ZFSN.div(pbd, 2)
    //   this.$refs.flowArea.toImage(canvasSize, pbd, offsetPbd).then(res => {
    //     this.flowPicture.url = res
    //     this.flowPicture.modalVisible = true
    //   })
    // },
    downLoadFlowPicture() {
      const that = this
      const alink = document.createElement('a')
      const alinkId = 'alink-' + ZFSN.getId()
      alink.id = alinkId
      alink.ref = alinkId
      alink.href = that.flowPicture.url
      alink.download = '流程设计图_' + that.flowData.attr.id + '.png'
      alink.click()
    },
    cancelDownLoadFlowPicture() {
      this.flowPicture.url = ''
      this.flowPicture.modalVisible = false
    },
    computeCanvasSize() {
      const that = this
      const nodes = Object.assign([], that.flowData.nodes)
      let minX = nodes[0].left
      let minY = nodes[0].top
      let maxX = nodes[0].left + nodes[0].width
      let maxY = nodes[0].top + nodes[0].height
      nodes.forEach(function (node) {
        minX = Math.min(minX, node.left)
        minY = Math.min(minY, node.top)
        maxX = Math.max(maxX, node.left + node.width)
        maxY = Math.max(maxY, node.top + node.height)
      })
      const canvasWidth = maxX - minX
      const canvasHeight = maxY - minY
      return {
        width: canvasWidth,
        height: canvasHeight,
        minX: minX,
        minY: minY,
        maxX: maxX,
        maxY: maxY
      }
    },
    clear() {
      const that = this
      that.flowData.nodes.forEach(function (node) {
        that.plumb.remove(node.id)
      })
      const currentSelect = {}
      that.saveCurrentSelect(currentSelect)
      that.currentSelectGroup = []
      that.flowData.nodes = []
      that.flowData.lines = []
      that.flowData.remarks = []
      this.isShowPopover = false
    },
    toggleShowGrid() {
      const flag = this.flowData.config.showGrid
      if (flag) {
        this.flowData.config.showGrid = false
        this.flowData.config.showGridText = '显示网格'
        this.flowData.config.showGridIcon = 'el-icon-view'
      } else {
        this.flowData.config.showGrid = true
        this.flowData.config.showGridText = '隐藏网格'
        this.flowData.config.showGridIcon = 'el-icon-view'
      }
    },
    setting() {
      this.$refs.settingModal.open()
    },
    shortcutHelper() {
      this.$refs.shortcutModal.open()
      this.isShowPopover = false
    },
    usingDoc() {
      window.open(this.info.gitee)
      this.isShowPopover = false
    },
    exit() {
      alert('退出流程设计器...')
    },
    showLinkContextMenu(e) {
      const event = window.event || e
      event.preventDefault()
      event.stopPropagation()
      const x = event.clientX
      const y = event.clientY
      this.linkContextMenuData.axis = { x, y }
    },
    deleteLink() {
      const that = this
      const from = that.currentSelect.from
      const to = that.currentSelect.to
      that.plumb.deleteConnection(that.plumb.getConnections({
        source: from,
        target: to
      })[0])
      const { lines } = that.flowData
      lines.splice(lines.findIndex(link => (link.from === from && link.to === to)), 1)
      that.flowData.lines = Object.assign([], lines)
      const currentSelect = {}
      that.saveCurrentSelect(currentSelect)
    },
    loseShortcut() {
      this.activeShortcut = false
    },
    getShortcut() {
      this.activeShortcut = true
    },
    openTest() {
      const that = this

      const flowObj = Object.assign({}, that.flowData)
      that.$refs.testModal.flowData = flowObj
      that.$refs.testModal.testVisible = true
    },
    moveNode(type) {
      const that = this

      let m = flowConfig.defaultStyle.movePx
      let isX = true
      switch (type) {
        case 'left':
          m = -m
          break
        case 'up':
          m = -m
          isX = false
          break
        case 'right':
          break
        case 'down':
          isX = false
      }

      if (that.currentSelectGroup.length > 0) {
        that.currentSelectGroup.forEach(function (node) {
          if (isX) {
            node.left += m
          } else {
            node.top += m
          }
        })
        that.plumb.repaintEverything()
      } else if (that.currentSelect.id) {
        const currentSelect = { ...that.currentSelect }
        if (isX) {
          currentSelect.left += m
        } else {
          currentSelect.top += m
        }
        that.saveCurrentSelect(currentSelect)
        that.plumb.repaintEverything()
      }
    }
  }
}
</script>

<style lang="scss">
@import './style/flow-designer.scss';

.tag {
  .el-checkbox-button__inner {
    padding: 0;
    display: inline-block;
    width: 64px;
    height: 22px;
    line-height: 22px;
    border: 0 !important;
    font-size: 12px;
    border-radius: 4px !important;
    color: #409EFF;
  }
}
</style>
