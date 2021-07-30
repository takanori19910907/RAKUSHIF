<!-- 希望シフト確認用ページ(ユーザー用) -->

<template>
  <div>
    <calendar @calendarClicked="checkDate" @changeMonth="fetchFixedShifts"/>
    <div v-if="this.month && this.date">
      <h2>{{ this.month }}月{{ this.date }}日の出勤予定者</h2>
    </div>

    <shift-table
      :shifts="filteredShifts"
      :editPermission="false"
    ></shift-table>
  </div>
</template>

<script>
  import dayjs from "dayjs";
  import Calendar from "components/molecules/calendars/FixedShiftsCalendar.vue"
  import axios from "axios";
  import ShiftTable from 'components/molecules/tables/UserShiftTable';

  export default {
    components: {
      Calendar,
      ShiftTable
    },

    data() {
      return{
        year: 0,
        month: 0,
        date: 0,
        fixedShifts: []
      }
    },
    created() {
      this.fetchFixedShifts();
    },

    computed: {
      filteredShifts() {
        const calendarDate = dayjs(this.year + "-" + this.month + "-" + this.date).format("DD/MM/YYYY")
        return this.fixedShifts.filter(shift => calendarDate === dayjs(shift.clock_in).format("DD/MM/YYYY"))
      }
    },

    methods: {
      async fetchFixedShifts(month) {
        // カレンダーcomponentで月の変更があったときはparamとして月データを送る
        const response = await axios.get(
          "/api/v1/staff/fixed_shifts",{
            params: { month: month }
          })
        this.fixedShifts = response.data
      },

      checkDate(date) {
        // クリックカレンダーの日付情報をdataに格納しcomputed: filteredShiftでの処理に使用する
        this.year = date.year
        this.month = date.month
        this.date = date.date
      },
    }
}
</script>