<!-- シフト表のmodule -->

<template>
  <div>
    <p>{{ formattedClockOut }}</p>
  </div>
</template>

<script>
export default {
  props: [
    "clockOut"
  ],

  computed: {
    formattedClockOut(){
      return this.$store.getters.formattedTime(this.clockOut);
    }
  }
}
</script>