<!-- 希望シフト確認用ページ(ユーザー用) -->

<template>
  <div>
    <calendar @sendDate="checkShifts"/>
    <div v-if="this.month && this.date">
      <h2>{{ this.month }}月{{ this.date }}日の出勤予定者</h2>
    </div>

    <shift-table
      :filteredShifts="filteredShifts"
      :admin="false"
    ></shift-table>
  </div>
</template>

<script>
  import dayjs from "dayjs";
  import Calendar from "../../components/FixedShiftsCalendar.vue"
  import axios from "axios";
  import ShiftTable from '../../components/ShiftTable.vue';

  export default {
    components: {
      Calendar,
      ShiftTable
    },

    data() {
      return{
        shiftData: [],
        userData: {},
        selectedShift: {},
        year: null,
        month: null,
        date: null,
        fixedShifts: [],
        filteredShifts: []
      }
    },
    created() {
      this.fetchFixedShifts();
    },

    methods: {
      async fetchFixedShifts() {
        const response = await axios.get("/api/v1/staff/fixed_shifts")
        this.fixedShifts = response.data
        console.log(this.fixedShifts)
      },
      // クリックカレンダーの日付情報をdataに格納しcomputed: filteredShiftでの処理に使用する
      checkShifts(checkDate) {
        const calendarDate = dayjs(checkDate.year + "-" + checkDate.month + "-" + checkDate.date).format("DD/MM/YYYY")
        this.filteredShifts =  this.fixedShifts.filter(shift => calendarDate === dayjs(shift.clock_in).format("DD/MM/YYYY"))
      }
    },
}
</script>