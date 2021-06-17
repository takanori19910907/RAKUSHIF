<template>
  <div id="app">
    <Header :userID="myUserData.id" :hasAdmin="myUserData.admin"></Header>
      <router-view 
        :userID="myUserData.id"
        :hasAdmin="myUserData.admin"
        :allUsersData="allUsersData"
        :shifts="requestedShifts"
        :requested="requestedShiftsInTableData"
        :shiftData="fixedShifts"
        :fixed="fixedShiftsInTableData"
        ></router-view>
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
        // user: {}
      };
    },
    mounted () {
      // axios
      //   .get('/api/v1/staff/users')
      //   .then(response => (this.user = response.data))
    },

    computed: {
      ...mapState([
      'myUserData',
      'allUsersData',
      'requestedShifts',
      'requestedShiftsInTableData',
      'fixedShifts',
      'fixedShiftsInTableData'
      ]),
    },
  };
</script>