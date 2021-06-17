<!-- ログインユーザーのシフト希望(提出済み)一覧ページ -->

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
          <button @click="removeShiftInTableData(item.id, index)">×</button>
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
                :title=" '申請済みの希望シフトを編集' "
                :subtitle=" 'シフトを編集' "
                :footerMessage=" '上記の時刻に変更します' "
                :submit=" '変更' "
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
  import axios from 'axios';
  import Modal from 'components/Modal.vue'
  import RequestedDate from '../../components/RequestedDate.vue'
  import RequestedClockInTime from '../../components/RequestedClockInTime.vue'
  import RequestedClockOutTime from '../../components/RequestedClockOutTime.vue'
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
        year: null,
        month: null,
        date: null,
        shiftId: null,
        showModal: false
      };
    },

    props: [
      'userID'
    ],
      
    created() {
    this.$store.dispatch('getMyShiftsData')
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
      updateShiftInTableData(data) {
        this.showModal = false
        this.$store.dispatch('updateShiftInTableData', data)
      },
      
      //クリックで指定した希望データを希望シフトテーブルから削除する 
      removeShiftInTableData(id, index) {
        this.$store.state.myRequestedShifts.splice(index, 1)
        this.$store.dispatch( 'removeShiftInTableData', id )
      }
    }
};
</script>