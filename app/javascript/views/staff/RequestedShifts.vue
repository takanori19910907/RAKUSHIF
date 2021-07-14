<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <h2>希望シフト作成</h2>
    <calendar />
    <p>ストック中の希望シフト</p>
    <div v-if="this.$store.state.temporarilyRequestedShifts.length">
      <b>※下記のシフト希望はまだ提出されていません</b>
      <p>期日までにシフト希望の提出を完了させてください</p>
      <hr>
      <table>
        <tbody>
          <tr>
            <th>希望日</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(item, index) in this.$store.state.temporarilyRequestedShifts" :key="item.id">
            <td> {{ item.year }}年{{ item.month }}月{{ item.date }}日</td>
            <td> {{ item.clockIn }}</td>
            <td> {{ item.clockOut }}</td>
            <button @click="openModal(item,index)">修正</button>
            <button @click="deleteRequestedShiftInStorageData(index)">×</button>
          </tr>
        </tbody>
      </table>
      <modal v-if="showModal" @close="closeModal" 
        :year="shift.year"
        :month="shift.month"
        :date="shift.date"
        :index="index"
        :title="'希望シフトの修正'"
        :subtitle="'希望内容を変更'"
        :footerMessage="'上記の時刻に変更します'"
        :submit="'変更'"
        @sendShiftsData="updateRequestedShiftInStorageData"
      >
      </modal>
      <button @click="postshifts">シフトを提出</button>
    </div>

    <div v-else-if="this.guideMessage">
      <p>カレンダーをクリックすると、シフト希望用の入力フォームが表示されます</p>
      <p>希望の出勤/退勤時間を入力し『確定』を押すと希望シフトが一時的にストックされます</p>
      <p>作成期間全て入力を終えたら『シフトを提出』を押してください</p>
    </div>
    
    <div v-else>
      <p>現在ストックされている希望シフトはありません</p>
    </div>
  </div>
</template>

<script>
  import Modal from "components/Modal.vue"
  import Calendar from "components/RequestedShiftsCalendar.vue";
  export default {
    components: {
      Modal,
      Calendar,
    },

    data() {
      return{
        showModal: false,
        shift: [],
        shiftId: 0,
        guideMessage: true
      }
    },

    created() {
      this.$store.dispatch("resetRequestedShifts")
      this.guideMessage = true
    },

    methods: {
      // シフト提出用のモーダルを開く
      openModal(data, index) {
        this.guideMessage = false
        this.shift = data
        this.index = index
        this.showModal = true
      },
      
      // シフト提出用のモーダルを閉じる
      closeModal() {
        this.showModal = false
      },

      //modal-componentから返ってきたデータを用いてLocalStorageの希望シフトデータを更新する 
      updateRequestedShiftInStorageData(data) {
        this.showModal = false
        this.$store.dispatch("updateRequestedShiftInStorageData", {
          clockIn: data.clockIn,
          clockOut: data.clockOut,
          shiftId: data.shiftId,
          year: data.year,
          month: data.month,
          date: data.date,
        })
      },

      // modalで入力しlocalStorageに一時保存されている希望データを
      // ①requestedShift_controllerにpostしテーブルに保存
      // ②localStorageのデータを削除
      async postshifts() {
        await this.$store.dispatch("postRequestedShiftsInTheTable" )
        this.$store.dispatch("resetRequestedShifts")
      },

      deleteRequestedShiftInStorageData(shiftId) {
        this.$store.dispatch("deleteRequestedShiftInStorageData", {shiftId: shiftId})
      }
    }
}
</script>