<template>
  <div>
    <calendar @sendDate="checkShifts"/>
    <div v-if="this.month && this.date">
      <h2>{{ this.month }}月{{ this.date }}日の出勤予定者</h2>
    </div>
    <div v-if="filteredShiftData.length">
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(item) in filteredShiftData" :key="item.id" >
            <td><userName :key="item.id" :userName="item.user.name" ></userName></td>
            <td><userAge :key="item.id" :userAge="item.user.age" ></userAge></td>
            <td><userWorkStatus :key="item.id" :userData="item.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="item.id" :clockIn="item.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="item.id" :clockOut="item.clock_out" ></requestedClockOutTime></td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <div v-else>
      <p>出勤予定の方がいません</p>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  import dayjs from 'dayjs';
  import Calendar from '../../components/FixedShiftsCalendar.vue'
  import Modal from '../../components/Modal.vue'
  import UserName from '../../components/UserName.vue'
  import UserAge from '../../components/UserAge.vue'
  import UserWorkStatus from '../../components/UserWorkStatus.vue'
  import RequestedClockInTime from '../../components/RequestedClockInTime.vue'
  import RequestedClockOutTime from '../../components/RequestedClockOutTime.vue'
  export default {
    components: {
      Calendar,
      Modal,
      UserName,
      UserAge,
      UserWorkStatus,
      RequestedClockInTime,
      RequestedClockOutTime
    },

    data() {
      return{
        shiftData: [],
        userData: {},
        selectedShift: {},
        year: null,
        month: null,
        date: null,
        showModal: false
      }
    },

    created() {
      axios
        .get('/api/v1/admin/requested_shifts')
        .then(response => {
        this.shiftData = response.data.shifts
        this.userData = response.data.users
        })
    },

    computed: {
      filteredShiftData() {
        return this.$store.getters.filteredShiftData({
          date: {
            year: this.year,
            month: this.month,
            date: this.date
            },
            user: this.userData     
        })
      },
    },

    methods: {
      checkShifts(value) {
        this.year = value.year
        this.month = value.month
        this.date = value.date
        const shiftDates = this.$store.state.shifts.beforeCreateData.map((shift) => {
          return dayjs(shift.clock_in).date();
        });
        if (!shiftDates.includes(value.date)) {
          const selectedShifts = this.shiftData.filter((constShift) => {
            const checkedDate = dayjs(constShift.clock_in).date();
            return checkedDate === value.date;
          })
          for( var i = 0; i < selectedShifts.length; i++ ){
          this.$store.dispatch('fixedShifts', selectedShifts[i])
          }
        }
      },
  }
}
</script>