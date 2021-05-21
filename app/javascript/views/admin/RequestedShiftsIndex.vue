<!-- 希望シフト提出用ページ -->

<template>
  <div>
    <calendar />
    <h2>みんなの希望シフト一覧</h2>
    <div v-if="shifts.length">
      <hr>
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(item, index) in shifts" :key="item.id">
            <td>たかのりさん</td>
            <td> {{ item.clockIn }} </td>
            <td> {{ item.clockOut }} </td>
            <button @click="openModal(item,index)">修正</button>
            <button @click="removeStorageShiftData(index)">×</button>
            <modal v-show="showModal" @close="closeModal" 
            :year="shift.year"
            :month="shift.month"
            :day="shift.day"
            :shiftIdx="dayNum"
            @sendRequestedShift="updateStorageShiftData"
            >
            <p slot="title">希望シフト編集</p>
            <p slot="subtitle">{{ item.year }}年{{ item.month }}月{{ item.day }}日の希望時間を変更します</p>
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
import Calendar from '../../components/Calendar.vue';
export default {
  components: {
    Calendar,
  },

  data() {
    return{
        showModal: false,
        shift: [],
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
    openModal: function(data, index) {
      this.shift = data
      this.dayNum = index
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    //modal-componentから返ってきたデータを用いてLocalStorageの希望シフトデータを更新する 
    updateStorageShiftData: function(...data) {
      this.$store.dispatch('updateShift', {
        clockIn: data[0],
        clockOut: data[1],
        shiftIdx: data[2],
        year: data[3],
        month: data[4],
        day: data[5],
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