<template>
<!-- addshift(dispatch)でselectした要素、propsで受け取った日付情報をstoreに送る -->
  <div id="overlay">
    <div id="modal">
      <p>{{ year }}年{{ month }}月{{ day }}日の出勤希望を入力</p>
      <form @submit.prevent="addShift">
      <select v-model="selected1">
        <option disabled value="">出勤希望時間</option>
        <option v-for="clockIn in clockIns" v-bind:val="clockIn.time" v-bind:key="clockIn.id">
          {{ clockIn.time }}
        </option>
      </select>
      <select v-model="selected2">
        <option disabled value="">出勤希望時間</option>
      <option v-for="clockOut in clockOuts" v-bind:val="clockOut.time" v-bind:key="clockOut.id">
          {{ clockOut.time }}
        </option>
      </select>
        <p>出勤:{{ selected1 }}</p>
        <p>退勤:{{ selected2 }}</p>
        <p>上記の時間帯でシフト希望を提出します</p>
        <button  type="submit" >提出</button>
      </form>
    <button @click="$emit('close')">閉じる</button>
    </div>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      selected1: "",
      selected2: "",
      clockIns: [
        {id: 1, time: "9:00" },
        {id: 2, time: "13:00" },
        {id: 3, time: "17:00" }
      ],
      clockOuts: [
        {id: 1, time: "13:30" },
        {id: 2, time: "17:30" },
        {id: 3, time: "21:00" }
      ]
    }
  },
  props: [
    'year',
    'month',
    'day'
  ],
  
  methods: {
    addShift: function() {
      this.$store.dispatch('addShift', {
        clockIn: this.selected1,
        clockOut: this.selected2
        })
      this.selected1= ""
      this.selected2= ""
    },
  }
  
}
</script>