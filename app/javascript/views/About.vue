<template>
  <section id="about">
    <h3>提出済みのシフト一覧</h3>
    <hr>
    <p>ユーザー名: {{ user.name }}</p>
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
          <button @click="removeShiftData(item.id)">×</button>
        </tr>
      </tbody>
    </table>
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
    axios.get('/api/v1/requested_shifts/id', { params: { id: this.user.id }
})
  .then(response => (this.shifts = response.data))
  },

  methods: {
    removeShiftData: function(id) {
      // if (window.confirm("入力した希望シフトをまとめて提出します、よろしいですか?")) {
      // axios.post('/api/v1/requested_shifts', {shifts: this.shifts })
      // this.$store.dispatch('deleteReqLists')
      // }
      if (window.confirm("このシフト希望を削除します、よろしいですか?")) {
        axios.delete('/api/v1/requested_shifts/id', {data: {id: id} } )
        this.updateShifts();
      }
    },
    updateShifts: function() {
      axios.get('/api/v1/requested_shifts/id', { params: { id: this.user.id } })
      .then(response => (this.shifts = response.data))
    }
  }
};
</script>