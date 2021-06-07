<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <calendar @sendDate="checkShifts"/>
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
          <tr v-for="(data, index) in getShiftData" :key="data.id" >
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
      <button>シフト確定</button>
    </div>
    
    <div v-else>
      <p>提出されている希望シフトはありません</p>
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

  computed: {
    getShiftData: function() {
      return this.$store.getters.getShiftData({
        date: {
          year: this.year,
          month: this.month,
          date: this.date
          },
        user: this.userData
        }
      )
    },
  },

  methods: {
  checkShifts: function(value) {
      // console.log(1);
      this.year = value.year
      this.month = value.month
      this.date = value.date
      var shiftsDate = this.$store.state.fixedShifts.map(shift => {
          return dayjs(shift.clock_in).format('DD/MM/YYYY')
      })
      var calendarDate = dayjs(value.year + '-' + value.month + '-' + value.date).format('DD/MM/YYYY')
      if(!shiftsDate.includes(calendarDate)) {
        // console.log(2);
        axios
        .get('/api/v1/admin/requested_shifts', { params: { year: value.year, month: value.month, date: value.date }})
        .then(response => {
          this.shiftData = response.data
          if(!!this.shiftData.length){
        // console.log(3);
            for( var i = 0; i < this.shiftData.length; i++ )
            this.$store.dispatch('fixedShifts', this.shiftData[i])
            }
          })
      } else {
        // console.log(4);
        return this.$store.state.fixedShifts
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
      console.log(clockIn)
        return dayjs(clockIn).format('HH:mm');
    },

    formattedclockOut: function(clockIn) {
        return dayjs(clockIn).format('HH:mm');
    },
  }
}
</script>