<template>
  <div>
    <p>{{ formattedYear }}年{{ formattedMonth }}月{{ formattedDate }}日</p>
  </div>
</template>

<script>
export default {
  props: [
    'clockIn'
  ],

  computed: {
    formattedYear(){
      return this.$store.getters.formattedYear(this.clockIn);
    },

    formattedMonth(){
      return this.$store.getters.formattedMonth(this.clockIn);
    },

    formattedDate(){
      return this.$store.getters.formattedDate(this.clockIn);
    },
  }
}
</script>