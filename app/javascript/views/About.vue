<template>
  <section id="about">
    <table>
      <tbody>
        <tr>
          <th>希望日</th>
          <th>希望出勤時間</th>
          <th>希望退勤時間</th>
        </tr>
        <tr v-for="(item, index) in shifts" :key="item.id">
          <td> {{ item.year }}年{{ item.month }}月{{ item.day }}日</td>
          <td> {{ item.clockIn }}</td>
          <td> {{ item.clockOut }}</td>
          <button @click="removeStorageShiftData(index)">×</button>
        </tr>
      </tbody>
    </table>
  </section>
</template>

<script>
export default {
  data() {
    return {
    };
  },
  props: {
    shifts: {
      type: Array,
    }
  }
};
</script>

<style scoped>

</style>