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
          <td><requestedDate :key="item.id" :clockIn ="item.clock_in" ></requestedDate></td>
          <td><requestedClockInTime :key="item.id" :clockIn="item.clock_in" ></requestedClockInTime></td>
          <td><requestedClockOutTime :key="item.id" :clockOut="item.clock_out" ></requestedClockOutTime></td>
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
        shifts: [],
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
      axios.get('/api/v1/staff/requested_shifts')
    .then(response => (this.shifts = response.data))
    },

    methods: {
      // シフト提出用のモーダルを開く
      openModal(data) {
        this.shift = data
        this.shiftIdx = data.id
        this.showModal = true
      },
      
      // シフト提出用のモーダルを閉じる
      closeModal() {
        this.showModal = false
      },

      //modal-componentから帰ってきたシフト希望データを用いて希望シフトテーブルの値を更新する
      updateTableShiftData(data) {
        this.showModal = false
        axios.patch('/api/v1/staff/requested_shifts/id', {
          shiftData: {
            clockIn: data.clockIn,
            clockOut: data.clockOut,
            id: data.shiftIdx, 
          }
        })
        this.getShift(data.shiftIdx);
      },
      
      //クリックで指定した希望データを希望シフトテーブルから削除する 
      removeShiftData: function(id, index) {
        if (window.confirm("このシフト希望を削除します、よろしいですか?")) {
          this.shifts.splice(index, 1)
          axios.delete('/api/v1/staff/requested_shifts/id', {data: {id: id} } )
        }
      },

      getShift(shiftIdx) {
      axios
        .get('/api/v1/staff/requested_shifts/id', { params: { id: shiftIdx }})
        .then(response => {
        this.shiftData = response.data.shift
        })
      }
    }
};
</script>