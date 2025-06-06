<template>
	<div style="width: 100%; height: 100%; overflow: hidden; position: relative;" ref="flowContainer">
    <!-- <div v-if="container.auxiliaryLine.isOpen && container.auxiliaryLine.isShowXLine" class="auxiliary-line-x" :style="{ top: auxiliaryLinePos.top + 'px' }"></div>
    <div v-if="container.auxiliaryLine.isOpen && container.auxiliaryLine.isShowYLine" class="auxiliary-line-y" :style="{ left: auxiliaryLinePos.left + 'px' }"></div> -->
    <div v-if="isShowContent" class="states-box">
      <span v-for="item in states" :key="item.type" class="state-item">
        <span :class="item.className"></span>
        <p>{{item.name}}</p>
      </span>
    </div>
    <draggable id="toDraggable"
        v-model="flowData.nodes"
        tag="div"
        v-bind="{group:'flow',animation: 200}"
        @end="handleMoveEnd"
        @add="handleAddFormItem" class="flow-container" style="cursor: pointer;"
      :class="{zoomIn: currentTool.type == 'zoom-in', zoomOut: currentTool.type == 'zoom-out', canScale: container.scaleFlag, canDrag: container.dragFlag, canMultiple: rectangleMultiple.flag }"
      :style="{ top: container.pos.top + 'px', left: container.pos.left + 'px', transform: 'scale(' + container.scale + ')', transformOrigin: container.scaleOrigin.left + 'px ' + container.scaleOrigin.top + 'px', 'z-index': isDrag ? 11 : -2 }"
      >
    </draggable>
    <div id="flowContainer" ref="flowContainers" class="flow-container" style="cursor: pointer;"
      :class="{ grid: flowData.config.showGrid, zoomIn: currentTool.type == 'zoom-in', zoomOut: currentTool.type == 'zoom-out', canScale: container.scaleFlag, canDrag: container.dragFlag, canMultiple: rectangleMultiple.flag }"
      :style="{ top: container.pos.top + 'px', left: container.pos.left + 'px', transform: 'scale(' + container.scale + ')', transformOrigin: container.scaleOrigin.left + 'px ' + container.scaleOrigin.top + 'px' }"
      @click.stop="containerHandler"
      @mousedown="mousedownHandler"
      @mousemove="mousemoveHandler"
      @mouseup="mouseupHandler"
      @mousewheel="scaleContainer"
      @DOMMouseScroll="scaleContainer"
      @contextmenu="showContainerContextMenu">
        <template v-for="node in flowData.nodes">
          <flow-node
            :key="node.id"
            v-if="node && node.id"
            :node="node"
            :plumb="plumb"
            :select.sync="currentSelect"
            :selectGroup.sync="currentSelectGroup"
            :currentTool="currentTool"
            :isShowContent="isShowContent"
            @showNodeContextMenu="showNodeContextMenu"
            @isMultiple="isMultiple"
            @updateNodePos="updateNodePos"
            @alignForLine="alignForLine"
            @hideAlignLine="hideAlignLine">
          </flow-node>
        </template>
      <!-- <div class="rectangle-multiple" v-if="rectangleMultiple.flag && rectangleMultiple.multipling"
        :style="{ top: rectangleMultiple.position.top + 'px', left: rectangleMultiple.position.left + 'px', width: rectangleMultiple.width + 'px', height: rectangleMultiple.height + 'px' }">
      </div> -->
    </div>
		<!-- <div class="container-scale">
			缩放倍数：{{ container.scaleShow }}%
		</div> -->
		<!-- <div class="mouse-position">
			x: {{ mouse.position.left }}, y: {{ mouse.position.top }}
		</div> -->
		<!-- <vue-context-menu
			:contextMenuData="containerContextMenuData"
			@flowInfo="flowInfo"
			@paste="paste"
			@selectAll="selectAll"
			@saveFlow="saveFlow"
			@verticaLeft="verticaLeft"
			@verticalCenter="verticalCenter"
			@verticalRight="verticalRight"
			@levelUp="levelUp"
			@levelCenter="levelCenter"
			@levelDown="levelDown"
			@addRemark="addRemark">
		</vue-context-menu> -->
		<vue-context-menu
			:contextMenuData="containerContextMenuData"
			@paste="paste"
			@selectAll="selectAll"
			@saveFlow="saveFlow"
			@verticaLeft="verticaLeft"
			@verticalCenter="verticalCenter"
			@verticalRight="verticalRight"
			@levelUp="levelUp"
			@levelCenter="levelCenter"
			@levelDown="levelDown">
		</vue-context-menu>
		<vue-context-menu
			:contextMenuData="nodeContextMenuData"
			@copyNode="copyNode"
			@deleteNode="deleteNode">
		</vue-context-menu>
	</div>
