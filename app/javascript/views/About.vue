<!-- ログインユーザーのシフト希望(提出済み)一覧ページ -->

<template>
  <section id="about">
    <p>ユーザー名: {{ user.name }}さん</p>
    <h3>提出済みのシフト一覧</h3>
    <div v-if="shifts.length">
    <hr>
    <table>
      <tbody>
        <tr>
          <th>希望日</th>
          <th>希望出勤時間</th>
          <th>希望退勤時間</th>
        </tr>
        <tr v-for="(item) in shifts" :key="item.id">
          <td> {{ item.year }}年{{ item.month }}月{{ item.day }}日</td>
          <td> {{ item.clock_in }}</td>
          <td> {{ item.clock_out }}</td>
          <button @click="updateShiftData(item.id)">修正</button>
          <button @click="removeShiftData(item.id)">×</button>
        </tr>
      </tbody>
    </table>
    </div>
    <div v-else>
      <p>シフト希望がありません</p>
      <p>シフト希望表ページからシフト希望を提出してください</p>

    </div>
  </section>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      shifts: {}
    };
  },

  props: {
      user: {
        type: Object
      }
    },
    
  mounted () {
    axios.get('/api/v1/staff/requested_shifts/id', { params: { id: this.user.id }
})
  .then(response => (this.shifts = response.data))
  },

  methods: {
    removeShiftData: function(id) {
      if (window.confirm("このシフト希望を削除します、よろしいですか?")) {
        axios.delete('/api/v1/staff/requested_shifts/id', {data: {id: id} } )
        this.updateShifts();
      }
    },
    updateShiftData: function(id) {
      axios.put('/api/v1/staff/requested_shifts/id', {data: {id: id} })
      .then(response => (this.shifts = response.data))
    }
  }
};
</script>