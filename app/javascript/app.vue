<template>
  <div id="app">
    <Header :userID="userID"></Header>
      <router-view :userID="userID" :shifts="shifts"></router-view>
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
        userID: 0
      };
    },
    mounted () {
      axios
        .get('/api/v1/staff/users')
        .then(response => (this.userID = response.data))
    },

    computed: {
      ...mapState([
      'shifts'
      ]),
    },
  };
</script>