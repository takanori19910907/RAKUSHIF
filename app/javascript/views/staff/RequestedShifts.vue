<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <calendar />
    <h2>ストック中の希望シフト</h2>
    {{ shift }}
    <div v-if="shifts.length">
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
          <tr v-for="(item, index) in shifts" :key="item.id">
            <td> {{ item.year }}年{{ item.month }}月{{ item.date }}日</td>
            <td> {{ item.clockIn }}</td>
            <td> {{ item.clockOut }}</td>
            <button @click="openModal(item,index)">修正</button>
            <button @click="removeStorageShiftData(index)">×</button>
          </tr>
        </tbody>
      </table>
      <modal v-if="showModal" @close="closeModal" 
            :year="shift.year"
            :month="shift.month"
            :date="shift.date"
            :shiftIdx="shiftIdx"
            @sendRequestedShift="updateStorageShiftData"
            >
        </modal>
      <button @click="postshifts">シフトを提出</button>
    </div>
    
    <div v-else>
      <p>現在ストックされている希望シフトはありません</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Modal from 'components/Modal.vue'
import Calendar from 'components/RequestedShiftsCalendar.vue';
export default {
  components: {
    Modal,
    Calendar,
  },

  data() {
    return{
        showModal: false,
        shift: [],
        shiftIdx: 0
    }
  },

  props: [
    'shifts'
  ],

  methods: {
    // シフト提出用のモーダルを開く
    openModal: function(data, index) {
      this.shift = data
      this.shiftIdx = index
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    //modal-componentから返ってきたデータを用いてLocalStorageの希望シフトデータを更新する 
    updateStorageShiftData: function(data) {
      console.log(data);
      this.showModal = false
      this.$store.dispatch('updateShift', {
        clockIn: data.clockIn,
        clockOut: data.clockOut,
        shiftIdx: data.shiftIdx,
        year: data.year,
        month: data.month,
        date: data.date,
      })
    },

    // modalで入力しlocalStorageに一時保存されている希望データを
    // ①requestedShift_controllerにpostしテーブルに保存
    // ②localStorageのデータを削除
    postshifts: function() {
      if (window.confirm("入力した希望シフトをまとめて提出します、よろしいですか?")) {
      axios.post('/api/v1/staff/requested_shifts', {shifts: this.shifts })
      this.$store.dispatch('deleteReqLists')
      }
    },
    removeStorageShiftData: function(shiftIdx) {
      this.$store.dispatch("removeStorageShiftData", {shiftIdx: shiftIdx})
    }
  }
}
</script>