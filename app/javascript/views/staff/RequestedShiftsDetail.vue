<!-- ログインユーザーのシフト希望(提出済み)一覧ページ -->

<template>
  <section id="about">
    <h3>提出済みのシフト一覧</h3>
    <div v-if="shifts.length">
    <hr>
    <table>
      <tbody>
        <tr>
          <th>希望日</th>
          <th>希望出勤時間</th>
          <th>希望退勤時間</th>
        </tr>
        <tr v-for="(item, index) in shifts" :key="item.id">
          <td> {{ formattedYear(item.clock_in) }}年{{ formattedMonth(item.clock_in) }}月{{ formattedDay(item.clock_in) }}日</td>
          <td> {{ formattedclockInHour(item.clock_in) }}時 {{ formattedclockInMinute(item.clock_in) }}分</td>
          <td> {{ formattedclockOutHour(item.clock_out) }}時 {{ formattedclockOutMinute(item.clock_out) }}分</td>
          <button @click="openModal(item)">修正</button>
          <button @click="removeShiftData(item.id, index)">×</button>
        </tr>
      </tbody>
    </table>
    <modal v-if="showModal" 
                @close="closeModal" 
                @sendRequestedShift="updateTableShiftData"
                :shift="shift"
                :year="year"
                :month="month"
                :date="date"
                :shiftIdx="shiftIdx"
                >
    </modal>
    </div>
    <div v-else>
      <p>シフト希望がありません</p>
      <p>シフト希望表ページからシフト希望を提出してください</p>
    </div>
  </section>
</template>

<script>
import axios from 'axios';
import dayjs from 'dayjs';
import Modal from 'components/Modal.vue'
export default {
  components: {
    Modal
  },

  
  data() {
    return {
      shifts: {},
      shift: {},
      year: 0,
      month: 0,
      date: 0,
      shiftIdx: 0,
      showModal: false
    };
  },

  props: [
    'userID'
  ],
    
  created() {
    axios.get('/api/v1/staff/requested_shifts/id', { params: { id: this.userID }
})
  .then(response => (this.shifts = response.data))
  },

  computed: {
    formattedYear: function () {
      return function(value) {
        return dayjs(value).year();
      }
    },

    formattedMonth: function () {
      return function(value) {
        return dayjs(value).month() + 1 ;
      }
    },

    formattedDay: function () {
      return function(value) {
        return dayjs(value).date();
      }
    },

    formattedclockInHour: function() {
      return function(value) {
        return dayjs(value).hour();
      }
    },

    formattedclockInMinute: function() {
      return function(value) {
        return dayjs(value).minute();
      }
    },

    formattedclockOutHour: function() {
      return function(value) {
        return dayjs(value).hour();
      }
    },

    formattedclockOutMinute: function() {
      return function(value) {
        return dayjs(value).minute();
      }
    }
  },

  methods: {
    // シフト提出用のモーダルを開く
    openModal: function(data) {
      this.shift = data
      this.shiftIdx = data.id
      this.formattedDate(data.clock_in)
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    //modal-componentから帰ってきたシフト希望データを用いて希望シフトテーブルの値を更新する
    updateTableShiftData: function(data) {
      this.showModal = false
      axios.patch('/api/v1/staff/requested_shifts/id', {
        shiftData: {
          clockIn: data.clockIn,
          clockOut: data.clockOut,
          id: data.shiftIdx, 
        }
      })
      .then(response => {
        
        (this.shifts = response.data)
        })
      console.log(this.shifts)
    },
    
    //クリックで指定した希望データを希望シフトテーブルから削除する 
    removeShiftData: function(id, index) {
      if (window.confirm("このシフト希望を削除します、よろしいですか?")) {
        this.shifts.splice(index, 1)
        axios.delete('/api/v1/staff/requested_shifts/id', {data: {id: id} } )
      }
    },

    formattedDate: function (data) {
        this.year = dayjs(data).year()
        this.month = dayjs(data).month() + 1
        this.date = dayjs(data).date()
    },

    //controllerから再レンダリングされたときにテーブルのシフトデータを再描画する 
    // updateShifts: function() {
    //   axios.get('/api/v1/staff/requested_shifts/id', { params: { id: this.userID } })
    //   .then(response => (this.shifts = response.data))
    // },
  }
};
</script>