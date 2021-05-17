<!-- ログインユーザーのシフト希望(提出済み)一覧ページ -->

<template>
  <section id="about">
    <p>ユーザー名: {{ user.name }}さん</p>
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
          <td> {{ item.year }}年{{ item.month }}月{{ item.day }}日</td>
          <td> {{ item.clock_in }}</td>
          <td> {{ item.clock_out }}</td>
          <button @click="openModal(item, index)">修正</button>
          <button @click="removeShiftData(item.id)">×</button>
          <modal v-show="showModal" @close="closeModal" 
            :shiftIdx="shift.id"
            @sendRequestedShift="updateTableShiftData"
            >
            <p slot="title">提出済みの希望シフト編集</p>
            <p slot="subtitle">希望する時間を選んでください</p>
          </modal>
        </tr>
      </tbody>
    </table>
    </div>
    <div v-else>
      <p>シフト希望がありません</p>
      <p>シフト希望表ページからシフト希望を提出してください</p>

    </div>
  </section>
</template>

<script>
import axios from 'axios';
import Modal from 'components/Modal.vue'
export default {
  components: {
    Modal
  },
  data() {
    return {
      shifts: {},
      shift: {},
      dayNum: 0,
      showModal: false
    };
  },

  props: {
      user: {
        type: Object
      }
    },
    
  mounted () {
    axios.get('/api/v1/staff/requested_shifts/id', { params: { id: this.user.id }
})
  .then(response => (this.shifts = response.data))
  },

  methods: {
    // シフト提出用のモーダルを開く
    openModal: function(data) {
      this.shift = data
      this.showModal = true
    },
    
    // シフト提出用のモーダルを閉じる
    closeModal: function() {
      this.showModal = false
    },

    //modal-componentから帰ってきたシフト希望データを用いて希望シフトテーブルの値を更新する
    updateTableShiftData: function(...data) {
      axios.put('/api/v1/staff/requested_shifts/id', {
        shiftData: {
          clockIn: data[0],
          clockOut: data[1],
          id: data[2], 
        }
      })
      .then(response => (this.shifts = response.data))
      this.updateShifts();
    },
    //クリックで指定した希望データを希望シフトテーブルから削除する 
    removeShiftData: function(id) {
      if (window.confirm("このシフト希望を削除します、よろしいですか?")) {
        axios.delete('/api/v1/staff/requested_shifts/id', {data: {id: id} } )
        this.updateShifts();
      }
    },

    //controllerから再レンダリングされたときにテーブルのシフトデータを再描画する 
    updateShifts: function() {
      axios.get('/api/v1/staff/requested_shifts/id', { params: { id: this.user.id } })
      .then(response => (this.shifts = response.data))
    }
  }
};
</script>