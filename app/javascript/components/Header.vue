<template>
  <header>
    <router-link to="/admin/requested_shifts">希望シフト表</router-link>
        <router-link to="/admin/requested_shifts/about">希望一覧</router-link>
    <!-- <router-link :to="{name: 'about', params: {id: current_user.id}}"> 申請中の希望一覧</router-link> -->

  </header>
</template>
<script>
  export default {
    data() {
      return {
        message: "Headerです",
      };
    },
  };
</script>
<style lang="scss" scoped>
  $background-color: skyblue;
  header {
    width: 100%;
    height: 80px;
    background-color: $background-color;
    display: flex;
    flex-direction: row;
    align-items: center;
    a {
      display: inline-block;
      margin: 0 20px;
    }
  }
</style>