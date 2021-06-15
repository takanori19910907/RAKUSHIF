<template>
  <div>
    <p>{{ formattedClockIn }}</p>
  </div>
</template>

<script>
export default {
  props: [
    'clockIn'
  ],

  computed: {
    formattedClockIn(){
    return this.$store.getters.formattedTime(this.clockIn);
    },
  }
}
</script>