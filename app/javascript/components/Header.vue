<!-- 希望シフト提出ページ、一覧ページの切り替え用 -->

<template>
  <div>
    <div v-if="hasAdmin">
      <router-link to="/admin/requested_shifts/">作成シフトの新規作成</router-link>
      <router-link to="/admin/fixed_shifts/">確定シフト表</router-link>
    </div>
    <div v-else>
      <router-link to="/staff/requested_shifts/">希望シフト表</router-link>
      <router-link to="/staff/fixed_shifts/">確定シフト表</router-link>
      <router-link :to="{ name : 'RequestedShiftsDetail', params : { id: this.userID }}">提出済み希望シフト一覧</router-link>
    </div>
  </div>
</template>
<script>
  export default {
    
    data() {
      return {
      };
    },

    props: [
      'userID',
      'hasAdmin'
    ]
  };
</script>