<template>
  <div class="w-full h-6 relative rounded bg-neutral-100">
    <div
      v-for="bar in bars"
      :key="bar.offset"
      class="h-6 absolute rounded"
      :class="[fillColor]"
      :style="{ minWidth: '1px', width: bar.width + '%', left: bar.offset + '%' }"
      :title="bar.label"
    ></div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  ranges: Array<Range>;
  fillColor: string;
  startRange: number;
  endRange: number;
}

const props = defineProps<Props>();

interface Range {
  start: number;
  end: number;
  label?: string;
}

interface Bar {
  width: number;
  offset: number;
  label?: string;
}

const bars = computed(() => {
  const totalWidth = props.endRange - props.startRange;
  return props.ranges.map<Bar>(
    (range) =>
      <Bar>{
        width: ((range.end - range.start) / totalWidth) * 100,
        offset: ((range.start - props.startRange) / totalWidth) * 100,
        label: range.label,
      },
  );
});
</script>
