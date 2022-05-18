<template>
  <div class="w-full h-6 relative rounded bg-neutral-100">
    <template v-for="bar in bars">
      <div
        v-if="bar.offset"
        :key="bar.offset"
        class="h-6 absolute rounded"
        :class="bar.class"
        :style="{ minWidth: '1px', width: bar.width + '%', left: bar.offset + '%' }"
        :title="bar.label"
      ></div>
      <div
        v-if="bar.innerWidth"
        :key="bar.innerOffset"
        class="h-4 top-1 absolute rounded"
        :class="bar.innerClass"
        :style="{ minWidth: '1px', width: bar.innerWidth + '%', left: bar.innerOffset + '%' }"
        :title="bar.label"
      ></div>
    </template>
    <div
      v-if="dot"
      class="h-4 w-4 top-1 right-1 absolute rounded-full"
      :class="[dotFillColor ?? 'bg-green-500']"
      :title="dotLabel"
    ></div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  ranges: Array<Range>;
  fillColor: string;
  startRange: number;
  endRange: number;
  dot?: boolean;
  dotFillColor?: string;
  dotLabel?: string;
  innerFillColor?: string;
}

const props = defineProps<Props>();

interface Range {
  start?: number;
  end?: number;
  innerStart?: number;
  innerEnd?: number;
  label?: string;
}

interface Bar {
  width?: number;
  offset?: number;
  class: string[];
  innerWidth?: number;
  innerOffset?: number;
  innerClass: string[];
  label?: string;
}

const bars = computed(() => {
  const totalWidth = props.endRange - props.startRange;
  return props.ranges.map<Bar>((range) => {
    let o: Bar = {
      label: range.label,
      class: props.fillColor.split(' '),
      innerClass: props.innerFillColor?.split(' ') ?? [],
    };
    if (range.start && range.end) {
      o.width = ((range.end - range.start) / totalWidth) * 100;
      o.offset = ((range.start - props.startRange) / totalWidth) * 100;
    }
    if (range.start && !range.end) {
      o.class = o.class.filter((c) => !c.startsWith('bg-'));
      o.class.push('bg-gradient-to-r');
      o.width = 0.03 * 100;
      o.offset = ((range.start - props.startRange) / totalWidth) * 100;
    }
    if (!range.start && range.end) {
      o.class = o.class.filter((c) => !c.startsWith('bg-'));
      o.class.push('bg-gradient-to-l');
      o.width = 0.03 * 100;
      o.offset = ((range.end - props.startRange) / totalWidth) * 100 - o.width;
    }
    if (range.innerStart && range.innerEnd) {
      o.innerWidth = ((range.innerEnd - range.innerStart) / totalWidth) * 100;
      o.innerOffset = ((range.innerStart - props.startRange) / totalWidth) * 100;
    }
    if (range.innerStart && !range.innerEnd) {
      o.innerClass = o.innerClass.filter((c) => !c.startsWith('bg-'));
      o.innerClass.push('bg-gradient-to-r');
      o.innerWidth = 0.03 * 100;
      o.innerOffset = ((range.innerStart - props.startRange) / totalWidth) * 100;
    }
    if (!range.innerStart && range.innerEnd) {
      o.innerClass = o.innerClass.filter((c) => !c.startsWith('bg-'));
      o.innerClass.push('bg-gradient-to-l');
      o.innerWidth = 0.03 * 100;
      o.innerOffset = ((range.innerEnd - props.startRange) / totalWidth) * 100 - o.innerWidth;
    }
    return o;
  });
});
</script>
