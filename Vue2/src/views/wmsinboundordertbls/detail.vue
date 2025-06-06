<template>
    <div class="flex flex-column">
        <div class="flex-item flex flex-column main-context">
            <div class="flex-item flex flex-column b-w">
                <el-card shadow="never" class="custom-card">
                    <div slot="header" class="flex flex-direction-r">
                        <span class="flex-item">单号:{{firstTemp.id}}</span>
                    </div>
                    <el-descriptions :column="2" border>
                        <el-descriptions-item label="发货仓库编码">{{ firstTemp.stockId }}</el-descriptions-item>
                        <el-descriptions-item label="所属货主编码">{{ firstTemp.ownerId }}</el-descriptions-item>
                        <el-descriptions-item label="承运商编码">{{ firstTemp.shipperId }}</el-descriptions-item>
                        <el-descriptions-item label="创建人">{{ firstTemp.createUserName }}</el-descriptions-item>
                        <el-descriptions-item label="订单时间">{{ firstTemp.createTime }}</el-descriptions-item>
                    </el-descriptions>
                </el-card>

                <el-card shadow="never" class="custom-card m-t-10">
                    <div slot="header" class="flex flex-direction-r">
                        <span class="flex-item">明细列表</span>
                    </div>
                    <auth-table size="small" ref="secondTable" :table-fields="secondHeaderList" :data="secondList"
                        :disabled="true"></auth-table>
                    <div class="flex flex-direction-r p-r-10">
                        <el-pagination size="small" background class="m-t-10 t-r m-b-10" v-show="secondTotal > 0"
                            :current-page.sync="secondQuery.page" :page-size.sync="secondQuery.limit"
                            :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next, jumper"
                            :total="secondTotal" @size-change="handleSecondSizeChange"
                            @current-change="handleSecondPage" />
                    </div>
                </el-card>
            </div>
        </div>
    </div>
</template>

<script>
import { get as getMainInfo } from '@/api/wmsinboundordertbls'
import { getList as getDetailList } from '@/api/wmsinboundorderdtbls'
import AuthTable from '@/components/Base/AuthTable.vue'

export default {
    name: 'WmsInboundOrderDetail',
    components: {
        AuthTable
    },
    data() {
        return {
            firstHeaderList: [], //列表头
            secondHeaderList: [], //明细列表头
            mainList: [], //主列表值
            secondList: [], //明细列表值
            secondTotal: 0, //明细列表总条数
            firstTemp: {}, //当前选中的头信息
            secondQuery: {
                // 明细查询条件
                page: 1,
                limit: 20,
                customerKey: undefined,
            }
        }
    },
    created() {
        if (this.$route.params.id) {
            this.getMainInfo(this.$route.params.id)
            this.querySecondList(this.$route.params.id)
        } else {
            this.$message.error('参数错误')
            this.$router.go(-1)
        }
    },
    methods: {
        // 获取主表信息
        async getMainInfo(id) {
            try {
                const response = await getMainInfo({id: id})
                this.firstTemp = response.result
            } catch (error) {
                this.$message.error('获取主表信息失败')
            }
        },
        // 获取明细列表
        async querySecondList(id) {
            try {
                const res = await getDetailList({
                    inboundorderid: id,
                    page: this.secondQuery.page,
                    limit: this.secondQuery.limit,
                    key: this.secondQuery.customerKey,
                })
                res.columnFields.forEach(item => {
                    item.columnName = item.columnName.substring(0, 1).toLowerCase() + item.columnName.substring(1)
                })
                this.secondHeaderList = res.columnFields
                this.secondTotal = res.count
                this.secondList = res.data
            } catch (error) {
                this.$message.error('获取明细列表失败')
            }
        },
        handleSecondPage(e) {
            this.secondQuery.page = e
            this.querySecondList(this.$route.params.id)
        },
        handleSecondSizeChange(val) {
            this.secondQuery.limit = val
            this.querySecondList(this.$route.params.id)
        }
    }
}
</script>

<style lang="scss" scoped>
.m-t-10 {
    margin-top: 10px;
}

.m-b-10 {
    margin-bottom: 10px;
}

.p-r-10 {
    padding-right: 10px;
}

.t-r {
    text-align: right;
}
</style>