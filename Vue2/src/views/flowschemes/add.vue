<template>
  <flow-scheme-dtl :is-edit='false'></flow-scheme-dtl>
</template>

<script>
import flowSchemeDtl from './components/flowSchemeDtl'
import { mapActions } from 'vuex'

export default {
  name: 'addFlowscheme',
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.saveCurrentSelect('')
    })
  },
  components: { flowSchemeDtl },
  methods: {
    ...mapActions(['saveCurrentSelect'])
  }
}
</script>

