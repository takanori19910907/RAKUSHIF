<template>
  <div>
    <div v-if="hasAdmin == true">
      <router-link to="/admin/requested_shifts/">確定シフトの作成</router-link>
      <router-link to="/admin/fixed_shifts/">確定シフト表</router-link>

      <!-- 以下デバッグ用リンク -->

      <span>◀︎  管理者/ユーザー  ▶︎</span>
      <router-link to="/staff/requested_shifts/">希望シフト提出</router-link>
      <router-link :to="{ name : 'RequestedShiftsDetail', params : { id: this.userID }}">提出済み希望シフト一覧</router-link>
            <router-link to="/staff/fixed_shifts/">確定シフト表</router-link>

      <!-- ここまで 開発完了時に削除する -->

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

    props: [
      'userID',
      'hasAdmin'
    ]
  };

</script>