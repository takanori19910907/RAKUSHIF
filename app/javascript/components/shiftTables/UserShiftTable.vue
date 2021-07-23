<!-- シフトを一覧表示するテーブル -->

<template>
  <div>
    <div v-if="shifts.length">
      
      <table>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(shift) in shifts" :key="shift.id" >
            <td><userName :key="shift.id" :userName="shift.user.name" ></userName></td>
            <td><userWorkStatus :key="shift.id" :userData="shift.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="shift.id" :clockIn="shift.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="shift.id" :clockOut="shift.clock_out" ></requestedClockOutTime></td>
              <button v-if="editPermission" @click="$emit('editButtonPushed', shift)">修正</button>
              <button v-if="editPermission" @click="$emit('deleteButtonPushed', shift.id)">削除</button>
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
  import UserWorkStatus from "./modules/UserWorkStatus.vue"
  import RequestedClockInTime from "./modules/RequestedClockInTime.vue"
  import RequestedClockOutTime from "./modules/RequestedClockOutTime.vue"

export default({
  components: {
    UserName,
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
