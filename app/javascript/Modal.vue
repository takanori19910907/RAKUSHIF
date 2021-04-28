<template>
  <div id="overlay">
    <div id="modal">
      <p>{{ dayNum }}</p>
    <button @click="$emit('close')">閉じる</button>
    </div>
  </div>
</template>

<script>
export default {
  props: [
    'dayNum'
  ]
}
</script>