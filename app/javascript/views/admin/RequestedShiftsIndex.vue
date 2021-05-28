<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <calendar @sendDate="showShifts"/>
    <h2>みんなの希望シフト一覧</h2>
    <div v-if="shiftData.length">
      <hr>
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="data in ShiftData" :key="data.id" >
            <td><userName :key="data.id" :userName="data.user.name" ></userName></td>
            <td><userAge :key="data.id" :userAge="data.user.age" ></userAge></td>
            <td><userWorkStatus :key="data.id" :userData="data.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="data.id" :clockInTime="data.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="data.id" :clockOutTime="data.clock_out" ></requestedClockOutTime></td>
            <button>修正</button>
            <button>×</button>
          </tr>
        </tbody>
      </table>
      <button>シフト確定</button>
    </div>
    
    <div v-else>
      <p>提出されている希望シフトはありません</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Calendar from '../../components/FixedShiftsCalendar.vue'
import UserName from '../../components/UserName.vue'
import UserAge from '../../components/UserAge.vue'
import UserWorkStatus from '../../components/UserWorkStatus.vue'
import RequestedClockInTime from '../../components/RequestedClockInTime.vue'
import RequestedClockOutTime from '../../components/RequestedClockOutTime.vue'
export default {
  components: {
    Calendar,
    UserName,
    UserAge,
    UserWorkStatus,
    RequestedClockInTime,
    RequestedClockOutTime
  },

  data() {
    return{
        shiftData: {},
        userData: {}
    }
  },

  props: {
    shifts: {
      Type: Array
    }
  },

  created() {
    axios
      .get('/api/v1/admin/users')
      .then(response => (this.userData = response.data))
  },

  computed: {
    ShiftData: function() {
      return this.shiftData.map(shift => {
        var user = this.userData.find(function(user){
        return user.id === shift.user_id
        })
        return {
          ...shift,
          user: user
        }
      })
    },
  },

  methods: {
    showShifts: function(value) {
      axios
        .get('/api/v1/admin/requested_shifts', { params: { year: value.year, month: value.month, date: value.date }})
        .then(response => (this.shiftData = response.data))
    }
  }
}
</script>