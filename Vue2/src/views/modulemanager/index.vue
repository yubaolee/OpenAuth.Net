<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:34
 * @LastEditTime: 2025-04-08 09:25:28
 * @Description: 模块管理
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->
<template>
  <div class="flex-column">
    <sticky :className="'sub-navbar'">
      <div class="filter-container">
        <el-input @keyup.enter.native="handleFilter" size="mini" prefix-icon="el-icon-search"
          style="width: 200px;margin-bottom: 0;" class="filter-item" :placeholder="'关键字'" v-model="listQuery.key">
        </el-input>
        <permission-btn :size="'mini'" v-on:btn-event="onBtnClicked"></permission-btn>
        <el-checkbox size="mini" class="m-l-15" @change='tableKey = tableKey + 1' v-model="showDescription">Id/描述
        </el-checkbox>
      </div>
    </sticky>
    <div class="app-container flex-item">
      <el-row class="fh">
        <el-col :span="10" class="fh ls-border">
          <el-card shadow="never" class="card-body-none fh" style="overflow-y: auto">
            <div slot="header" class="clearfix">
              <el-button type="text" style="padding: 0 11px" @click="getAllMenus">所有菜单>></el-button>
            </div>
            <tree-table ref="menuTable" highlight-current-row :data="modulesTree" :columns="columns"
              @row-click="treeClick" border>
            </tree-table>
          </el-card>
        </el-col>
        <el-col :span="14" class="fh">
          <div class="bg-white fh">
            <!-- 挂载打印方案 -->
            <el-row>
              <el-col :span="24">
                <el-tag :key="tag.id" size="small" v-for="tag in modulePlans" closable :disable-transitions="false"
                  @close="handleClose(tag)">
                  {{ tag.name }}
                </el-tag>
                <el-select :value="selectedPlan" size="small" ref="saveTagInput" v-if="newPlanSelVisible" @change="change"
                  placeholder="请选择">
                  <el-option v-for="item in canSelPrinterPlans" :key="item.id" :label="item.name" :value="item.id">
                  </el-option>
                </el-select>
                <el-button v-else class="button-new-tag" size="small" @click="showNewPlan">+ 挂新打印方案</el-button>

                <el-tag :key="tag.id" size="small" v-for="tag in flowschemes" closable :disable-transitions="false"
                  @close="handleCloseFlowscheme(tag)">
                  {{ tag.schemeName }}
                </el-tag>
                  <el-select :value="selectedFlowscheme" size="small" ref="saveTagInput" v-if="newFlowschemeSelVisible" @change="changeFlowscheme"
                  placeholder="请选择">
                  <el-option v-for="item in canSelFlowschemes" :key="item.id" :label="item.schemeName" :value="item.id">
                  </el-option>
                </el-select>
                <el-button v-else class="button-new-tag" size="small" @click="showNewFlowscheme">+ 挂新送审方案</el-button>
              </el-col>
            </el-row>
            <!-- 菜单按钮列表 -->
            <el-table ref="mainTable" :key='tableKey' :data="currentPageMenus" v-loading="listLoading" border fit
              highlight-current-row style="width: 100%;" height="calc(100% - 100px)" @row-click="rowClick"
              @selection-change="handleSelectionChange">
              <el-table-column type="selection" align="center" width="55">
              </el-table-column>
              <el-table-column :label="'Id'" v-if="showDescription" min-width="120px">
                <template slot-scope="scope">
                  <span>{{ scope.row.id }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'DOM ID'">
                <template slot-scope="scope">
                  <span class="link-type" @click="handleEditMenu(scope.row)">{{ scope.row.domId }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="50px" :label="'名称'">
                <template slot-scope="scope">
                  <span>{{ scope.row.name }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="30px" :label="'排序'">
                <template slot-scope="scope">
                  <span>{{ scope.row.sort }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'样式'">
                <template slot-scope="scope">
                  <span>{{ scope.row.class }}</span>
                </template>
              </el-table-column>
              <el-table-column min-width="80px" :label="'ICON'">
                <template slot-scope="scope">
                  <span>{{ scope.row.icon }}</span>
                </template>
              </el-table-column>
              <el-table-column :label="'描述'" v-if="showDescription" min-width="120px">
                <template slot-scope="scope">
                  <span>{{ scope.row.remark }}</span>
                </template>
              </el-table-column>
            </el-table>
            <pagination v-show="total > 0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit"
              @pagination="handleCurrentChange" />
          </div>
        </el-col>
      </el-row>
      <!--模块编辑对话框-->
      <el-dialog v-el-drag-dialog class="dialog-mini" width="500px" :title="textMap[dialogStatus]"
        :visible.sync="dialogFormVisible">
        <el-form :rules="rules" ref="dataForm" :model="temp" label-position="right" label-width="100px">
          <el-form-item size="small" :label="'Id'" prop="id" v-show="dialogStatus == 'update'">
            <span>{{ temp.id }}</span>
          </el-form-item>
          <el-form-item size="small" :label="'层级ID'" v-show="dialogStatus == 'update'">
            <span>{{ temp.cascadeId }}</span>
          </el-form-item>
          <el-form-item size="small" :label="'名称'" prop="name">
            <el-input v-model="temp.name"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'排序'">
            <el-input-number v-model="temp.sortNo" :min="1" :max="20"></el-input-number>
          </el-form-item>
          <el-form-item size="small" :label="'前端是否缓存'" prop="keepAlive">
            <el-switch v-model="temp.keepAlive" active-color="#13ce66" inactive-color="#ff4949">
            </el-switch>
          </el-form-item>
          <el-form-item size="small" :label="'是否系统'" prop="isSys">
            <el-switch v-model="temp.isSys" active-color="#13ce66" inactive-color="#ff4949">
            </el-switch>
          </el-form-item>
          <el-form-item size="small" :label="'模块标识'">
            <el-input v-model="temp.code"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'图标'">
            <el-popover placement="top-start" width="500" ref="popoverModule" trigger="click" content="">
              <el-input slot="reference" :class="temp.iconName ? `iconfont icon-${temp.iconName} custom-icon-input` : ''"
                v-model="temp.iconName"></el-input>
              <el-row class="selectIcon-box">
                <el-col :class="{ 'active': temp.iconName === item.font_class }" :span="3"
                  v-for="(item, index) in iconData.glyphs" :key="index">
                  <i :class="`${iconData.font_family} ${iconData.css_prefix_text}${item.font_class}`"
                    @click="handleChangeTempIcon(item)"></i>
                </el-col>
              </el-row>
            </el-popover>
          </el-form-item>
          <el-form-item size="small" :label="'url'">
            <el-input v-model="temp.url"></el-input>
          </el-form-item>
          <el-form-item size="mini" :label="'上级机构'">
            <treeselect ref="modulesTree" :normalizer="normalizer" :disabled="treeDisabled" :options="modulesTreeRoot"
              :default-expand-level="3" :multiple="false" :open-on-click="true" :open-on-focus="true"
              :clear-on-select="true" v-model="dpSelectModule"></treeselect>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogFormVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogStatus == 'create'" type="primary" @click="createData">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateData">确认</el-button>
        </div>
      </el-dialog>
      <!--菜单编辑对话框-->
      <el-dialog v-el-drag-dialog class="dialog-mini" width="500px" :title="textMap[dialogMenuStatus]"
        :visible.sync="dialogMenuVisible">
        <el-form :rules="rules" ref="menuForm" :model="menuTemp" label-position="right" label-width="100px">
          <el-form-item size="small" :label="'Id'" prop="id" v-show="dialogMenuStatus == 'update'">
            <span>{{ menuTemp.id }}</span>
          </el-form-item>
          <el-form-item size="small" :label="'名称'" prop="name">
            <el-input v-model="menuTemp.name"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'DOM ID'">
            <el-input v-model="menuTemp.domId"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'样式'" style="position:relative;">
            <el-button :type="menuTemp.class" class="custom-select-icon" size="mini"></el-button>
            <el-select style="width: 100%;" v-model="menuTemp.class" placeholder="请选择">
              <el-option v-for="item in classBtns" :key="item.value" :label="item.value" :value="item.value">
                <span style="float: left">{{ item.value }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">
                  <el-button :type="item.value" size="mini"></el-button>
                </span>
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item size="small" :label="'图标'">
            <el-popover placement="top-start" width="500" trigger="click" ref="popoverMenu">
              <el-input slot="reference" :class="menuTemp.icon ? `iconfont icon-${menuTemp.icon} custom-icon-input` : ''"
                v-model="menuTemp.icon"></el-input>
              <el-row class="selectIcon-box">
                <el-col :class="{ 'active': menuTemp.icon === item.font_class }" :span="3"
                  v-for="(item, index) in iconData.glyphs" :key="index">
                  <i :class="`${iconData.font_family} ${iconData.css_prefix_text}${item.font_class}`"
                    @click="handleChangeMenuTempIcon(item)"></i>
                </el-col>
              </el-row>
            </el-popover>
          </el-form-item>
          <el-form-item size="small" :label="'排序'">
            <el-input-number v-model="menuTemp.sort" :min="0" :max="10"></el-input-number>
          </el-form-item>
          <el-form-item size="small" :label="'备注'">
            <el-input v-model="menuTemp.remark"></el-input>
          </el-form-item>
          <el-form-item size="small" :label="'所属模块'">
            <treeselect ref="menuModulesTree" :normalizer="normalizer" :options="modulesTree" :default-expand-level="3"
              :multiple="false" :open-on-click="true" :open-on-focus="true" :clear-on-select="true"
              v-model="menuTemp.moduleId"></treeselect>
          </el-form-item>
        </el-form>
        <div slot="footer">
          <el-button size="mini" @click="dialogMenuVisible = false">取消</el-button>
          <el-button size="mini" v-if="dialogMenuStatus == 'create'" type="primary" @click="addMenu">确认</el-button>
          <el-button size="mini" v-else type="primary" @click="updateMenu">确认</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>
<script>
import treeTable from '@/components/TreeTable'
import Pagination from '@/components/Pagination'
import {
  listToTreeSelect
} from '@/utils'
import extend from "@/extensions/common.js"
import * as modules from '@/api/modules'
import * as accessObjs from '@/api/accessObjs'
import * as sysPrinterPlansApi from '@/api/sysPrinterPlans'
import * as flowschemesApi from '@/api/flowschemes'
import * as login from '@/api/login'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import waves from '@/directive/waves' // 水波纹指令
import Sticky from '@/components/Sticky'
import permissionBtn from '@/components/PermissionBtn'
import elDragDialog from '@/directive/el-dragDialog'
import iconData from '@/assets/public/css/comIconfont/iconfont.json'
export default {
  name: 'module',
  components: {
    Sticky,
    permissionBtn,
    Treeselect,
    treeTable,
    Pagination
  },
  mixins: [extend],
  directives: {
    waves,
    elDragDialog
  },
  data() {
    return {
      iconData: iconData,
      classBtns: [{
        value: 'primary'
      }, {
        value: 'danger'
      }, {
        value: 'success'
      }, {
        value: 'info'
      }, {
        value: 'warning'
      }], // 按钮样式
      normalizer(node) {
        // treeselect定义字段
        return {
          label: node.name,
          id: node.id,
          children: node.children
        }
      },
      columns: [
        // treetable的列名
        {
          text: '模块名称',
          value: 'name'
        },
        {
          text: '模块标识',
          value: 'code'
        },
        {
          text: 'URL',
          value: 'url'
        }
      ],
      selectMenus: [], // 菜单列表选中的值
      tableKey: 0,
      list: [], // 菜单列表
      total: 0,
      currentModule: null, // 左边模块treetable当前选中的项
      listLoading: false,
      listQuery: {
        // 查询条件
        page: 1,
        limit: 20,
        orgId: '',
        key: undefined
      },
      apps: [],
      showDescription: false,
      modules: [], // 用户可访问到的模块列表
      modulesTree: [], // 用户可访问到的所有模块组成的树
      temp: {
        // 模块临时值
        id: undefined,
        cascadeId: '',
        url: '',
        code: '',
        sortNo: 0,
        iconName: '',
        parentId: null,
        name: '',
        status: 0,
        isSys: false,
        keepAlive:true
      },
      menuTemp: {
        // 菜单临时值
        id: undefined,
        url: '',
        icon: '',
        code: '',
        moduleId: null,
        name: '',
        status: 0,
        sort: 0
      },
      lastParentId: '',  //最后一次选中的上级模块Id
      dialogFormVisible: false, // 模块编辑框
      dialogStatus: '',
      dialogMenuVisible: false, // 菜单编辑框
      dialogMenuStatus: '',
      chkRoot: false, // 根节点是否选中
      treeDisabled: false, // 树选择框时候可用
      textMap: {
        update: '编辑',
        create: '添加'
      },
      rules: {
        name: [{
          required: true,
          message: '名称不能为空',
          trigger: 'blur'
        }]
      },
      modulePlans: [], //模块配置的打印方案列表
      newPlanSelVisible: false,
      selectedPlan: '',
      canSelPrinterPlans: [],  //当前模块可选择的打印方案列表
      sysPrinterPlans: [],  //系统所有打印方案列表
      flowschemes: [], //模块配置的送审方案列表
      newFlowschemeSelVisible: false,
      selectedFlowscheme: '',
      canSelFlowschemes: [],  //当前模块可选择的送审方案列表
      sysFlowschemes: [],  //系统所有送审方案列表
      downloadLoading: false
    }
  },
  computed: {
    isRoot: {
      get() {
        return this.chkRoot
      },
      set(v) {
        this.chkRoot = v
        if (v) {
          this.temp.parentName = '根节点'
          this.temp.parentId = null
        }
      }
    },
    modulesTreeRoot() {
      const root = [{
        name: '根节点',
        parentId: '',
        id: ''
      }]
      return root.concat(this.modulesTree)
    },
    currentPageMenus: {
      get() {
        var start = (this.listQuery.page - 1) * this.listQuery.limit
        var end = (this.listQuery.page * this.listQuery.limit)
        var result = this.list.slice(start, end)
        return result
      }
    },
    dpSelectModule: {
      // 模块编辑框下拉选中的模块
      get: function () {
        if (this.dialogStatus === 'update') {
          return this.temp.parentId || ''
        } else {
          return this.lastParentId
        }
      },
      set: function (v) {
        if (v === undefined || v === null || !v) {
          // 如果是根节点
          this.temp.parentName = '根节点'
          this.temp.parentId = null
          return
        }
        this.temp.parentId = v
        this.lastParentId = v
        var parentname = this.modules.find(val => {
          return v === val.id
        }).name
        this.temp.parentName = parentname
      }
    }
  },
  filters: {
    statusFilter(status) {
      const statusMap = {
        0: 'info',
        1: 'danger'
      }
      return statusMap[status]
    }
  },
  created() {
    // this.getList()
  },
  mounted() {
    sysPrinterPlansApi.getList({
      page: 1,
      limit: 20
    }).then((response) => {
      this.sysPrinterPlans = response.data
      this.getModulesTree()
    })

    flowschemesApi.loadUrlFormFlowScheme().then((response) => {
      this.sysFlowschemes = response.result
    })
    
  },
  methods: {
    handleChangeTempIcon(item) {
      this.temp.iconName = item.font_class
      this.$refs.popoverModule.doClose()
    },
    handleChangeMenuTempIcon(item) {
      this.menuTemp.icon = item.font_class
      this.$refs.popoverMenu.doClose()
    },
    rowClick(row) {
      this.$refs.mainTable.clearSelection()
      this.$refs.mainTable.toggleRowSelection(row)
    },
    treeClick(data) {
      // 左侧treetable点击事件
      this.currentModule = data
      this.currentModule.parent = null
      this.getList()
    },
    getAllMenus() {
      this.currentModule = null
      this.getList()
    },
    handleSelectionChange(val) {
      this.selectMenus = val
    },
    onBtnClicked: function (domId) {
      console.log('you click:' + domId)
      switch (domId) {
        case 'btnAdd':
          this.handleCreate()
          break
        case 'btnEdit':
          if (this.currentModule === null) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.handleUpdate(this.currentModule)
          break
        case 'btnDel':
          if (this.currentModule === null) {
            this.$message({
              message: '至少删除一个',
              type: 'error'
            })
            return
          }
          this.handleDelete(this.currentModule)
          break
        case 'btnAddMenu':
          this.handleAddMenu()
          break
        case 'btnEditMenu':
          if (this.selectMenus.length !== 1) {
            this.$message({
              message: '只能选中一个进行编辑',
              type: 'error'
            })
            return
          }
          this.handleEditMenu(this.selectMenus[0])
          break
        case 'btnDelMenu':
          if (this.selectMenus.length < 1) {
            this.$message({
              message: '至少删除一个',
              type: 'error'
            })
            return
          }
          this.handleDelMenus(this.selectMenus)
          break
        default:
          break
      }
    },
    getList() {
      this.listLoading = true
      var moduleId = this.currentModule === null ? null : this.currentModule.id
      modules.loadMenus(moduleId).then(response => {
        this.list = response.result
        this.total = response.result.length
        this.listLoading = false
      })

      //加载模块对应的打印方案
      modules.loadPrinterPlans(moduleId).then(response => {
        this.modulePlans = response.result
        if(this.modulePlans.length >0){
        this.canSelPrinterPlans = this.canSelPrinterPlans.filter(x => !this.modulePlans.some(b=>b.id == x.id));
        }else{
          this.canSelPrinterPlans = this.sysPrinterPlans.slice()
        }
      })

      //加载模块对应的送审方案
      modules.loadFlowSchemes(moduleId).then(response => {
        this.flowschemes = response.result
        if(this.flowschemes.length >0){
        this.canSelFlowschemes = this.canSelFlowschemes.filter(x => !this.flowschemes.some(b=>b.id == x.id));
        }else{
          this.canSelFlowschemes = this.sysFlowschemes.slice()
        }
      })
    },
    getModulesTree() {
      var _this = this // 记录vuecomponent
      login.getModules().then(response => {
        _this.modules = response.result.map(function (item) {
          return {
            sortNo: item.sortNo,
            id: item.id,
            name: item.name,
            iconName: item.iconName,
            parentId: item.parentId || null,
            code: item.code,
            url: item.url,
            cascadeId: item.cascadeId,
            isSys: item.isSys,
            keepAlive: item.keepAlive
          }
        })
        var modulestmp = JSON.parse(JSON.stringify(_this.modules))
        _this.modulesTree = listToTreeSelect(modulestmp).sort((a, b) => a.sortNo - b.sortNo)
        const arr = _this.modulesTree.filter(item => item.children && item.children.length > 0)
        // 默认选中第一个
        _this.$refs.menuTable.rowClick(arr[0].children[0])
      })
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleSizeChange(val) {
      this.listQuery.limit = val
      this.getList()
    },
    handleCurrentChange(val) {
      this.listQuery.page = val.page
      this.listQuery.limit = val.limit
      this.getList()
    },
    resetTemp() {
      this.temp = {
        id: undefined,
        cascadeId: '',
        url: '',
        iconName: '',
        code: '',
        parentId: null,
        name: '',
        status: 0,
        keepAlive:true
      }
    },
    resetMenuTemp() {
      this.menuTemp = {
        id: undefined,
        cascadeId: '',
        icon: '',
        url: '',
        code: '',
        moduleId: this.currentModule ? this.currentModule.id : null,
        name: '',
        status: 0,
        sort: 0
      }
    },
    // #region 模块管理
    handleCreate() {  // 弹出添加框
      this.dpSelectModule = this.lastParentId
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() {
      // 保存提交
      this.$refs['dataForm'].validate(valid => {
        var _this = this
        if (valid) {
          if (_this.temp.url.indexOf('http') > -1 && !_this.temp.code) {
            _this.$message.error('请输入模块标识')
            return
          }
          //如果打开弹框后，没有做任何选择操作，父级为空
          _this.temp.parentId = _this.temp.parentId || _this.lastParentId
          modules.add(_this.temp).then(response => {
            // 需要回填数据库生成的数据
            _this.temp.id = response.result.id
            _this.temp.cascadeId = response.result.cascadeId
            _this.list.unshift(_this.temp)
            _this.dialogFormVisible = false
            _this.$notify({
              title: '成功',
              message: '创建成功',
              type: 'success',
              duration: 2000
            })
            _this.getModulesTree()
          })
        }
      })
    },
    handleUpdate(row) {
      // 弹出编辑框
      this.temp = Object.assign({}, row) // copy obj
      if (this.temp.children) { // 点击含有子节点树结构时，带有的children会造成提交的时候json死循环
        this.temp.children = null
      }
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.dpSelectModule = this.temp.parentId
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    updateData() {
      // 更新提交
      this.$refs['dataForm'].validate(valid => {
        if (valid) {
          const tempData = Object.assign({}, this.temp)
          if (tempData.url.indexOf('http') > -1 && !tempData.code) {
            this.$message.error('请输入模块标识')
            return
          }
          modules.update(tempData).then(() => {
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: '更新成功',
              type: 'success',
              duration: 2000
            })
            this.getModulesTree()
            for (const v of this.list) {
              if (v.id === this.temp.id) {
                const index = this.list.indexOf(v)
                this.list.splice(index, 1, this.temp)
                break
              }
            }
          })
        }
      })
    },
    handleDelete(row) {
      var _this = this
      _this.delrows(modules, [row], () => {
        _this.getModulesTree()
      })
    },
    // #end region
    // #region 菜单管理
    handleAddMenu() {
      // 弹出添加框
      this.resetMenuTemp()
      this.dialogMenuStatus = 'create'
      this.dialogMenuVisible = true
      this.$nextTick(() => {
        this.$refs['menuForm'].clearValidate()
      })
    },
    addMenu() {
      // 保存提交
      this.$refs['menuForm'].validate(valid => {
        if (valid) {
          modules.addMenu(this.menuTemp).then(response => {
            // 需要回填数据库生成的数据
            this.menuTemp.id = response.result.id
            this.list.unshift(this.menuTemp)
            this.dialogMenuVisible = false
            this.$notify({
              title: '成功',
              message: '创建成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleEditMenu(row) {
      // 弹出编辑框
      this.menuTemp = Object.assign({}, row) // copy obj
      this.dialogMenuStatus = 'update'
      this.dialogMenuVisible = true
      this.$nextTick(() => {
        this.$refs['menuForm'].clearValidate()
      })
    },
    updateMenu() {
      // 更新提交
      this.$refs['menuForm'].validate(valid => {
        if (valid) {
          const tempData = Object.assign({}, this.menuTemp)
          modules.updateMenu(tempData).then(() => {
            this.dialogMenuVisible = false
            this.$notify({
              title: '成功',
              message: '更新成功',
              type: 'success',
              duration: 2000
            })
            for (const v of this.list) {
              if (v.id === this.menuTemp.id) {
                const index = this.list.indexOf(v)
                this.list.splice(index, 1, this.menuTemp)
                break
              }
            }
          })
        }
      })
    },
    handleDelMenus(rows) {
      // 多行删除
      modules.delMenu(rows.map(u => u.id)).then(() => {
        this.$notify({
          title: '成功',
          message: '删除成功',
          type: 'success',
          duration: 2000
        })
        rows.forEach(row => {
          const index = this.list.indexOf(row)
          this.list.splice(index, 1)
        })
      })
    },
    // #end region
    handleClose(tag) { //删除模块挂载的打印方案
      let plan = this.modulePlans.find(u => u.id == tag.id);
      var moduleId = this.currentModule === null ? null : this.currentModule.id
      accessObjs.unassign({
        type: 'ModulePrinterPlan',
        firstId: moduleId,
        secIds: [tag.id]
      }).then(() => {
        this.canSelPrinterPlans.push(plan);
      let index = this.modulePlans.findIndex(item => item.id == tag.id);
      this.modulePlans.splice(index, 1)
      })
      
    },
    handleCloseFlowscheme(tag) { //删除模块挂载的送审方案
      let flowscheme = this.flowschemes.find(u => u.id == tag.id);
      var moduleId = this.currentModule === null ? null : this.currentModule.id
      accessObjs.unassign({
        type: 'ModuleFlowscheme', 
        firstId: moduleId,
        secIds: [tag.id]
      }).then(() => {
        this.canSelFlowschemes.push(flowscheme);
      })
      let index = this.flowschemes.findIndex(item => item.id == tag.id);
      this.flowschemes.splice(index, 1)
    },

    showNewPlan() {
      this.newPlanSelVisible = true;
    },
    showNewFlowscheme() {
      this.newFlowschemeSelVisible = true;
    },
    change(planId) {  //选择一个打印方案
      var moduleId = this.currentModule === null ? null : this.currentModule.id
      let plan = this.canSelPrinterPlans.find(u => u.id == planId);
      accessObjs.assign({
        type: 'ModulePrinterPlan',
        firstId: moduleId,
        secIds: [planId]
      }).then(() => {
        this.modulePlans.push(plan);
        let index = this.canSelPrinterPlans.findIndex(item => item.id == planId);
        this.canSelPrinterPlans.splice(index, 1)
        this.newPlanSelVisible = false;

      })

      },
    changeFlowscheme(flowschemeId) {  //选择一个送审方案
      var moduleId = this.currentModule === null ? null : this.currentModule.id
      let flowscheme = this.canSelFlowschemes.find(u => u.id == flowschemeId);
      accessObjs.assign({
        type: 'ModuleFlowscheme',
        firstId: moduleId,
        secIds: [flowschemeId]
      }).then(() => {
        this.flowschemes.push(flowscheme);
        let index = this.canSelFlowschemes.findIndex(item => item.id == flowschemeId);
        this.canSelFlowschemes.splice(index, 1)
        this.newFlowschemeSelVisible = false; 
      })
    }
  }
}
</script>
<style lang="scss">
.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: '';
}

.clearfix:after {
  clear: both;
}

.el-card__header {
  padding: 12px 20px;
}

.selectIcon-box {
  text-align: center;
  border: 1px solid #eeeeee;
  border-right: 0;
  border-bottom: 0;

  .el-col {
    padding: 10px 0;
    border-right: 1px solid #eeeeee;
    border-bottom: 1px solid #eeeeee;

    &.active {
      .iconfont {
        color: #409EFF;
      }
    }
  }

  .iconfont {
    cursor: pointer;
    font-size: 20px;
  }
}

.custom-icon-input::before {
  font-size: 18px;
  position: absolute;
  right: 10px;
  top: 8px;
}

.custom-select-icon {
  position: absolute;
  top: 8px;
  right: 40px;
  z-index: 10;
}</style>