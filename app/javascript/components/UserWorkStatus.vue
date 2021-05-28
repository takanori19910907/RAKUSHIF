<template>
  <div>
    <ul>
    <li v-if="userData.work_status === 1">社員</li>
    <li v-else-if="userData.work_status === 2">パート</li>
    <li v-else-if="userData.work_status === 3">アルバイト</li>
    <li v-else-if="userData.work_status === 4">早朝アルバイト</li>
    <li v-if="userData.license === true">(資格者)</li>
    <li v-if="userData.rookie === true">New!!</li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    userData: Object 
  }
}
</script>

<style>

</style>