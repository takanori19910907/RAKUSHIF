<!-- 確定シフト作成用ページ -->

<template>
  <div>
    <h2>シフト新規作成</h2>
    <calendar @sendDate="checkShifts"/>
    <div v-if="this.month && this.date">
      <h2>{{ this.month }}月{{ this.date }}日のシフト希望一覧</h2>
    </div>
    <p></p>
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
            <button @click="deleteFixedShiftInStorageData(item.id)">×</button>
          </tr>
        </tbody>
      </table>
      <Modal v-if="showModal" @close="closeModal" 
        :year="year"
        :month="month"
        :date="date"
        :shift="selectedShift"
        :shiftId="selectedShift.id"
        :index="index"
        :title="'確定シフトの作成'"
        :subtitle="'シフトを変更'"
        :footerMessage="'上記の時刻に変更します'"
        :submit="'変更'"
        @sendShiftsData="updateFixedShiftInStorageData"
        >
      </Modal>
      <p>出勤者を決定したら『シフト確定』を押してください</p>
      <button @click="createFixedShifts">シフト確定</button>
    </div>
    <div v-else-if="this.date === null ">
      <p>カレンダーをクリックすると、日付ごとにスタッフの希望シフトが表示されます</p>
      <p>各日付でシフトを修正/削除し出勤者を決めてください</p>
    </div>
    <div v-else>
      <p>出勤予定の方がいません</p>
      <p>シフトの人員補充をお願いします</p>
    </div>
  </div>
</template>

<script>
  import Calendar from "../../components/FixedShiftsCalendar.vue"
  import Modal from "../../components/Modal.vue"
  import UserName from "../../components/shiftTables/modules/UserName.vue"
  import UserAge from "../../components/shiftTables/modules/UserAge.vue"
  import UserWorkStatus from "../../components/shiftTables/modules/UserWorkStatus.vue"
  import RequestedClockInTime from "../../components/shiftTables/modules/RequestedClockInTime.vue"
  import RequestedClockOutTime from "../../components/shiftTables/modules/RequestedClockOutTime.vue"
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
        year: 0,
        month: 0,
        date: 0,
        index: 0,
        showModal: false
      }
    },

    created() {
      this.$store.dispatch("getAllShiftsByAdmin", { type: "requested" } )
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
            shifts: this.$store.state.requestedShiftsInTableData
        })
      },
    },

    methods: {
      // クリックしたカレンダーの日付情報をdataに格納しcomputed: filteredShiftでの処理に使用する
      checkShifts(value) {
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
      
      async createFixedShifts() {
        if ( window.confirm("確定シフトを作成します、よろしいですか?")) {
          await this.$store.dispatch("createFixedShifts", this.$store.state.requestedShiftsInTableData )}
        this.$router.push("/admin/fixed_shifts")
      },

      updateFixedShiftInStorageData(data) {
        this.showModal = false
        this.$store.dispatch("updateFixedShiftInStorageData", data )
      },

      deleteFixedShiftInStorageData(itemID) {
        this.$store.dispatch("deleteFixedShiftInStorageData", itemID)
      }
  }
}
</script>