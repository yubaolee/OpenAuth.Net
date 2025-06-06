<template>
  <div>
    <rule-item :isDelete="false" :ruleForm="ruleForm" :propertyDatas="propertyDatas"></rule-item>
  </div>
</template>
<script>
import ruleItem from './ruleItem'
export default {
  name: 'addRule',
  props: {
    dataSource: [String, Object],
    propertyDatas: Array
  },
  components: {
    ruleItem
  },
  watch: {
    dataSource() {
      this.ruleForm = this.dataSource ? JSON.parse(this.dataSource) : Object.assign({}, this.ruleFormC)
    }
  },
  created() {
    this.ruleForm = this.dataSource ? JSON.parse(this.dataSource) : Object.assign({}, this.ruleFormC)
  },
  data() {
    return {
      ruleForm: {},
      ruleFormC: {
        Operation: 'or',
        Filters: [{
          Key: '',
          Value: '',
          Contrast: '',
          names: ''
        }]
      }
    }
  },
  computed: {
  },
  methods: {
    saveRule() {
      return this.ruleForm
    }
  }
}
</script>

