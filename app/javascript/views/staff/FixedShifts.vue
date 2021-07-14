<!-- 希望シフト確認用ページ(ユーザー用) -->

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
  import dayjs from "dayjs";
  import Calendar from "../../components/FixedShiftsCalendar.vue"
  import Modal from "../../components/Modal.vue"
  import UserName from "../../components/UserName.vue"
  import UserAge from "../../components/UserAge.vue"
  import UserWorkStatus from "../../components/UserWorkStatus.vue"
  import RequestedClockInTime from "../../components/RequestedClockInTime.vue"
  import RequestedClockOutTime from "../../components/RequestedClockOutTime.vue"
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
      this.$store.dispatch("getAllShiftByStaff")
      this.$store.dispatch("getAllUsers")
    },

    computed: {
      // カレンダーで指定した日付のシフト情報とそのシフトのユーザー情報を取得し表示する
      filteredShiftData() {
        const calendarDate = dayjs(this.year + "-" + this.month + "-" + this.date).format("DD/MM/YYYY")
      const shifts = this.$store.state.fixedShiftsInTableData.filter(function (item) {
        const shiftDate = dayjs(item.clock_in).format("DD/MM/YYYY")
        return calendarDate === shiftDate
      })
      return shifts.map(shift => {
        const user = this.$store.state.allUsersData.find(function (user) {
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
      // クリックカレンダーの日付情報をdataに格納しcomputed: filteredShiftでの処理に使用する
      checkShifts(value) {
        this.year = value.year
        this.month = value.month
        this.date = value.date
      },
  }
}
</script>