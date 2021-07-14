<!-- シフト入力用のmodal -->

<template>
  <div id="overlay">
    <div id="modal">
      <h3>{{ title }}</h3>
      <p>{{ year }}/{{ month }}/{{ date }}の{{ subtitle }}</p>
      
      <p v-if="shift">
      {{ formattedClockIn }} 〜 {{ formattedClockOut }} から
      </p>
      <form @submit.prevent="sendShiftsData">
      <select v-model="selected1">
        <option disabled value="">希望出勤時間</option>
        <option v-for="clockIn in clockIns" v-bind:val="clockIn.time" v-bind:key="clockIn.id">
          {{ clockIn.time }}
        </option>
      </select>
      <span>〜</span>
      <select v-model="selected2">
        <option disabled value="">希望退勤時間</option>
      <option v-for="clockOut in clockOuts" v-bind:val="clockOut.time" v-bind:key="clockOut.id">
          {{ clockOut.time }}
        </option>
      </select>
        <p>出勤 : {{ selected1 }}</p>
        <p>退勤 : {{ selected2 }}</p>

        <p>{{ footerMessage }}</p>
        <button  type="submit" >{{ submit }}</button>
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
      ],

      setData: {
        year: null,
        month: null,
        date: null,
        clockIn: null,
        clockOut: null,
        shiftId: null,
        userId: null,
        index: null
      }
    }
  },
  props: [
    "year",
    "month",
    "date",
    "shift",
    "shiftId",
    "userId",
    "index",
    "title",
    "subtitle",
    "footerMessage",
    "submit"
  ],
  computed: {
    formattedClockIn() {
      return this.$store.getters.formattedTime(this.shift.clock_in)
    },
    formattedClockOut() {
      return this.$store.getters.formattedTime(this.shift.clock_out)
    }
  },
  methods: {
    sendShiftsData() {
    this.setData.year = this.year
    this.setData.month = this.month
    this.setData.date = this.date
    this.setData.clockIn = this.selected1
    this.setData.clockOut = this.selected2
    this.setData.shiftId = this.shiftId
    this.setData.userId = this.userId
    this.setData.index = this.index
      this.$emit("sendShiftsData", 
                      this.setData
                      )
    }
  }
}
</script>