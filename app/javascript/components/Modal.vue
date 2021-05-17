<!-- addshift(dispatch)でselectした要素、propsで受け取った日付情報をstoreに送るmodal -->

<template>
  <div id="overlay">
    <div id="modal">
      <slot name="title"></slot>
      <slot name="subtitle"></slot>
      <form @submit.prevent="sendRequestedShift">
      <select v-model="selected1">
        <option disabled value="">希望出勤時間</option>
        <option v-for="clockIn in clockIns" v-bind:val="clockIn.time" v-bind:key="clockIn.id">
          {{ clockIn.time }}
        </option>
      </select>
      <span>〜</span>
      <select v-model="selected2">
        <option disabled value="">希望退勤時間</option>
      <option v-for="clockOut in clockOuts" v-bind:val="clockOut.time" v-bind:key="clockOut.id">
          {{ clockOut.time }}
        </option>
      </select>
        <p>出勤:{{ selected1 }}</p>
        <p>退勤:{{ selected2 }}</p>
        <button  type="submit" @click.self="$emit('close')" >完了</button>
      </form>
      <button @click="$emit('close')">閉じる</button>
    </div> 
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      selected1: "",
      selected2: "",
      clockIns: [
        {id: 1, time: "9:00" },
        {id: 2, time: "13:00" },
        {id: 3, time: "17:00" }
      ],
      clockOuts: [
        {id: 1, time: "13:30" },
        {id: 2, time: "17:30" },
        {id: 3, time: "21:00" }
      ],
    }
  },
  props: [
    'shift',
    'year',
    'month',
    'day',
    'shiftIdx',
    'title'
  ],
  
  methods: {
    sendRequestedShift: function() {
      this.$emit('sendRequestedShift', 
                      this.selected1,
                      this.selected2,
                      this.shiftIdx,
                      this.year,
                      this.month,
                      this.day,
                      )
      this.selected1= ""
      this.selected2= ""
    }
  }
}
</script>