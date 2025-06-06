<template>
  <div class="compent-dialog-body">
    <div class="content">
      <el-input size="small" @keyup.enter.native="handleFilter" style="width: 200px;" class="filter-item" :placeholder="'名称'"
        v-model="listQuery.key">
      </el-input>

      <el-select clearable size="small" class="filter-item" style="width: 130px" v-model="listQuery.appId" :placeholder="'所属应用'">
        <el-option v-for="item in  apps" :key="item.id" :label="item.name+'('+item.id+')'" :value="item.id">
        </el-option>
      </el-select>

      <el-button class="filter-item" size="small" v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>

      <el-tag v-for="item in selectTexts" :key="item" size="small" class="custom-tag m-r-12">
        {{ item }}
      </el-tag>

      <el-table class="table" ref="mainTable" :key='tableKey' :data="list" v-loading="listLoading" border fit
        highlight-current-row style="width: 100%;" @row-click="rowClick" @select="handleSelectionUser" @select-all="handleSelectionUser"
        height="400" max-height="400">
        <el-table-column align="center" type="selection" width="55">
        </el-table-column>

        <el-table-column :label="'Id'" min-width="120px">
          <template slot-scope="scope">
            <span>{{scope.row.id}}</span>
          </template>
        </el-table-column>

        <el-table-column min-width="80px" :label="'名称'">
          <template slot-scope="scope">
            <span>{{scope.row.name}}</span>
          </template>
        </el-table-column>

        <el-table-column width="120px" :label="'所属应用'">
          <template slot-scope="scope">
            <span>{{scope.row.appName}}</span>
          </template>
        </el-table-column>
        <el-table-column min-width="150px" :label="'描述'">
          <template slot-scope="scope">
            <span style='color:red;'>{{scope.row.description}}</span>
          </template>
        </el-table-column>
      </el-table>
      <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="handleCurrentChange" />
    </div>
    <div class="el-dialog__footer" v-if="!hiddenFooter">
      <el-button size="mini" @click="close">取消</el-button>
      <el-button size="mini" type="primary" @click="handleSaveResource">确认</el-button>
    </div>
  </div>

</template>

<script>
  import * as resourcesApi from '@/api/resources'
  import * as applications from '@/api/applications'
  import waves from '@/directive/waves' // 水波纹指令
  import Pagination from '@/components/Pagination'
  import { unique } from '@/utils/index'

  export default {
    name: 'assign-res',
    components: {
      Pagination
    },
    directives: {
      waves
    },
    props: ['users','userNames','hiddenFooter'],
    data() {
      return {
        tableKey: 0,
        list: null,
        total: 0,
        selectTexts: [],  //已选中的名称列表
        selectIds: [],  //已选中的ID列表
        currentPageIds: [],  //当前页面的选中项ID列表
        currentPageTexts: [],  //当前页面的选中项名称列表
        listLoading: true,
        listQuery: { // 查询条件
          page: 1,
          limit: 20,
          key: undefined,
          appId: undefined
        },
        apps: []
      }
    },
    mounted() {
      if (this.users) {
        this.selectIds = [...this.users]
        this.selectTexts = this.userNames && this.userNames.length > 0 ? this.userNames.split(',') : []
      }
      this.getList()
      applications.getList().then(response => {
        this.apps = response.data
      })
    },
    methods: {
      //用后端返回的当前列表数据计算当前页面的选中项信息
      initCurrentPageData() {
        this.currentPageIds = this.list
          .filter(x => this.selectIds.includes(x.id))
          .map(item => item.id)
        this.currentPageTexts = this.list
          .filter(x => this.selectIds.includes(x.id))
          .map(item => item.name)
      },
      setSelectTable() { // 设置界面列表选中
        var _this = this
        this.$refs.mainTable.clearSelection()
        this.selectIds.forEach(id => {
          const row = _this.list.find(row => row.id === id)
          if (row) {
            _this.$refs.mainTable.toggleRowSelection(row)
          }
        })
      },
      rowClick(row) { // 行点击事件
        this.$refs.mainTable.clearSelection()
        this.$refs.mainTable.toggleRowSelection(row)
        this.selectTexts = [row.name || row.account]
        this.currentPageTexts = [row.name || row.account]
        this.selectIds = [row.id]
        this.currentPageIds = [row.id]
      },

      getList() {
        const _this = this
        this.listLoading = true

        resourcesApi.getList(this.listQuery).then(response => {
          _this.list = response.data
          _this.total = response.count
          _this.listLoading = false

          //如果父节点没有绑定变量或为空，则按选中的ID列表初始化已选中的名称列表
          //TODO: 这样会有分页的问题，需要优化
          if (_this.selectTexts.length <= 0 && _this.selectIds.length > 0) {
            _this.selectTexts = _this.list
              .filter(x => _this.selectIds.includes(x.id))
              .map(item => item.name || item.account)
          }

          _this.initCurrentPageData()
          this.$nextTick(() =>  {
            _this.setSelectTable()
          })
        })
      },
      handleSelectionUser(val) {
        //先判定被删除的
        var delIds = this.currentPageIds.filter((x) => val.map((u) => u.id).indexOf(x) < 0)
        if (delIds.length > 0) {
          this.selectIds = this.selectIds.filter((x) => delIds.indexOf(x) < 0)
        }

        var delTexts = this.currentPageTexts.filter((x) => val.map((u) => u.name).indexOf(x) < 0)
        if (delTexts.length > 0) {
          this.selectTexts = this.selectTexts.filter((x) => delTexts.indexOf(x) < 0)
        }

      this.currentPageIds = val.map((item) => item.id)
      this.currentPageTexts = val.map((item) => item.name)

      //合并已选中的项和新增的项
      this.selectIds = unique([...this.selectIds, ...this.currentPageIds])
      this.selectTexts = unique([...this.selectTexts, ...this.currentPageTexts])
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
      close() {
        this.$emit('close')
      },
      //点击确定，保存已选中的用户，或者提供给父组件【确定】按钮使用
      handleSaveResource() {
        this.$emit('update:userNames', this.selectTexts.join(','))
        this.$emit('update:users', this.selectIds)
        this.$emit('update:show', false)
      }
    }
  }

</script>

<style scoped>
.compent-dialog-body {
  display: flex;
  flex-direction: column;
  height: 100%;
}
.content {
  flex: 1;
  padding: 10px;
}
.el-dialog__footer {
  padding: 10px;
  text-align: right;
  border-top: 1px solid #e6e6e6;
}
</style>
