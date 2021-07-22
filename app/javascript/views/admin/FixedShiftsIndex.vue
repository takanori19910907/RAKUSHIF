<!-- 確定シフト編集用ページ -->

<template>
  <div>
    <h2>確定シフト閲覧/編集</h2>

    <calendar @sendDate="filterShifts"></calendar>
    
    <div v-if=" month && date">
      <h2>{{ month }}月{{ date }}日の出勤予定者</h2>
    </div>

    <div v-if="filteredShifts.length">
      <shift-table
        :shifts="filteredShifts"
        @sendDeleteShiftId="deleteShiftInTableData"
        @openModal="openModal"
        >
      </shift-table>

      <modal v-if="showModal" @close="closeModal" 
        :year="year"
        :month="month"
        :date="date"
        :shift="selectedShift"
        :shiftId="selectedShift.id"
        :userId="selectedShift.user_id"
        :index="index"
        :title="'確定シフトの編集'"
        :subtitle="'シフトを編集'"
        :footerMessage="'上記の時刻に変更します'"
        :submit="'変更'"
        @sendShiftsData="editFixedShiftInTableData"
        >
      </Modal>
      <button @click="updateFixedShiftsInTableData()">シフト変更完了</button>
    </div>
    <div v-else-if="this.date === null ">
      <p>カレンダーをクリックするとその日付の出勤予定者を確認出来ます</p>
    </div>
    <div v-else>
      <p>出勤予定の方がいません</p>
      <p>シフトの人員補充をお願いします</p>
    </div>
  </div>
</template>

<script>
  import dayjs from "dayjs";
  import axios from "axios"
  import Calendar from "../../components/FixedShiftsCalendar.vue"
  import Modal from "../../components/Modal.vue"
  import ShiftTable from  "../../components/shiftTables/AdminShiftTable.vue"
  export default {
    components: {
      Calendar,
      Modal,
      ShiftTable
    },

    data() {
      return{
        fixedShifts: [],
        filteredShifts: [],
        selectedShift: {},
        year: 0,
        month: 0,
        date: 0,
        index: 0,
        showModal: false
      }
    },

    created() {
      this.$store.dispatch("getAllShiftsByAdmin", { type: "fixed" } )
      this.$store.dispatch("getAllUsers")
    },

      this.fetchFixedShifts();
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

      openModal(data, index) {
        this.index = index
        this.selectedShift = data
        this.showModal = true
      },
      
      closeModal() {
        this.showModal = false
      },

      // type属性をつけてstoreのactionsで条件分岐に用いる
      filterShifts(date) {
        this.year = date.year
        this.month = date.month
        this.date = date.date
        const calendarDate = dayjs(date.year + "-" + date.month + "-" + date.date).format("DD/MM/YYYY")
        this.filteredShifts =  this.fixedShifts.filter(shift => calendarDate === dayjs(shift.clock_in).format("DD/MM/YYYY"))
      },

      async editFixedShiftInTableData(returnedModalData) {
        this.showModal = false
        await axios.patch(`/api/v1/admin/fixed_shifts/${returnedModalData.shiftId}`, {
          shiftData: {
            year: returnedModalData.year,
            month: returnedModalData.month,
            date: returnedModalData.date,
            clockIn: returnedModalData.clockIn,
            clockOut: returnedModalData.clockOut,
            user_id: returnedModalData.userId
          }
        })
        await this.fetchFixedShifts();
        this.filterShifts(returnedModalData);
      },

      async deleteShiftInTableData(selectedShiftID, index) {
        if (window.confirm(`このシフトを削除します、よろしいでしょうか?`)) {
          this.fixedShifts.splice(index, 1)
          this.filteredShifts.splice(index, 1)
          await axios.delete(`/api/v1/admin/fixed_shifts/${selectedShiftID}`)
        }
        this.fetchFixedShifts();
      }
  }
}
</script>