<template>
  <div id="app">
    <Header :user="userData"></Header>
      <router-view :shifts="shifts"></router-view>
  </div>
</template>
<script>
  import { mapState } from 'vuex'
  import axios from 'axios';
  import Header from "./components/Header.vue";
  export default {
    components: {
      Header,
    },
    data: function() {
      return {
        userData: {}
      };
    },
    mounted () {
      axios
        .get('/api/v1/requested_shifts.json')
        .then(response => (this.userData = response.data))
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