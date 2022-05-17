<template>
  <div class="bar relative w-screen h-6" color="black">
    <div v-for="bar in bars" class="h-6 absolute" color="white"
    :style="{width: bar.width + '%', left: bar.offset + '%'}"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  ranges: Array<Range>
  fillColor: string
  noFillColor: string
  startRange: number
  endRange: number
}

const props = defineProps<Props>()

interface Range {
  start: number,
  end: number
}

interface Bar {
  width: number,
  offset: number
}

const bars = computed(() => {
  const totalWidth = props.endRange - props.startRange
  return props.ranges.map<Bar>((range) => <Bar>{
        width: ((range.end - range.start) / totalWidth) * 100,
        offset: ((range.start - props.startRange) / totalWidth) * 100
  }); 
})

</script>
