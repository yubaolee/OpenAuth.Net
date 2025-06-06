<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:19
 * @LastEditTime: 2025-04-20 13:37:59
 * @Description: 
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
<el-tooltip :disabled="isDisabled()" content="点击关闭 tooltip 功能">
  <div slot="content" v-if="contentHtml">
    <div v-html="contentHtml"></div>
  </div>
  <div v-if="node.type == 'start'"
    :id="node.id"
    class="common-circle-node node-start-bg node-start"
    :class="{ active: isActive() }"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <i :class="'iconfont icon-StartOP'" />
    {{ node.name }}
  </div>

  <div v-else-if="node.type == 'end'"
    :id="node.id"
    class="common-circle-node node-end"
    :class="{ active: isActive() }"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <i :class="'iconfont icon-End'" />
    {{ node.name }}
  </div>

  <div v-else-if="node.type === 'node'"
    :id="node.id"
    class="common-rectangle-node flex-row"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <el-icon :class="node.icon || node.defaultIcon || 'el-icon-s-tools'" />
    <span class="flex-item">{{ node.name }}</span>
  </div>

  <div v-else-if="node.type === 'fork'"
    :id="node.id"
    class="common-rectangle-node flex-row"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <span :class="node.icon || node.defaultIcon || 'iconfont icon-fork'" ></span>
    <span class="flex-item">{{ node.name }}</span>
  </div>

  <div v-else-if="node.type === 'join'"
    :id="node.id"
    class="common-rectangle-node flex-row"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <span :class="node.icon || node.defaultIcon || 'iconfont icon-gaibanxianxingtubiao-'" ></span>
    <span class="flex-item">{{ node.name }}</span>
  </div>

  <div v-else-if="node.type == 'multiInstance'"
    :id="node.id"
    class="common-rectangle-node flex-row"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <span :class="node.icon || node.defaultIcon || 'iconfont icon-bumenguanli'" ></span>
    <span class="flex-item">{{ node.name }}</span>
  </div>

  <div v-else-if="node.type == 'common'"
    :id="node.id"
    class="common-rectangle-node flex-row"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <el-icon :class="node.icon || node.defaultIcon" />
    <span class="flex-item">{{ node.name }}</span>
  </div>

  <div v-else-if="node.type == 'freedom'"
    :id="node.id"
    class="common-rectangle-node"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <i class="el-icon-refresh" />
    {{ node.name }}
  </div>

  <div v-else-if="node.type == 'event'"
    :id="node.id"
    class="common-circle-node"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
  {{ node.name }}
  </div>

  <div v-else-if="node.type == 'gateway'"
    :id="node.id"
    class="common-diamond-node"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                  (currentTool.type == 'zoom' ? 'zoom-in' :
                                                  (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
  </div>

  <div v-else-if="node.type == 'child-flow'"
    :id="node.id"
    class="common-rectangle-node"
    :class="stateClass()"
    :style="{ top: node.top + 'px', left: node.left + 'px',
    cursor: currentTool.type == 'drag' ? 'move' : (currentTool.type == 'connection' ? 'crosshair' :
                                                (currentTool.type == 'zoom-in' ? 'zoom-in' :
                                                (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default'))) }"
    @click.stop="selectNode"
    @contextmenu.stop="showNodeContextMenu">
    <a-icon type="api" class="node-icon" />
    {{ node.name }}
  </div>

  <vdr :id="node.id" class="common-x-lane-node"
    :class="{ laneActive: isActive() }"
    v-else-if="node.type == 'x-lane'"
    :w="node.width"
    :h="node.height"
    :style="{top: node.top + 'px', left: node.left + 'px',height: node.height + 'px', width: node.width + 'px',
          cursor: currentTool.type == 'zoom-in' ? 'zoom-in' : (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default')}"
    v-on:resizing="onResize" :parent="true">
    <div class="lane-text-div"
      :style="{ top: 0, left: 0, cursor: currentTool.type == 'drag' ? 'move' : 'default' }"
      @click.stop="selectNode"
      @contextmenu.stop="showNodeContextMenu">
      <span class="lane-text">{{ node.name }}</span>
    </div>
  </vdr>

  <vdr v-else-if="node.type == 'y-lane'"
    :id="node.id"
    class="common-y-lane-node"
    :class="{ laneActive: isActive() }"
    :w="node.width"
    :h="node.height"
    :style="{ top: node.top + 'px', left: node.left + 'px', height: node.height + 'px', width: node.width + 'px',
      cursor: currentTool.type == 'zoom-in' ? 'zoom-in' : (currentTool.type == 'zoom-out' ? 'zoom-out' : 'default') }"
    v-on:resizing="onResize">
    <div class="lane-text-div"
      :style="{ cursor: currentTool.type == 'drag' ? 'move' : 'default' }"
      @click.stop="selectNode"
      @contextmenu.stop="showNodeContextMenu">
      <span class="lane-text">{{ node.name }}</span>
    </div>
  </vdr>

  <div v-else></div>
</el-tooltip>
</template>

<script>
import { flowConfig } from '../config/args-config.js'
import vdr from 'vue-draggable-resizable-gorkys'
import 'vue-draggable-resizable-gorkys/dist/VueDraggableResizable.css'
import {mapGetters, mapActions} from 'vuex'

export default {
  props: ['select', 'selectGroup', 'node', 'plumb', 'currentTool', 'isShowContent'],
  components: {
    vdr
  },
  mounted() {
    if (this.isShowContent) {
      return
    }
    this.registerNode()
  },
  data() {
    return {
      contentHtml: '',
      // currentSelect: this.select,
      currentSelectGroup: this.selectGroup,
      setInfo: {
        NodeRejectType: 0, // 驳回类型
        NodeConfluenceType: '', // 会签方式
        NodeDesignate: '', // 节点权限方式
        ThirdPartyUrl: '', // 三方回调URL
        NodeDesignateData: {
          // 节点指定操作人
          users: [],
          roles: [],
          orgs: [],
          Texts: ''
        }
      }
    }
  },
  computed: {
    ...mapGetters({
      currentSelect: 'currentSelect'
    })
  },
  methods: {
    ...mapActions({
      saveCurrentSelect: 'saveCurrentSelect'
    }),
    onResize: function(x, y, width, height) {
      this.node.width = width
      this.node.height = height
    },
    registerNode() {
      const that = this
      that.node.id && that.plumb.draggable(that.node.id, {
        containment: 'parent',
        handle: function(e, el) {
          var possibles = el.parentNode.querySelectorAll('.common-circle-node,.common-rectangle-node,.common-diamond-node,.lane-text-div')
          for (var i = 0; i < possibles.length; i++) {
            if (possibles[i] === el || e.target.className === 'lane-text') return true
          }
          return false
        },
        grid: flowConfig.defaultStyle.alignGridPX,
        drag: function(e) {
          if (that.node.type === 'x-lane' || that.node.type === 'y-lane') {
            that.node.left = e.pos[0]
            that.node.top = e.pos[1]
          }
          if (flowConfig.defaultStyle.isOpenAuxiliaryLine) {
            that.$emit('alignForLine', e)
          }
        },
        stop: function(e) {
          if (that.node.type !== 'x-lane' && that.node.type !== 'y-lane') {
            that.node.left = e.pos[0]
            that.node.top = e.pos[1]
          }
          if (that.currentSelectGroup.length > 1) {
            that.$emit('updateNodePos')
          }
          that.$emit('hideAlignLine')
        }
      })
      const currentSelect = { ...that.node, setInfo: that.node.setInfo || this.setInfo }
      that.saveCurrentSelect(currentSelect)
      that.currentSelectGroup = []
    },
    selectNode() {
      if (this.currentSelectGroup.length > 0) {
        return
      }
      const that = this
      const currentSelect = Object.assign({}, this.node)
      that.saveCurrentSelect(currentSelect)
      that.$emit('isMultiple', flag => {
        if (!flag) {
          that.currentSelectGroup = []
        } else {
          const f = that.currentSelectGroup.filter(s => s.id === that.node.id)
          if (f.length <= 0) {
            that.plumb.addToDragSelection(that.node.id)
            that.currentSelectGroup.push(that.node)
          }
        }
      })
    },
    showNodeContextMenu(e) {
      this.$emit('showNodeContextMenu', e)
      this.selectNode()
    },
    stateClass() {
      let classname = ''
      if (this.isActive()) {
        classname += 'active'
      }
      if (this.node.setInfo !== undefined && this.node.setInfo !== null && this.node.setInfo.Taged !== undefined && this.node.setInfo.Taged !== null) {
        if (this.node.setInfo.Taged === 2) {
          classname += ' node-not-bg'
        } else if (this.node.setInfo.Taged === 1) {
          classname += ' node-pass-bg'
        } else {
          classname += ' node-back-bg'
        }
      }
      return classname
    },
    isActive() {
      const that = this
      if (that.currentSelect.id === that.node.id) return true
      const f = that.currentSelectGroup.filter(n => n.id === that.node.id)
      if (f.length > 0) return true
      return false
    },
    isDisabled() {
      let flag = true
      if (this.node.setInfo !== undefined && this.node.setInfo !== null && this.node.setInfo.Taged !== undefined && this.node.setInfo.Taged !== null) {
        let tips = '<div style="text-align:left">'
        const tagname = { '1': '通过', '2': '不通过', '3': '驳回' }
        tips += '<p>处理人：' + this.node.setInfo.UserName + '</p>'
        tips += '<p>结果：' + tagname[this.node.setInfo.Taged] + '</p>'
        tips += '<p>处理时间：' + this.node.setInfo.TagedTime + '</p>'
        tips += '<p>备注：' + this.node.setInfo.Description + '</p></div>'
        this.contentHtml = tips
        flag = false
      }
      return flag
    }
  },
  watch: {
    selectGroup(val) {
      this.currentSelectGroup = val
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
	@import '../style/flow-node.scss';
  .node-loading-bg{
    background: #5bc0de;
    color: #fff;
  }
  .node-not-bg{
    background: #d9534f;
    color: #fff;
  }
  .node-pass-bg{
    background: #5cb85c;
    color: #fff;
  }
  .node-back-bg{
    background: #f0ad4e;
    color: #fff;
  }
</style>
