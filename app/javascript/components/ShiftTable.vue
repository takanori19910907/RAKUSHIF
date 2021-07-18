<!-- シフトを一覧表示するテーブル -->

<template>
  <div>
    <div v-if="filteredShifts.length">
      
      <table v-if="admin">
        <tbody>
          <tr>
            <th>氏名</th>
            <th>年齢</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(shift) in filteredShifts" :key="shift.id" >
            <td><userName :key="shift.id" :userName="shift.user.name" ></userName></td>
            <td><userAge :key="item.id" :userAge="item.user.age" ></userAge></td>
            <td><userWorkStatus :key="shift.id" :userData="shift.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="shift.id" :clockIn="shift.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="shift.id" :clockOut="shift.clock_out" ></requestedClockOutTime></td>
          </tr>
        </tbody>
      </table>

      <table v-else>
        <tbody>
          <tr>
            <th>氏名</th>
            <th>勤務ステータス</th>
            <th>希望出勤時間</th>
            <th>希望退勤時間</th>
          </tr>
          <tr v-for="(shift) in filteredShifts" :key="shift.id" >
            <td><userName :key="shift.id" :userName="shift.user.name" ></userName></td>
            <td><userWorkStatus :key="shift.id" :userData="shift.user" ></userWorkStatus></td>
            <td><requestedClockInTime :key="shift.id" :clockIn="shift.clock_in" ></requestedClockInTime></td>
            <td><requestedClockOutTime :key="shift.id" :clockOut="shift.clock_out" ></requestedClockOutTime></td>
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
  import UserName from "./UserName.vue"
  import UserAge from "./UserAge.vue"
  import UserWorkStatus from "./UserWorkStatus.vue"
  import RequestedClockInTime from "./RequestedClockInTime.vue"
  import RequestedClockOutTime from "./RequestedClockOutTime.vue"

export default({
  components: {
    UserName,
    UserAge,
    UserWorkStatus,
    RequestedClockInTime,
    RequestedClockOutTime,
  },

  props: [
    'filteredShifts',
    'admin'
  ]
})
</script>
