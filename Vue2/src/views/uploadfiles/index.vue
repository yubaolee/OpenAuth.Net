<template>
    <div class="flex-column">
        <sticky :className="'sub-navbar'">
            <div class="filter-container">
                <el-input @keyup.enter.native="handleFilter" size="mini"  style="width: 200px;" class="filter-item" :placeholder="'搜索关键字'" v-model="listQuery.key">
                </el-input>

                <el-button class="filter-item" size="mini"  v-waves icon="el-icon-search" @click="handleFilter">搜索</el-button>
                <permission-btn  size="mini" v-on:btn-event="onBtnClicked"></permission-btn>
            </div>
        </sticky>
        <div class="app-container flex-item">

            <div class="bg-white" style="height: 100%;">

                   <el-table ref="mainTable" :key='tableKey' :data="list" v-loading="listLoading" border fit
              highlight-current-row style="width: 100%;" height="calc(100% - 52px)" @row-click="rowClick" @selection-change="handleSelectionChange">
              <el-table-column type="selection" align="center" width="55">
              </el-table-column>

                <el-table-column min-width="10px" :label="'缩略图'">
                <template slot-scope="scope">
                    <el-avatar :size="50" :src="baseImgUrl + '/'+scope.row.thumbnail"></el-avatar>
                </template>
              </el-table-column>

              <el-table-column min-width="30px" :label="'文件名称'">
                <template slot-scope="scope">
                  <span>{{scope.row.fileName}}</span>
                </template>
              </el-table-column>

                <el-table-column min-width="50px" :label="'路径'">
                <template slot-scope="scope">
                  <span>{{scope.row.filePath}}</span>
                </template>
              </el-table-column>

               <el-table-column min-width="10px" :label="'文件类型'">
                <template slot-scope="scope">
                  <span>{{scope.row.fileType}}</span>
                </template>
              </el-table-column>

              <el-table-column width="120px" :label="'上传人'">
                <template slot-scope="scope">
                  <span>{{scope.row.createUserName}}</span>
                </template>
              </el-table-column>

               <el-table-column width="200px" :label="'上传时间'">
                <template slot-scope="scope">
                  <span>{{scope.row.createTime}}</span>
                </template>
              </el-table-column>

              <el-table-column class-name="status-col" :label="'是否可用'" width="100">
                <template slot-scope="scope">
                  <span :class="scope.row.enable | statusFilter">{{statusOptions.find(u =>u.key ==
                    scope.row.enable).display_name}}</span>
                </template>
              </el-table-column>
            </el-table>

                <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="handleCurrentChange" />
            </div>
            <el-dialog v-el-drag-dialog   class="dialog-mini" width="500px" :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible">
               <el-upload
                drag
                :file-list="fileList"
                name="files"
                :headers="tokenHeader"
                :action="baseURL +'/Files/Upload'"
                multiple>
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
                </el-upload>

                <div slot="footer" >
                    <el-button size="mini" @click="closeUpload">关闭</el-button>
                </div>
            </el-dialog>
        </div>
    </div>

</template>

<script>
    import * as uploadFiles from '@/api/uploadFiles'
    import waves from '@/directive/waves' // 水波纹指令
    import Sticky from '@/components/Sticky'
    import permissionBtn from '@/components/PermissionBtn'
    import Pagination from '@/components/Pagination'
    import elDragDialog from '@/directive/el-dragDialog'
    import { getToken } from '@/utils/auth'
    import extend from "@/extensions/common.js"
    export default {
        name: 'uploadFile',
        components: { Sticky, permissionBtn, Pagination },
        directives: {
            waves,
            elDragDialog
        },
        mixins: [extend],
        data() {
            return {
                tokenHeader: {'X-Token': getToken()},
                baseURL: process.env.VUE_APP_BASE_API, // api的base_url
                baseImgUrl: process.env.VUE_APP_BASE_IMG_URL, // 图片根目录
                multipleSelection: [], // 列表checkbox选中的值
                tableKey: 0,
                list: null,
                total: 0,
                listLoading: true,
                listQuery: { // 查询条件
                    page: 1,
                    limit: 20,
                    key: undefined,
                    appId: undefined
                },
                statusOptions: [
                    { key: true, display_name: '停用' },
                    { key: false, display_name: '正常' }
                ],
                temp: {
                    fileType: '', //文件类型 
                    deleteMark: '', //删除标识 
                    description: '', //描述 
                    belongApp: '', //所属应用 
                    createUserName: '', //上传人姓名 
                    enable: '', //是否可用 
                    fileSize: '', //文件大小 
                    id: '', //Id 
                    filePath: '', //文件路径 
                    extension: '', //扩展名称 
                    thumbnail: '', //缩略图 
                    fileName: '', //文件名称 
                    createUserId: '', //上传人 
                    createTime: '', //上传时间 
                    belongAppId: '', //所属应用ID 
                    sortCode: '', //排序 
                    nothing:''  //代码生成时的占位符，看不顺眼可以删除 

                },
                dialogFormVisible: false,
                dialogStatus: '',
                textMap: {
                    update: '编辑',
                    create: '添加'
                },
                dialogPvVisible: false,
                fileList: [],
                rules: {
                    name: [{ required: true, message: '名称不能为空', trigger: 'blur' }]
                },
                downloadLoading: false
            }
        },
        filters: {
            statusFilter(disable) {
                const statusMap = {
                    false: 'color-success',
                    true: 'color-danger'
                }
                return statusMap[disable]
            }
        },
        created() {
            this.getList()
        },
        methods: {
            rowClick(row) {
                this.$refs.mainTable.clearSelection()
                this.$refs.mainTable.toggleRowSelection(row)
            },
            handleSelectionChange(val) {
                this.multipleSelection = val
            },
            onBtnClicked: function(domId) {
                console.log('you click:' + domId)
                switch (domId) {
                    case 'btnAdd':
                        this.handleCreate()
                        break
                    case 'btnDel':
                        if (this.multipleSelection.length < 1) {
                            this.$message({
                                message: '至少删除一个',
                                type: 'error'
                            })
                            return
                        }
                        this.handleDelete(this.multipleSelection)
                        break
                    default:
                        break
                }
            },
            getList() {
                this.listLoading = true
                uploadFiles.getList(this.listQuery).then(response => {
                    this.list = response.data
                    this.total = response.count
                    this.listLoading = false
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
            handleModifyStatus(row, disable) { // 模拟修改状态
                this.$message({
                    message: '操作成功',
                    type: 'success'
                })
                row.disable = disable
            },
           
            handleCreate() { // 弹出添加框
                this.dialogStatus = 'create'
                this.dialogFormVisible = true
            },
            closeUpload(){ //关闭上传对话框
                this.fileList =[]
                this.dialogFormVisible = false
                this.getList()
            },
            handleDelete(rows) { // 多行删除
                this.delrows(uploadFiles, rows)
            }
        }
    }
</script>
<style>
    .dialog-mini .el-select{
        width:100%;
    }
</style>
