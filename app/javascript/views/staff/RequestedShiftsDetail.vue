<!-- 提出済みのシフト希望一覧ページ -->

<template>
  <section id="about">
    <h3>提出済みのシフト一覧</h3>
    <div v-if="this.$store.state.myRequestedShifts.length">
    <hr>
    <table>
      <tbody>
        <tr>
          <th>希望日</th>
          <th>希望出勤時間</th>
          <th>希望退勤時間</th>
        </tr>
        <tr v-for="(item, index) in this.$store.state.myRequestedShifts" :key="item.id">
          <td><requestedDate :key="item.id" :clockIn ="item.clock_in" ></requestedDate></td>
          <td><requestedClockInTime :key="item.id" :clockIn="item.clock_in" ></requestedClockInTime></td>
          <td><requestedClockOutTime :key="item.id" :clockOut="item.clock_out" ></requestedClockOutTime></td>
          <button @click="openModal(item)">修正</button>
          <button @click="deleteShiftInTableData(item.id, index)">×</button>
        </tr>
      </tbody>
    </table>
    <modal v-if="showModal" 
                @close="closeModal" 
                @sendShiftsData="updateShiftInTableData"
                :shift="shift"
                :year="year"
                :month="month"
                :date="date"
                :shiftId="shiftId"
                :title="'申請済みの希望シフトを編集'"
                :subtitle="'シフトを編集'"
                :footerMessage="'上記の時刻に変更します'"
                :submit="'変更'"
                >
    </modal>
    </div>
    <div v-else>
      <p>シフト希望がありません</p>
      <p>希望シフト作成ページで入力し提出してください</p>
    </div>
  </section>
</template>

<script>
  import Modal from "components/Modal.vue"
  import RequestedDate from "../../components/RequestedDate.vue"
  import RequestedClockInTime from "../../components/RequestedClockInTime.vue"
  import RequestedClockOutTime from "../../components/RequestedClockOutTime.vue"
  export default {
    components: {
      Modal,
      RequestedDate,
      RequestedClockInTime,
      RequestedClockOutTime
    },

    
    data() {
      return {
        shift: {},
        year: 0,
        month: 0,
        date: 0,
        shiftId: 0,
        showModal: false
      };
    },

    props: [
      "userID"
    ],
      
    created() {
    this.$store.dispatch("getMyShiftData")
    },

    methods: {
      // シフト提出用のモーダルを開く
      openModal(data) {
        this.year = this.$store.getters.formattedYear(data.clock_in)
        this.month = this.$store.getters.formattedMonth(data.clock_in)
        this.date = this.$store.getters.formattedDate(data.clock_in)
        this.shift = data
        this.shiftId = data.id
        this.showModal = true
      },
      
      // シフト提出用のモーダルを閉じる
      closeModal() {
        this.showModal = false
      },

      //modal-componentから帰ってきたシフト希望データを用いて希望シフトテーブルの値を更新する
      updateShiftInTableData(returnedModalData) {
        this.showModal = false
        this.$store.dispatch("updateShiftInTableData", {returnedModalData: returnedModalData, type: "requested" })
      },
      
      //クリックで指定した希望データを希望シフトテーブルから削除する 
      deleteShiftInTableData(selectedShiftID, index) {
        if (window.confirm(`このシフトを削除します、よろしいでしょうか?`)) {
          this.$store.state.myRequestedShifts.splice(index, 1)
          this.$store.dispatch( "deleteShiftInTableData", {
            shiftID: selectedShiftID,
            type: "requested"}
            )
        }
      }
    }
};
</script>