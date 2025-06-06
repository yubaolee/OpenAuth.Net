<template>
  <form-detail :is-edit='true'></form-detail>
</template>

<script>
import FormDetail from './components/formDetail'

export default {
  name: 'editForm',
  components: { FormDetail },
  methods: {
  }
}
</script>

