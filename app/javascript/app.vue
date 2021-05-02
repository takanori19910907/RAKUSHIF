<template>
  <div id="app">
    <Header></Header>
      <router-view :shifts="shifts"></router-view>
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import Header from "./components/Header.vue";
  export default {
    components: {
      Header,
    },
    data: function() {
      return {
      };
    },

    computed: {
      ...mapState([
      'shifts'
      ]),
    },
  };
</script>

<style scoped>
</style>