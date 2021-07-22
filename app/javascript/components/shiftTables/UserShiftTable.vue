<!-- シフトを一覧表示するテーブル -->

<template>
  <div>
    <div v-if="shifts.length">
      
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(shift, index) in shifts" :key="shift.id" >
            <td><userName :key="shift.id" :userName="shift.user.name" ></userName></td>
            <td><userAge :key="shift.id" :userAge="shift.user.age" ></userAge></td>
            <td><userWorkStatus :key="shift.id" :userData="shift.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="shift.id" :clockIn="shift.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="shift.id" :clockOut="shift.clock_out" ></requestedClockOutTime></td>
            <div v-if="editPermission">
              <button @click="$emit('openModal', shift, index)">修正</button>
              <button @click="$emit('sendDeleteShiftId', shift.id, index)">削除</button>
            <div>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-else>
      <p>出勤予定の方がいません</p>
    </div>
</div>
</template>

<script>
  import UserName from "./modules/UserName.vue"
  import UserAge from "./modules/UserAge.vue"
  import UserWorkStatus from "./modules/UserWorkStatus.vue"
  import RequestedClockInTime from "./modules/RequestedClockInTime.vue"
  import RequestedClockOutTime from "./modules/RequestedClockOutTime.vue"

export default({
  components: {
    UserName,
    UserAge,
    UserWorkStatus,
    RequestedClockInTime,
    RequestedClockOutTime,
  },

  props: [
    'shifts',
    'editPermission'
  ]
})
</script>
