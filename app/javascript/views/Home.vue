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
            <button @click="openModal(index)">×</button>
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
        // weekdays: ['日', '月', '火', '水', '木', '金', '土'],
        // year: 2020,
        // month: 3,
        // day:-1,
        // today: '',
        showModal: false,
        dayNum: 0
    }
  },
  props: {
    shifts: {
      type: Array
    },
    // year: {
    //   type: Number
    // },
    // month: {
    //   type: Number
    // }
  },

  // mounted(){
  //   var date = new Date()
  //   var y = date.getFullYear()
  //   var m = ('0' + (date.getMonth() + 1)).slice(-2)
  //   var d = ('0' + date.getDate()).slice(-2)

  //   // yearとmonthを設定
  //   this.year = y
  //   this.month = Number(m)
  //   // 今日の日付を設定
  //   this.today = y + '-' + m + '-' + d
  // },

  methods: {
    // シフト提出用のモーダルを開く
    openModal: function() {
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    // // 当日かどうかの判定
    // isToday: function (day) {
    //     var date = this.year + '-' + ('0' + this.month).slice(-2) + "-" + day
    //     if(this.today === date){
    //         return true
    //     }
    //     return false
    // },

    // 先月のカレンダーを取得
    // setLastMonth: function () {
    //     if (this.month === 1) {
    //         this.year--
    //         this.month = 12
    //     } else {
    //         this.month--
    //     }
    //     this.day = -1
    // },

    // // 翌月のカレンダーを取得
    // setNextMonth: function () {
    //     if (this.month === 12) {
    //         this.year++
    //         this.month = 1
    //     } else {
    //         this.month++
    //     }
    //     this.day = -1
    // },
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
},

  computed: {
  //   calData: function () {
  //     var calData = []
  //     // 初日の曜日を取得
  //     var firstWeekDay = new Date(this.year, this.month - 1, 1).getDay()
  //     // 月の日数
  //     var lastDay = new Date(this.year, this.month, 0).getDate()
  //     // 日数カウント用
  //     var dayNum = 1
  //     // 週ごとのデータを作成して、calDateにpush
  //     while (dayNum <= lastDay) {
  //       var weekData = []
        
  //       // 日曜～土曜の日付データを配列で作成
  //       for (var i = 0; i <= 6; i++) {
  //         if (calData.length === 0 && i < firstWeekDay) {
  //           // 初週の1日以前の曜日は空文字
  //           weekData[i] = ''
  //         } else if (lastDay < dayNum) {
  //           // 最終日以降の曜日は空文字
  //           weekData[i] = ''
  //         } else {
  //           // 通常の日付入力
  //           weekData[i] = dayNum
  //           dayNum++
  //           }
  //         }
  //         calData.push(weekData)
  //     }
  //     return calData
  //   }
  }
}
</script>