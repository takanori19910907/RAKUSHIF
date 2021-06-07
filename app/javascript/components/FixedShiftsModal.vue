<!-- addshift(dispatch)でselectした要素、propsで受け取った日付情報をstoreに送るmodal -->

<template>
  <div id="overlay">
    <div id="modal" >

      <p>希望シフト編集</p>

      <div>
        <p>{{ year }}/{{ month }}/{{ day }}</p>
        <p>希望時間: {{ formattedclockIn(shift.clock_in) }}〜 {{ formattedclockIn(shift.clock_out) }} から</p>
      </div>

      <form @submit.prevent="sendUpdateData">
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
        <p>に変更します</p>
        <button  type="submit" >完了</button>
      </form>

      <button @click="$emit('close')">閉じる</button>

    </div> 
  </div>
</template>

<script>
  import dayjs from 'dayjs';
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
          clockIn: "",
          clockOut: "",
          year: 0,
          month: 0,
          date: 0,
          shiftIdx: 0,
          arrayIdx: 0
        }
      }
    },

    props: [
      'shift',
      'shiftIdx',
      'arrayIdx',
      'year',
      'month',
      'day'
    ],
    
    methods: {
      sendUpdateData: function() {
        this.setData.clockIn = this.selected1
        this.setData.clockOut = this.selected2
        this.setData.year = this.year
        this.setData.month = this.month
        this.setData.date = this.day
        this.setData.shiftIdx = this.shiftIdx 
        this.setData.arrayIdx = this.arrayIdx
        this.$emit('sendUpdateData', this.setData)
      },

      formattedclockIn: function(clockIn) {
        return dayjs(clockIn).format('HH:mm');
      },

      formattedclockOut: function(clockIn) {
        return dayjs(clockIn).format('HH:mm');
      },
    }
  }
</script>