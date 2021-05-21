<!-- 希望シフト提出ページ、一覧ページの切り替え用 -->

<template>
  <div>
    <router-link to="/staff/requested_shifts/">希望シフト表</router-link>
    <router-link :to="{ name : 'RequestedShiftsDetail', params : { id: user.id }}">提出済み希望シフト一覧</router-link>
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