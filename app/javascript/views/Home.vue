<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <calendar />
    <h2>ストック中の希望シフト</h2>
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
            <td> {{ item.year }}年{{ item.month }}月{{ item.day }}日</td>
            <td> {{ item.clockIn }}</td>
            <td> {{ item.clockOut }}</td>
            <button @click="openModal(index)">修正</button>
            <button @click="removeStorageShiftData(index)">×</button>
            <modal v-show="showModal" @close="closeModal" 
            :year="item.year"
            :month="item.month"
            :day="item.day"
            :dayNum="index">
            <p slot="title">希望シフト編集</p>
            <form slot="form">@submit.prevent="updateShift"</form>
            <span slot="submit">修正</span>

            </modal>
          </tr>
        </tbody>
      </table>
      <button @click="postshifts">シフトを提出</button>
    </div>
    
    <div v-else>
      <p>現在ストックされている希望シフトはありません</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Modal from 'Modal.vue'
import Calendar from '../components/Calendar.vue';
export default {
  components: {
    Modal,
    Calendar,
  },

  data() {
    return{
        showModal: false,
        dayNum: 0
    }
  },
  props: {
    shifts: {
      type: Array
    }
  },

  methods: {
    // シフト提出用のモーダルを開く
    openModal: function() {
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    // modalで入力しlocalStorageに一時保存されている希望データを
    // ①requestedShift_controllerにpostしテーブルに保存
    // ②localStorageのデータを削除
    postshifts: function() {
      if (window.confirm("入力した希望シフトをまとめて提出します、よろしいですか?")) {
      axios.post('/api/v1/requested_shifts', {shifts: this.shifts })
      this.$store.dispatch('deleteReqLists')   
      }
    },    removeStorageShiftData: function(shiftIdx) {
      this.$store.dispatch("removeStorageShiftData", {shiftIdx: shiftIdx})
    }
  }
}
</script>