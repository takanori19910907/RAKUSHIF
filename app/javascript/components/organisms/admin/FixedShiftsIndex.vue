<!-- 確定シフト編集用ページ -->

<template>
  <div>
    <h2>確定シフト閲覧/編集</h2>

    <calendar @calendarClicked="checkDate"></calendar>
    
    <div v-if=" month && date">
      <h2>{{ month }}月{{ date }}日の出勤予定者</h2>
    </div>

    <div v-if="!date">
      <p>カレンダーをクリックするとその日付の出勤予定者を確認出来ます</p>
    </div>

    <div v-else>
      <div v-if="filteredShifts.length">
        <shift-table
          :shifts="filteredShifts"
          @deleteButtonPushed="deleteShiftInTableData"
          @editButtonPushed="openModal"
          >
        </shift-table>
      </div>
      
      <div v-else>
        <p>出勤予定の方がいません</p>
        <p>シフトの人員補充をお願いします</p>
      </div>
    </div>

    <modal v-if="showModal" @close="closeModal" 
      :year="year"
      :month="month"
      :date="date"
      :shift="selectedShift"
      :shiftId="selectedShift.id"
      :userId="selectedShift.user_id"
      :title="'確定シフトの編集'"
      :subtitle="'シフトを編集'"
      :footerMessage="'上記の時刻に変更します'"
      :submit="'変更'"
      @sendShiftsData="editFixedShiftInTableData"
      >
    </modal>
  </div>
</template>

<script>
  import dayjs from "dayjs";
  import axios from "axios"
  import Calendar from "components/molecules/calendars/FixedShiftsCalendar.vue"
  import Modal from "components/molecules/modals/Modal.vue"
  import ShiftTable from  "components/molecules/tables/AdminShiftTable.vue"
  export default {
    components: {
      Calendar,
      Modal,
      ShiftTable
    },

    data() {
      return {
        fixedShifts: [],
        selectedShift: [],
        year: 0,
        month: 0,
        date: 0,
        showModal: false
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
          "/api/v1/admin/fixed_shifts",{
            params: { month: month }
          })
        this.fixedShifts = response.data
      },

      openModal(shift) {
        this.selectedShift = shift
        this.showModal = true
      },
      
      closeModal() {
        this.showModal = false
      },

      checkDate(date) {
        this.year = date.year
        this.month = date.month
        this.date = date.date
      },

      async editFixedShiftInTableData(params) {
        this.showModal = false
        const { year, month, date, clockIn, clockOut, userId } = params
        await axios.patch(`/api/v1/admin/fixed_shifts/${params.shiftId}`, {
          shiftData: { year, month, date, clockIn, clockOut, userId }
        })
        await this.fetchFixedShifts();
      },

      async deleteShiftInTableData(selectedShiftID) {
        if (window.confirm(`このシフトを削除します、よろしいでしょうか?`)) {
          await axios.delete(`/api/v1/admin/fixed_shifts/${selectedShiftID}`)
        }
        this.fetchFixedShifts();
      }
  }
}
</script>