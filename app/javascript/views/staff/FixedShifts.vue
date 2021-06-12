<template>
  <div>
    <calendar @sendDate="checkShifts"></calendar>
    <h1>確定シフト一覧</h1>
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
          <tr v-for="(data, index) in getShiftData()" :key="data.id" >
            <td><userName :key="data.id" :userName="data.user.name" ></userName></td>
            <td><userAge :key="data.id" :userAge="data.user.age" ></userAge></td>
            <td><userWorkStatus :key="data.id" :userData="data.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="data.id" :clockInTime="data.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="data.id" :clockOutTime="data.clock_out" ></requestedClockOutTime></td>
            <button @click="openModal(data, index)">修正</button>
            <button @click="deleteItemInShiftData(data.id)">×</button>
            <fixedShiftsModal v-if="showModal" @close="closeModal" 
              :key="data.id"
              :year="year"
              :month="month"
              :day="date"
              :shift="checkedShift"
              :shiftIdx="data.id"
              :arrayIdx="arrayIdx"
              @sendUpdateData="updateItemInShiftData"
              >
            </fixedShiftsModal>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-else>
      <p>
        まだ確定シフトが作成されていない、<br>
        もしくは出勤予定の従業員がいません
        </p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import dayjs from 'dayjs';
import Calendar from '../../components/FixedShiftsCalendar.vue'
import FixedShiftsModal from '../../components/FixedShiftsModal.vue'
import UserName from '../../components/UserName.vue'
import UserAge from '../../components/UserAge.vue'
import UserWorkStatus from '../../components/UserWorkStatus.vue'
import RequestedClockInTime from '../../components/RequestedClockInTime.vue'
import RequestedClockOutTime from '../../components/RequestedClockOutTime.vue'
export default {
  components: {
    Calendar,
    FixedShiftsModal,
    UserName,
    UserAge,
    UserWorkStatus,
    RequestedClockInTime,
    RequestedClockOutTime
  },

  data() {
    return{
        shiftData: {},
        userData: {},
        year: 2021,
        month: 6,
        date: 5,
        checkedShift: {},
        showModal: false,
        arrayIdx: 0
    }
  },

  created() {
    axios
      .get('/api/v1/admin/users')
      .then(response => (this.userData = response.data))
  },

  methods: {
  checkShifts: function(value) {
    this.year = value.year
    this.month = value.month
    this.date = value.date
    axios
    .get('/api/v1/admin/fixed_shifts', { params: { year: this.year, month: this.month, date: this.date }})
    .then(response => {
      this.shiftData = response.data
      })
    },

    createFixedShift: function() {
      this.$store.state.fixedShifts.splice(0, 1) 
      if (window.confirm("確定シフトを作成します、よろしいですか?")) {
      axios.post('/api/v1/admin/fixed_shifts', {shifts: this.$store.state.fixedShifts })
      this.$router.push('/admin/fixed_shifts')
      }
    },

    openModal: function(value, index) {
      this.arrayIdx = index
      this.checkedShift = value
      this.showModal = true
    },
    
    closeModal: function() {
      this.showModal = false
    },

    updateItemInShiftData: function(value) {
      this.showModal = false
      this.$store.dispatch('updateItemInShiftData', value )

    },

    deleteItemInShiftData: function(itemID) {
      this.$store.dispatch("destroyShift", itemID)
    },

    formattedclockIn: function(clockIn) {
        return dayjs(clockIn).format('HH:mm');
    },

    formattedclockOut: function(clockIn) {
        return dayjs(clockIn).format('HH:mm');
    },

    getShiftData: function() {  
      var calendarDate = dayjs(this.year + '-' + this.month + '-' + this.date).format('DD/MM/YYYY')
      if(this.shiftData.length) {
        var shifts = this.shiftData.filter(function (item) {
          var shiftDate = dayjs(item.clock_in).format('DD/MM/YYYY')
          return calendarDate === shiftDate
        })

        return shifts.map(shift => {
          var user = this.userData.find(function (user) {
          return user.id === shift.user_id
          })
          return {
            ...shift,
            user: user
          }
        })
      }
    }
  }
}
</script>