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
            <!-- <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th> -->
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(data, index) in filteredShiftData" :key="data.id" >
            <!-- <td><userName :key="data.id" :userName="data.user.name" ></userName></td>
            <td><userAge :key="data.id" :userAge="data.user.age" ></userAge></td>
            <td><userWorkStatus :key="data.id" :userData="data.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="data.id" :clockInTime="data.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="data.id" :clockOutTime="data.clock_out" ></requestedClockOutTime></td> -->
            {{ data.clock_in }}
            {{ data.clock_out }}
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
      <button @click="createFixedShift">シフト確定</button>
    </div>
    
    <!-- <div v-else>
      <p>提出されている希望シフトはありません</p>
    </div> -->
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
        shifts: [],
        shiftData: [],
        userData: {},
        year: null,
        month: null,
        date: null,
        checkedShift: {},
        showModal: false,
        arrayIdx: 0
    }
  },

  created() {
    // axios
    //   .get('/api/v1/admin/users')
    //   .then(response => (this.userData = response.data))
    axios
      .get('/api/v1/admin/requested_shifts')
      .then(response => {
      this.shiftData = response.data
      })
  },

  computed: {
    filteredShiftData: function() {
      return this.shifts
        .filter((shift) => {
          const targetDate = dayjs(shift.clock_in).date();
          return targetDate === this.date;
        })
        .map((shift) => {
          return { ...shift, user: "(dummy)" };
        });
    },
  },

  methods: {
  checkShifts: function(value) {
      this.date = value.date
      const shiftDates = this.shifts.map((shift) => {
        return dayjs(shift.clock_in).date();
      });
      if (!shiftDates.includes(value.date)) {
          this.shiftData
            .filter((constShift) => {
              const checkedDate = dayjs(constShift.clock_in).date();
              return checkedDate === value.date;
            })
            .forEach((constShift) => {
              this.shifts.push(constShift);
          })
      }
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
  }
}
</script>