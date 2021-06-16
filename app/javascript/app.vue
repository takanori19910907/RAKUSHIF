<template>
  <div id="app">
    <Header :userID="user.id" :hasAdmin="user.admin"></Header>
      <router-view :userID="user.id" :hasAdmin="user.admin" :beforeApplyData="shifts.beforeApplyData" :beforeCreateData="shifts.beforeCreateData"></router-view>
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
        user: {}
      };
    },
    mounted () {
      axios
        .get('/api/v1/staff/users')
        .then(response => (this.user = response.data))
    },

    computed: {
      ...mapState([
      'shifts',
      ]),
    },
  };
</script>