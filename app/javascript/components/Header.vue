<template>
  <div>
    <router-link to="/">希望シフト表</router-link>
<router-link v-bind:to="{ name : 'About', params : { id: user.id }}">提出済み希望シフト一覧</router-link>
  </div>
</template>
<script>
  export default {
    data() {
      return {
      };
    },
    props: {
      user: {
        type: Object
      }
    }
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