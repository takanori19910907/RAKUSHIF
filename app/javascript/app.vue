<template>
  <div id="app">

    <!-- ユーザーID、ユーザーのadmin属性のみここで取得して子に渡す -->
    <Header :userID="myUserData.id" :hasAdmin="myUserData.admin"></Header>
      <router-view 
        :userID="myUserData.id"
        :hasAdmin="myUserData.admin"
        ></router-view>
  </div>
</template>
<script>
  import { mapState } from "vuex";
  import Header from "./components/molecules/Header.vue";
  export default {
    components: {
      Header,
    },

    mounted () {
      this.$store.dispatch("getMyUserData")
    },

    computed: {
      ...mapState([
      "myUserData"
      ]),
    },
  };
</script>