<template>
  <el-dropdown trigger="click" :show-timeout="100">
    <el-button plain>{{getTxt()}}
      <i class="el-icon-caret-bottom el-icon--right"></i>
    </el-button>
    <el-dropdown-menu class="no-padding" slot="dropdown">
      <el-dropdown-item>
        <el-radio-group style="padding: 10px;" v-model="comment_disabled">
          <el-radio :label="1">同意</el-radio>
          <el-radio :label="2">不同意</el-radio>
          <el-radio :label="3">驳回</el-radio>
        </el-radio-group>
      </el-dropdown-item>
    </el-dropdown-menu>
  </el-dropdown>
</template>

<script>
export default {
  props: ['value'],
  computed: {
    comment_disabled: {
      get() {
        return this.value
      },
      set(val) {
        this.$emit('input', val)
      }
    }
  },
  methods: {
    getTxt() {
      switch (this.comment_disabled) {
        case 1:
          return '同意'
        case 2:
          return '不同意'
        case 3:
          return '驳回'
        default:
          break
      }
    }
  }
}
</script>
