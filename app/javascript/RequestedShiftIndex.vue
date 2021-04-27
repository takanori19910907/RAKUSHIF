<template>
  <div id="app">
    <table>
      <tbody>
        <tr>
          <th>出勤時間</th>
          <th>退勤時間</th>
        </tr>
        <tr v-for="e in requestedshifts" :key="e.id">
          <td>{{ e.clock_in }}</td>
          <td>{{ e.clock_out }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      requestedshifts: []
    }
  },
  mounted () {
    axios
      .get('/api/v1/requested_shifts.json')
      .then(response => (this.requestedshifts = response.data))
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>