</template>

<script>
import draggable from 'vuedraggable'
import { flowConfig } from '../config/args-config.js'
import { ZFSN } from '../util/ZFSN.js'
import FlowNode from './FlowNode'
import {mapGetters, mapActions} from 'vuex'
// import { connect } from 'tls';
// import html2canvas from 'html2canvas'
// import canvg from 'canvg'

export default {
  props: ['browserType', 'flowData', 'plumb', 'select', 'selectGroup', 'currentTool', 'isShowContent', 'isDrag'],
  components: {
    draggable,
    FlowNode
  },
  data() {
    return {
      ctx: null,
      // currentSelect: this.select,
      currentSelectGroup: this.selectGroup,
      states: [{
        type: '4',
        name: '审核中',
        className: 'node-bg'
      }, {
        type: '1',
        name: '通过',
        className: 'node-pass-bg'
      }, {
        type: '2',
        name: '不通过',
        className: 'node-not-bg'
      }, {
        type: '0',
        name: '驳回',
        className: 'node-back-bg'
      }],
      container: {
        pos: {
          top: -3000,
          left: -3000
        },
        startPos: {
          startMove: false,
          x: 0,
          y: 0
        },
        endPos: {
          x: 0,
          y: 0
        },
        dragFlag: false,
        draging: false,
        scale: flowConfig.defaultStyle.containerScale.init,
        scaleFlag: false,
        scaleOrigin: {
          left: 0, top: 0
        },
        scaleShow: ZFSN.mul(flowConfig.defaultStyle.containerScale.init, 100),
        auxiliaryLine: {
          isOpen: flowConfig.defaultStyle.isOpenAuxiliaryLine,
          isShowXLine: false,
          isShowYLine: false,
          controlFnTimesFlag: true
        }
      },
      auxiliaryLinePos: {
        left: 0, top: 0
      },
      mouse: {
        position: {
          left: 0, top: 0
        },
        tempPos: {
          left: 0, top: 0
        }
      },
      rectangleMultiple: {
        flag: false,
        multipling: false,
        position: {
          top: 0, left: 0
        },
        height: 0,
        width: 0
      },
      containerContextMenuData: flowConfig.contextMenu.container,
      nodeContextMenuData: flowConfig.contextMenu.node,
      tempLinkId: '',
      clipboard: []
    }
  },
  computed: {
    ...mapGetters({
      currentSelect: 'currentSelect'
    })
  },
  mounted() {},
  methods: {
    ...mapActions({
      saveCurrentSelect: 'saveCurrentSelect'
    }),
    handleMoveEnd({ newIndex, oldIndex }) {
      console.log(newIndex, oldIndex)
    },
    // toImage() {
    //   const $Container = this.$refs.flowContainer
    //   const svgElems = []
    //   for (let i = 0; i < $Container.getElementsByTagName('svg').length; i++) {
    //     const id = $Container.getElementsByTagName('svg')[i].getAttribute('id')
    //     if (id && id.indexOf('link-') >= 0) {
    //       svgElems.push($Container.getElementsByTagName('svg')[i])
    //     }
    //   }
    //   var nodesToRecover = []
    //   var nodesToRemove = []
    //   svgElems.forEach((node, index) => {
    //     var parentNode = node.parentNode
    //     var svg = node.outerHTML.trim()

    //     var canvas = document.createElement('canvas')
    //     canvg(canvas, svg)
    //     if (node.style.position) {
    //       canvas.style.position += node.style.position
    //       canvas.style.left += node.style.left
    //       canvas.style.top += node.style.top
    //     }

    //     nodesToRecover.push({
    //       parent: parentNode,
    //       child: node
    //     })
    //     parentNode.removeChild(node)

    //     nodesToRemove.push({
    //       parent: parentNode,
    //       child: canvas
    //     })

    //     parentNode.appendChild(canvas)
    //   })
    //   return new Promise((resolve, reject) => {
    //     html2canvas(this.$refs.flowContainer, {
    //       dpi: window.devicePixelRatio,
    //       scale: 1
    //     }).then(canvas => {
    //       const dataURL = canvas.toDataURL('image/png')
    //       resolve(dataURL)
    //     })
    //   })
    // },
    handleAddFormItem(evt) {
      const flag = evt.originalEvent.target.className.indexOf('common-x-lane-node') >= 0 || evt.originalEvent.target.className.indexOf('common-y-lane-node') >= 0
      this.mouse.position.left = flag ? evt.originalEvent.offsetX + evt.originalEvent.target.offsetLeft : evt.originalEvent.offsetX
      this.mouse.position.top = flag ? evt.originalEvent.offsetY + evt.originalEvent.target.offsetTop : evt.originalEvent.offsetY
      this.$nextTick(() => {
        // const newIndex = evt.newIndex > this.flowData.nodes.length - 1 ? this.flowData.nodes.length - 1 : evt.newIndex
        const newIndex = evt.newIndex
        const type = this.flowData.nodes[newIndex].type
        const belongto = this.flowData.nodes[newIndex].belongto

        this.$emit('findNodeConfig', belongto, type, node => {
          if (!node) {
            this.$message.error('未知的节点类型！')
            return
          }
          this.addNewNode(node, newIndex)
        })
      })
    },
    addNewNode(node, index) {
      const that = this
      let x = that.mouse.position.left
      let y = that.mouse.position.top
      const nodePos = that.computeNodePos(x, y)
      x = nodePos.left
      y = nodePos.top

      const newNode = Object.assign({}, node)
      newNode.id = newNode.type + '-' + ZFSN.getId()
      newNode.height = 50
      if (newNode.type === 'start' || newNode.type === 'end' ||
					newNode.type === 'event' || newNode.type === 'gateway') {
        newNode.left = x - 25
        newNode.width = 50
      } else {
        newNode.left = x - 60
        newNode.width = 120
      }
      newNode.top = y - 25
      if (newNode.type === 'x-lane') {
        newNode.height = 200
        newNode.width = 600
      } else if (newNode.type === 'y-lane') {
        newNode.height = 600
        newNode.width = 200
      }
      this.$set(this.flowData.nodes, index, { ...newNode })
      this.$emit('selectTool', 'drag')
    },
    computeNodePos(x, y) {
      const pxx = flowConfig.defaultStyle.alignGridPX[0]
      const pxy = flowConfig.defaultStyle.alignGridPX[1]
      if (x % pxx) x = pxx - (x % pxx) + x
      if (y % pxy) y = pxy - (y % pxy) + y
      return {
        left: x,
        top: y
      }
    },
    mousedownHandler(e) {
      const that = this

      const event = window.event || e
      that.container.startPos = {
        startMove: true,
        x: event.clientX,
        y: event.clientY,
        l: this.$refs.flowContainers.offsetLeft,
        t: this.$refs.flowContainers.offsetTop
      }
      if (event.button === 0) {
        if (that.container.dragFlag) {
          that.mouse.tempPos = that.mouse.position
          that.container.draging = true
        }

        that.currentSelectGroup = []
        if (that.rectangleMultiple.flag) {
          that.mouse.tempPos = that.mouse.position
          that.rectangleMultiple.multipling = true
        }
      }
    },
    mousemoveHandler(e) {
      const that = this

      const event = window.event || e

      if (that.container.startPos.startMove) {
        that.container.endPos = {
          x: event.clientX,
          y: event.clientY
        }

        const YM = that.container.endPos.y - (that.container.startPos.y - that.container.startPos.t)
        const XM = that.container.endPos.x - (that.container.startPos.x - that.container.startPos.l)
        const yFlag = Math.abs(that.container.endPos.y - that.container.startPos.y) >= 20
        const xFlag = Math.abs(that.container.endPos.x - that.container.startPos.x) >= 20
        that.container.pos = {
          top: yFlag ? YM : that.container.pos.top,
          left: xFlag ? XM : that.container.pos.left
        }
      }
      if (event.target.id === 'flowContainer') {
        that.mouse.position = {
          left: event.offsetX,
          top: event.offsetY
        }
      } else {
        const cn = event.target.className
        const tn = event.target.tagName
        if (cn !== 'lane-text' && cn !== 'lane-text-div' && tn !== 'svg' && tn !== 'path' && tn !== 'I') {
          that.mouse.position.left = event.target.offsetLeft + event.offsetX
          that.mouse.position.top = event.target.offsetTop + event.offsetY
        }
      }
      if (that.container.draging) {
        let nTop = that.container.pos.top + (that.mouse.position.top - that.mouse.tempPos.top)
        let nLeft = that.container.pos.left + (that.mouse.position.left - that.mouse.tempPos.left)
        if (nTop >= 0) nTop = 0
        if (nLeft >= 0) nLeft = 0
        that.container.pos = {
          top: nTop,
          left: nLeft
        }
      }
      if (that.rectangleMultiple.multipling) {
        let h = that.mouse.position.top - that.mouse.tempPos.top
        let w = that.mouse.position.left - that.mouse.tempPos.left
        let t = that.mouse.tempPos.top
        let l = that.mouse.tempPos.left
        if (h >= 0 && w < 0) {
          w = -w
          l -= w
        } else if (h < 0 && w >= 0) {
          h = -h
          t -= h
        } else if (h < 0 && w < 0) {
          h = -h
          w = -w
          t -= h
          l -= w
        }
        that.rectangleMultiple.height = h
        that.rectangleMultiple.width = w
        that.rectangleMultiple.position.top = t
        that.rectangleMultiple.position.left = l
      }
    },
    mouseupHandler() {
      const that = this
      that.container.startPos.startMove = false

      if (that.container.draging) that.container.draging = false
      if (that.rectangleMultiple.multipling) {
        that.judgeSelectedNode()
        that.rectangleMultiple.multipling = false
        that.rectangleMultiple.width = 0
        that.rectangleMultiple.height = 0
      }
    },
    judgeSelectedNode() {
      const that = this

      const ay = that.rectangleMultiple.position.top
      const ax = that.rectangleMultiple.position.left
      const by = ay + that.rectangleMultiple.height
      const bx = ax + that.rectangleMultiple.width

      const nodes = that.flowData.nodes
      nodes.forEach(function(node) {
        if (node.top >= ay && node.left >= ax && node.top <= by && node.left <= bx) {
          that.plumb.addToDragSelection(node.id)
          that.currentSelectGroup.push(node)
        }
      })
    },
    scaleContainer(e) {
      e.preventDefault()
      const that = this

      const event = window.event || e
      // console.log(window.event.wheelDelta, that.container.scaleFlag, that.browserType, that.container.scale)

      if (that.container.scaleFlag) {
        if (that.browserType === 2) {
          if (event.detail < 0) {
            that.enlargeContainer()
          } else {
            that.narrowContainer()
          }
        } else {
          if (event.deltaY < 0) {
            that.enlargeContainer()
          } else if (that.container.scale) {
            that.narrowContainer()
          }
        }
      } else {
        if (event.wheelDelta > 0) {
            that.enlargeContainer()
          } else {
            that.narrowContainer()
          }
      }
    },
    enlargeContainer() {
      const that = this
      that.container.scaleOrigin.left = that.mouse.position.left
      that.container.scaleOrigin.top = that.mouse.position.top
      const newScale = ZFSN.add(that.container.scale, flowConfig.defaultStyle.containerScale.onceEnlarge)
      if (newScale <= flowConfig.defaultStyle.containerScale.max) {
        that.container.scale = newScale
        that.container.scaleShow = ZFSN.mul(that.container.scale, 100)
        that.plumb.setZoom(that.container.scale)
      }
    },
    narrowContainer() {
      const that = this
      that.container.scaleOrigin.left = that.mouse.position.left
      that.container.scaleOrigin.top = that.mouse.position.top
      const newScale = ZFSN.sub(that.container.scale, flowConfig.defaultStyle.containerScale.onceNarrow)
      if (newScale >= flowConfig.defaultStyle.containerScale.min) {
        that.container.scale = newScale
        that.container.scaleShow = ZFSN.mul(that.container.scale, 100)
        that.plumb.setZoom(that.container.scale)
      }
    },
    showContainerContextMenu(e) {
      const event = window.event || e

      event.preventDefault()
      this.selectContainer()
      const x = event.clientX
      const y = event.clientY
      this.containerContextMenuData.axis = { x, y }
    },
    showNodeContextMenu(e) {
      const event = window.event || e

      event.preventDefault()
      const x = event.clientX
      const y = event.clientY
      this.nodeContextMenuData.axis = { x, y }
    },
    flowInfo() {
      const that = this

      const nodes = that.flowData.nodes
      const lines = that.flowData.lines
      alert('当前流程图中有 ' + nodes.length + ' 个节点，有 ' + lines.length + ' 条连线。')
    },
    paste() {
      const that = this
      let dis = 0
      that.clipboard.forEach(function(node) {
        const newNode = Object.assign({}, node)
        newNode.id = newNode.type + '-' + ZFSN.getId()
        const nodePos = that.computeNodePos(that.mouse.position.left + dis, that.mouse.position.top + dis)
        newNode.left = nodePos.left
        newNode.top = nodePos.top
        dis += 20
        that.flowData.nodes.push(newNode)
      })
    },
    selectAll() {
      const that = this
      that.flowData.nodes.forEach(function(node) {
        that.plumb.addToDragSelection(node.id)
        that.currentSelectGroup.push(node)
      })
    },
    saveFlow() {
      this.$emit('saveFlow')
    },
    checkAlign() {
      if (this.currentSelectGroup.length < 2) {
        this.$message.error('请选择至少两个节点！')
        return false
      }
      return true
    },
    verticaLeft() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      const baseX = selectGroup[0].left
      let baseY = selectGroup[0].top
      for (let i = 1; i < selectGroup.length; i++) {
        baseY = baseY + selectGroup[i - 1].height + flowConfig.defaultStyle.alignSpacing.vertical
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    verticalCenter() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      let baseX = selectGroup[0].left
      let baseY = selectGroup[0].top
      const firstX = baseX
      for (let i = 1; i < selectGroup.length; i++) {
        baseY = baseY + selectGroup[i - 1].height + flowConfig.defaultStyle.alignSpacing.vertical
        baseX = firstX + ZFSN.div(selectGroup[0].width, 2) - ZFSN.div(selectGroup[i].width, 2)
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    verticalRight() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      let baseX = selectGroup[0].left
      let baseY = selectGroup[0].top
      const firstX = baseX
      for (let i = 1; i < selectGroup.length; i++) {
        baseY = baseY + selectGroup[i - 1].height + flowConfig.defaultStyle.alignSpacing.vertical
        baseX = firstX + selectGroup[0].width - selectGroup[i].width
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    levelUp() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      let baseX = selectGroup[0].left
      const baseY = selectGroup[0].top
      for (let i = 1; i < selectGroup.length; i++) {
        baseX = baseX + selectGroup[i - 1].width + flowConfig.defaultStyle.alignSpacing.level
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    levelCenter() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      let baseX = selectGroup[0].left
      let baseY = selectGroup[0].top
      const firstY = baseY
      for (let i = 1; i < selectGroup.length; i++) {
        baseY = firstY + ZFSN.div(selectGroup[0].height, 2) - ZFSN.div(selectGroup[i].height, 2)
        baseX = baseX + selectGroup[i - 1].width + flowConfig.defaultStyle.alignSpacing.level
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    levelDown() {
      const that = this

      if (!that.checkAlign()) return
      const nodes = that.flowData.nodes
      const selectGroup = that.currentSelectGroup
      let baseX = selectGroup[0].left
      let baseY = selectGroup[0].top
      const firstY = baseY
      for (let i = 1; i < selectGroup.length; i++) {
        baseY = firstY + selectGroup[0].height - selectGroup[i].height
        baseX = baseX + selectGroup[i - 1].width + flowConfig.defaultStyle.alignSpacing.level
        const f = nodes.filter(n => n.id === selectGroup[i].id)[0]
        f.tx = baseX
        f.ty = baseY
        that.plumb.animate(selectGroup[i].id, { top: baseY, left: baseX }, {
          duration: flowConfig.defaultStyle.alignDuration,
          complete: function() {
            f.left = f.tx
            f.top = f.ty
          }
        })
      }
    },
    addRemark() {
      // alert('添加备注(待完善)...')
      // to do
    },
    copyNode() {
      const that = this

      that.clipboard = []
      if (that.currentSelectGroup.length > 0) {
        that.clipboard = Object.assign([], that.currentSelectGroup)
      } else if (that.currentSelect.id) {
        that.clipboard.push(that.currentSelect)
      }
    },
    getConnectionsByNodeId(nodeId) {
      const that = this
      const conns1 = that.plumb.getConnections({
        source: nodeId
      })
      const conns2 = that.plumb.getConnections({
        target: nodeId
      })
      return conns1.concat(conns2)
    },
    deleteNode() {
      const that = this
      const nodes = that.flowData.nodes
      const lines = that.flowData.lines
      that.flowData.lines = lines.filter(link => (link.from !== this.currentSelect.id && link.to !== this.currentSelect.id))
      that.plumb.deleteConnectionsForElement(this.currentSelect.id)
      const inx = nodes.findIndex(node => node.id === this.currentSelect.id)
      nodes.splice(inx, 1)
      that.selectContainer()
    },
    handleConnect() {
      const that = this
      that.$nextTick(() => {
        const attrLines = [...that.flowData.lines]
        attrLines.forEach(function(link) {
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
      })
    },
    containerHandler() {
      const that = this

      that.selectContainer()
      const toolType = that.currentTool.type
      if (toolType === 'zoom-in') {
        that.enlargeContainer()
      } else if (toolType === 'zoom-out') {
        that.narrowContainer()
      }
    },
    selectContainer() {
      const currentSelect = {}
      this.saveCurrentSelect(currentSelect)
      this.$emit('getShortcut')
    },
    isMultiple(callback) {
      callback(this.rectangleMultiple.flag)
    },
    updateNodePos() {
      const that = this

      const nodes = that.flowData.nodes
      that.currentSelectGroup.forEach(function(node) {
        const l = parseInt(document.getElementById(node.id).style.left)
        const t = parseInt(document.getElementById(node.id).style.top)
        const f = nodes.filter(n => n.id === node.id)[0]
        f.left = l
        f.top = t
      })
    },
    alignForLine(e) {
      const that = this
      if (that.selectGroup.length > 1) return
      if (that.container.auxiliaryLine.controlFnTimesFlag) {
        const elId = e.el.id
        const nodes = that.flowData.nodes
        nodes.forEach(function(node) {
          if (elId !== node.id) {
            const dis = flowConfig.defaultStyle.showAuxiliaryLineDistance
            const elPos = e.pos
            const elH = e.el.offsetHeight
            const elW = e.el.offsetWidth
            const disX = elPos[0] - node.left
            const disY = elPos[1] - node.top
            if ((disX >= -dis && disX <= dis) || ((disX + elW) >= -dis && (disX + elW) <= dis)) {
              that.container.auxiliaryLine.isShowYLine = true
              that.auxiliaryLinePos.left = node.left + that.container.pos.left
              const nodeMidPointX = node.left + (node.width / 2)
              if (nodeMidPointX === (elPos[0] + (elW / 2))) {
                that.auxiliaryLinePos.left = nodeMidPointX + that.container.pos.left
              }
            }
            if ((disY >= -dis && disY <= dis) || ((disY + elH) >= -dis && (disY + elH) <= dis)) {
              that.container.auxiliaryLine.isShowXLine = true
              that.auxiliaryLinePos.top = node.top + that.container.pos.top
              const nodeMidPointY = node.top + (node.height / 2)
              if (nodeMidPointY === (elPos[1] + (elH / 2))) {
                that.auxiliaryLinePos.top = nodeMidPointY + that.container.pos.left
              }
            }
          }
        })
        that.container.auxiliaryLine.controlFnTimesFlag = false
        setTimeout(function() {
          that.container.auxiliaryLine.controlFnTimesFlag = true
        }, 200)
      }
    },
    hideAlignLine() {
      if (this.container.auxiliaryLine.isOpen) {
        this.container.auxiliaryLine.isShowXLine = false
        this.container.auxiliaryLine.isShowYLine = false
      }
    }
  },
  watch: {
    currentSelect() {
      // this.currentSelect = val
      if (this.tempLinkId !== '') {
        document.getElementById(this.tempLinkId) && document.getElementById(this.tempLinkId).classList && document.getElementById(this.tempLinkId).classList.remove('link-active')
        this.tempLinkId = ''
      }
      if (this.currentSelect.type === 'sl') {
        this.tempLinkId = this.currentSelect.id
        document.getElementById(this.currentSelect.id).classList.add('link-active')
      }
    },
    selectGroup(val) {
      this.currentSelectGroup = val
      if (this.currentSelectGroup.length <= 0) this.plumb.clearDragSelection()
    },
    currentSelectGroup: {
      handler(val) {
        this.$emit('update:selectGroup', val)
      },
      deep: true
    }
  }
}
</script>

<style lang="scss">
  @import '../style/flow-area.scss';
  .sortable-chosen.ghost{
    display: none
  }
  .states-box{
    position: absolute;
    top: 10px;
    right: 10px;
    z-index: 999;
    .state-item{
      display: inline-block;
      margin-left: 10px;
      text-align: center;
      >p{
        margin: 0;
        font-size: 12px;
      }
      >span{
        display: inline-block;
        width: 15px;
        height: 15px;
        border-radius: 2px;
        box-sizing: border-box;
        &.node-bg{
          border: 1px solid #777;
          background: #f4f6fc;
        }
        &.node-not-bg{
          background: #d9534f;
          color: #fff;
        }
        &.node-pass-bg{
          background: #5cb85c;
          color: #fff;
        }
        &.node-back-bg{
          background: #f0ad4e;
          color: #fff;
        }
      }
    }
  }
</style>
