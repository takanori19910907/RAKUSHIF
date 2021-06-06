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
          <tr v-for="data in getShiftData" :key="data.id" >
            <td><userName :key="data.id" :userName="data.user.name" ></userName></td>
            <td><userAge :key="data.id" :userAge="data.user.age" ></userAge></td>
            <td><userWorkStatus :key="data.id" :userData="data.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="data.id" :clockInTime="data.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="data.id" :clockOutTime="data.clock_out" ></requestedClockOutTime></td>
            <!-- <button @click="openModal">修正</button> -->
            <button @click="deleteItemInShiftData(data.id)">×</button>
            <!-- <modal v-show="showModal" @close="closeModal" 
            :year="shift.year"
            :month="shift.month"
            :day="shift.day"
            :shiftIdx="dayNum"
            @sendRequestedShift="updateStorageShiftData" -->
            <!-- > -->
            <!-- <p slot="title">希望シフト編集</p>
            <p slot="subtitle">{{ item.year }}年{{ item.month }}月{{ item.day }}日の希望時間を変更します</p>
            </modal> -->
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
        userData: {},
        year: 2021,
        month: 6,
        date: 5,
        showModal: false
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
      this.year = value.year
      this.month = value.month
      this.date = value.date
      var shiftsDate = this.$store.state.fixedShifts.map(shift => {
          return dayjs(shift.clock_in).format('DD/MM/YYYY')
      })
      var calendarDate = dayjs(value.year + '-' + value.month + '-' + value.date).format('DD/MM/YYYY')
      if(!shiftsDate.includes(calendarDate)) {
        axios
        .get('/api/v1/admin/requested_shifts', { params: { year: value.year, month: value.month, date: value.date }})
        .then(response => {
          this.shiftData = response.data
          if(!!this.shiftData.length){
            for( var i = 0; i < this.shiftData.length; i++ )
            this.$store.dispatch('fixedShifts', this.shiftData[i])
            }
          })
      }
    },
    // openModal: function() {
    //   this.showModal = true
    // },
    
    // closeModal: function() {
    //   this.showModal = false
    // },

    // updateItemInShiftData: function(itemID) {
    
    // },

    deleteItemInShiftData: function(itemID) {
      this.$store.dispatch("destroyShift", itemID)
    }
  }
}
</script>