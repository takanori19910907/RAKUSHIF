<template>
  <div>
    <!-- カレンダーヘッダ -->
    <div id="cal-header">
      <span class="header-arrow" @click="setLastMonth">＜</span>
      <span class="selected-month">{{year}}年{{month}}月</span>
      <span class="header-arrow" @click="setNextMonth">＞</span>
    </div>

    <!-- カレンダーメイン -->
    <table id="cal-main">
      <!-- 曜日を表示させる（テーブルヘッダ） -->
      <thead>
        <th v-for="(dayname,index) in weekdays" :key="index">{{dayname}}</th>
      </thead>
      <!-- 日付を表示させる（テーブルボディ） -->
      <tbody>
        <tr v-for="(weekData,index) in calData" :key="index">
          <td class="cal-day" v-for="(dayNum,index) in weekData" :key="index" 
            @click="openModal(index)"
            :class="{'cal-today': isToday(dayNum), active: day === dayNum}"
          >
            <span v-if="isToday(dayNum)">今日</span>
            <span v-else>{{dayNum}}</span>
          </td>
        </tr>
      </tbody>
    </table>
    <!-- <div id="overlay" v-show="showModal" v-on:click="closeRequestShiftModal">
      <div id="modal">
        <p>モーダル</p>
        <button v-on:click="closeRequestShiftModal">close</button>
      </div> -->
      <modal :val="dayNum" v-show="showModal" @close="closeModal" />
    <!-- </div> -->
  </div>
</template>
<script>
import Modal from 'Modal.vue'
export default {
    components: {
      Modal
    },
    data(){
        return{
            weekdays: ['日', '月', '火', '水', '木', '金', '土'],
            year:2020,
            month:3,
            day:-1,
            today: '',
            showModal: false,
            dayNum: 0
        }
    },
    mounted(){
      var date = new Date()
      var y = date.getFullYear()
      var m = ('0' + (date.getMonth() + 1)).slice(-2)
      var d = ('0' + date.getDate()).slice(-2)

      // yearとmonthを設定
      this.year = y
      this.month = Number(m)
      // 今日の日付を設定
      this.today = y + '-' + m + '-' + d
    },
    methods: {
        /**
         * カレンダー日付クリック時の処理
         */
        // openRequestShiftModal: function (reqNum) {
        //   this.showModal = true
        // },
        // closeRequestShiftModal: function () {
        //   this.showModal = false
        // },
        /**
         * 今日かどうかの判定
         * 年、月は現在選択しているページ
         * 日は引数
         */
        openModal: function(num) {
          this.showModal = true
          this.dayNum = num
        },
        closeModal: function() {
          this.showModal = false
        },
        isToday: function (day) {
            var date = this.year + '-' + ('0' + this.month).slice(-2) + "-" + day
            if(this.today === date){
                return true
            }
            return false
        },
        /**
         * 先月のカレンダーを取得
         */
        setLastMonth: function () {
            if (this.month === 1) {
                this.year--
                this.month = 12
            } else {
                this.month--
            }
            this.day = -1
        },
        /**
         * 翌月のカレンダーを取得
         */
        setNextMonth: function () {
            if (this.month === 12) {
                this.year++
                this.month = 1
            } else {
                this.month++
            }
            this.day = -1
        }
    },

    computed: {
        calData: function () {
            var calData = []
            // 初日の曜日を取得
            var firstWeekDay = new Date(this.year, this.month - 1, 1).getDay()
            // 月の日数
            var lastDay = new Date(this.year, this.month, 0).getDate()
            // 日数カウント用
            var dayNum = 1
            // 週ごとのデータを作成して、calDateにpush
            while (dayNum <= lastDay) {
                var weekData = []
                
                // 日曜～土曜の日付データを配列で作成
                for (var i = 0; i <= 6; i++) {
                    if (calData.length === 0 && i < firstWeekDay) {
                        // 初週の1日以前の曜日は空文字
                        weekData[i] = ''
                    } else if (lastDay < dayNum) {
                        // 最終日以降の曜日は空文字
                        weekData[i] = ''
                    } else {
                        // 通常の日付入力
                        weekData[i] = dayNum
                        dayNum++
                    }
                }
                calData.push(weekData)
            }
            return calData
        }
    },
    showModalWindow: function() {

    }
}
</script>
<style scoped>
</style>