<!-- 希望シフト提出/確定シフト確認に用いるカレンダー -->

<template>
  <div>
  <!-- カレンダータイトル -->
    <div id="cal-header">
      <span class="header-arrow" @click="setLastMonth">＜</span>
      <span class="selected-month">{{year}}年{{month}}月</span>
      <span class="header-arrow" @click="setNextMonth">＞</span>
    </div>

    <!-- カレンダーメイン -->

    <table id="cal-main">

      <!-- 曜日表示 -->
      <thead>
        <th v-for="(dayname,index) in weekdays" :key="index">{{dayname}}</th>
      </thead>

      <!-- 日付表示 -->
      <tbody>
        <tr v-for="(weekData,index) in calData" :key="index">
          <td class="cal-day" v-for="(dayNum,index) in weekData" @click="openModal(dayNum, index)"
            :key="index"
            :class="{'cal-today': isToday(dayNum), active: day === dayNum}">
            <span v-if="isToday(dayNum)">今日</span>
            <span v-else>{{dayNum}}</span>
          </td>
        </tr>
      </tbody>
    </table>
    <modal v-if="showModal" @close="closeModal"
      :year="year"
      :month="month"
      :date="dayNum"
      :title=" '希望シフトの作成' "
      :subtitle=" 'シフトを作成' "
      :footerMessage=" '上記の日時で作成します' "
      :submit=" '作成' "
      @sendShiftsData="addRequestedShift"
      >
      </modal>
  </div>
</template>

<script>
  import Modal from "components/Modal.vue"
  export default {
    components: {
      Modal
    },
    data() {
      return {
        weekdays: ['日', '月', '火', '水', '木', '金', '土'],
        year: 2020,
        month: 3,
        day:-1,
        today: '',
        showModal: false,
        dayNum: 0
      }
    },

    mounted(){
      const date = new Date()
      const y = date.getFullYear()
      const m = ('0' + (date.getMonth() + 1)).slice(-2)
      const d = ('0' + date.getDate()).slice(-2)

      // yearとmonthを設定
      this.year = y
      this.month = Number(m)
      // 今日の日付を設定
      this.today = y + '-' + m + '-' + d
    },

    methods: {
      // 当日かどうかの判定
      isToday(day) {
        const date = this.year + '-' + ('0' + this.month).slice(-2) + "-" + day
        if(this.today === date){
          return true
        }
        return false
      },

      // 先月のカレンダーを取得
      setLastMonth() {
        if (this.month === 1) {
          this.year--
          this.month = 12
        } else {
          this.month--
        }
        this.day = -1
      },

      // 翌月のカレンダーを取得
      setNextMonth() {
        if (this.month === 12) {
          this.year++
          this.month = 1
        } else {
          this.month++
        }
        this.day = -1
      },

      // シフト提出用のモーダルを開く
      openModal(date) {
        this.dayNum = date
        this.showModal = true
      },
      
      // シフト提出用のモーダルを閉じる
      closeModal() {
        this.showModal = false
      },

      // modal-componentから返ってきたデータを用いて希望シフトを作成しLocalStorageに保存する
      addRequestedShift(data) {
        this.showModal = false
        this.$store.dispatch('addStorageShiftData', {
          year: data.year,
          month: data.month,
          date: data.date,
          clockIn: data.clockIn,
          clockOut: data.clockOut,
        })
      }
    },

    computed: {
      calData() {
        const calData = []
        // 初日の曜日を取得
        const firstWeekDay = new Date(this.year, this.month - 1, 1).getDay()
        // 月の日数
        const lastDay = new Date(this.year, this.month, 0).getDate()
        // 日数カウント用
        let dayNum = 1
        // 週ごとのデータを作成して、calDateにpush
        while (dayNum <= lastDay) {
          const weekData = []          
          // 日曜～土曜の日付データを配列で作成
          for (let i = 0; i <= 6; i++) {
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
    }
}
</script>