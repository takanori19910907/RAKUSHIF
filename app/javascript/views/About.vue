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
        <tr v-for="(item, index) in shifts" :key="item.id">
          <td> {{ item.year }}年{{ item.month }}月{{ item.day }}日</td>
          <td> {{ item.clock_in }}</td>
          <td> {{ item.clock_out }}</td>
          <button @click="removeStorageShiftData(index)">×</button>
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



//   mounted () {
//     axios.get('/api/v1/requested_shifts/1', {
//   params: {
//     id: this.user.id
//   }
// })
//   .then(response => (this.shifts = response.data))
//   }
    mounted () {
      axios
        .get('/api/v1/requested_shifts/1')
        .then(response => (this.shifts = response.data))
    }

};
</script>