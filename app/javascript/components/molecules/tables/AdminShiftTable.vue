<!-- シフトを一覧表示するテーブル -->

<template>
  <div>
    <p>aaaaa</p>
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
          <tr v-for="(shift) in shifts" :key="shift.id" >
            <td><userName :key="shift.id" :userName="shift.user.name" ></userName></td>
            <td><userAge :key="shift.id" :userAge="shift.user.age" ></userAge></td>
            <td><userWorkStatus :key="shift.id" :userData="shift.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="shift.id" :clockIn="shift.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="shift.id" :clockOut="shift.clock_out" ></requestedClockOutTime></td>
            <button @click="$emit('editButtonPushed', shift)">修正</button>
            <button @click="$emit('deleteButtonPushed', shift.id)">削除</button>
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
  import UserName from "../../atoms/UserName.vue"
  import UserAge from "../../atoms/UserAge.vue"
  import UserWorkStatus from "../../atoms/UserWorkStatus.vue"
  import RequestedClockInTime from "components/atoms/RequestedClockInTime.vue"
  import RequestedClockOutTime from "components/atoms/RequestedClockOutTime.vue"

export default({
  components: {
    UserName,
    UserAge,
    UserWorkStatus,
    RequestedClockInTime,
    RequestedClockOutTime,
  },

  props: [
    'shifts'
  ]
})
</script>
