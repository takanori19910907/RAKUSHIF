<!-- 確定シフト編集用ページ -->

<template>
  <div>
    <h2>確定シフト閲覧/編集</h2>
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
          <tr v-for="(item, index) in filteredShiftData" :key="item.id" >
            <td><userName :key="item.id" :userName="item.user.name" ></userName></td>
            <td><userAge :key="item.id" :userAge="item.user.age" ></userAge></td>
            <td><userWorkStatus :key="item.id" :userData="item.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="item.id" :clockIn="item.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="item.id" :clockOut="item.clock_out" ></requestedClockOutTime></td>
            <button @click="openModal(item, index)">修正</button>
            <button @click="deleteShiftInTableData(item.id, index)">×</button>
          </tr>
        </tbody>
      </table>
      <Modal v-if="showModal" @close="closeModal" 
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
        selectedShift: {},
        year: null,
        month: null,
        date: null,
        showModal: false,
        index: null
      }
    },

    created() {
      this.$store.dispatch("getAllShiftsByAdmin", { type: "fixed" } )
      this.$store.dispatch("getAllUsers")
    },

    computed: {
      // カレンダーで指定した日付のシフト情報とそのシフトのユーザー情報を取得し表示する
      filteredShiftData() {
        return this.$store.getters.filteredShiftData({
          date: {
            year: this.year,
            month: this.month,
            date: this.date
            },
            user: this.$store.state.allUsersData,
            shifts: this.$store.state.fixedShiftsInTableData
        })
      },
    },

    methods: {

      checkShifts(value) {
      // クリックしたカレンダーの日付情報をdataに格納しcomputed: filteredShiftでの処理に使用する
        this.year = value.year
        this.month = value.month
        this.date = value.date
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

      editFixedShiftInTableData(returnedModalData) {
        this.showModal = false
        this.$store.dispatch("updateShiftInTableData", { returnedModalData: returnedModalData, type: "fixed" } )
      },

      deleteShiftInTableData(selectedShiftID, index) {
        if (window.confirm(`このシフトを削除します、よろしいでしょうか?`)) {
        this.$store.state.fixedShiftsInTableData.splice(index, 1)
        this.$store.dispatch( "deleteShiftInTableData", {shiftID: selectedShiftID, type: "fixed"} )
        }
      },

      updateFixedShiftsInTableData() {
        console.log("update")
      }
  }
}
</script>