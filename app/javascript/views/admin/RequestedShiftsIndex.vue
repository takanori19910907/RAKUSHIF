<!-- 確定シフト作成用ページ -->

<template>
  <div>
    <h2>シフト新規作成</h2>
    <calendar @sendDate="checkShifts"/>
    <div v-if="this.month && this.date">
      <h2>{{ this.month }}月{{ this.date }}日のシフト希望一覧</h2>
    </div>
    <p></p>
    <div v-if="filteredShiftData.length">
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(item, index) in filteredShiftData" :key="item.id" >
            <td><userName :key="item.id" :userName="item.user.name" ></userName></td>
            <td><userAge :key="item.id" :userAge="item.user.age" ></userAge></td>
            <td><userWorkStatus :key="item.id" :userData="item.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="item.id" :clockIn="item.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="item.id" :clockOut="item.clock_out" ></requestedClockOutTime></td>
            <button @click="openModal(item, index)">修正</button>
            <button @click="deleteItemInShiftData(item.id)">×</button>
          </tr>
        </tbody>
      </table>
      <fixedShiftsModal v-if="showModal" @close="closeModal" 
        :year="year"
        :month="month"
        :date="date"
        :shift="selectedShift"
        :shiftIdx="selectedShift.id"
        :arrayIdx="arrayIdx"
        @sendUpdateData="updateItemInShiftData"
        >
      </fixedShiftsModal>
      <p>出勤者を決定したら『シフト確定』を押してください</p>
      <button @click="createFixedShift">シフト確定</button>
    </div>
    <div v-else-if="this.date === null ">
      <p>カレンダーをクリックすると、日付ごとにスタッフの希望シフトが表示されます</p>
      <p>各日付でシフトを修正/削除し出勤者を決めてください</p>
    </div>
    <div v-else>
      <p>出勤予定の方がいません</p>
      <p>シフトの人員補充をお願いします</p>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  import dayjs from 'dayjs';
  import Calendar from '../../components/FixedShiftsCalendar.vue'
  import FixedShiftsModal from '../../components/FixedShiftsModal.vue'
  import UserName from '../../components/UserName.vue'
  import UserAge from '../../components/UserAge.vue'
  import UserWorkStatus from '../../components/UserWorkStatus.vue'
  import RequestedClockInTime from '../../components/RequestedClockInTime.vue'
  import RequestedClockOutTime from '../../components/RequestedClockOutTime.vue'
  export default {
    components: {
      Calendar,
      FixedShiftsModal,
      UserName,
      UserAge,
      UserWorkStatus,
      RequestedClockInTime,
      RequestedClockOutTime
    },

    data() {
      return{
        shiftData: [],
        userData: {},
        selectedShift: {},
        year: null,
        month: null,
        date: null,
        showModal: false,
        arrayIdx: 0
      }
    },

    created() {
      axios
        .get('/api/v1/admin/requested_shifts')
        .then(response => {
        this.shiftData = response.data.shifts
        this.userData = response.data.users
        })
    },

    computed: {
      filteredShiftData() {
        return this.$store.getters.filteredShiftData({
          date: {
            year: this.year,
            month: this.month,
            date: this.date
            },
            user: this.userData     
        })
      },
    },

    methods: {
      checkShifts(value) {
        this.year = value.year
        this.month = value.month
        this.date = value.date
        const shiftDates = this.$store.state.shifts.beforeCreateData.map((shift) => {
          return dayjs(shift.clock_in).date();
        });
        if (!shiftDates.includes(value.date)) {
          const selectedShifts = this.shiftData.filter((constShift) => {
            const checkedDate = dayjs(constShift.clock_in).date();
            return checkedDate === value.date;
            })
            for( var i = 0; i < selectedShifts.length; i++ ){
              this.$store.dispatch('fixedShifts', selectedShifts[i])
            }
        }
      },

      openModal(value, index) {
        this.arrayIdx = index
        this.selectedShift = value
        this.showModal = true
      },
      
      closeModal() {
        this.showModal = false
      },
      
      createFixedShift() {
        this.$store.state.shifts.beforeCreateData.splice(0, 1) 
        if (window.confirm("確定シフトを作成します、よろしいですか?")) {
        axios.post('/api/v1/admin/fixed_shifts', {shifts: this.$store.state.shifts.beforeCreateData })
        this.$router.push('/admin/fixed_shifts')
        }
      },

      updateItemInShiftData(value) {
        this.showModal = false
        this.$store.dispatch('updateItemInShiftData', value )
      },

      deleteItemInShiftData(itemID) {
        this.$store.dispatch("destroyShift", itemID)
      }
  }
}
</script>