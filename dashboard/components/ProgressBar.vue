<template>
  <div class="w-full h-6 relative rounded bg-neutral-100 overflow-hidden" :title="label">
    <div class="h-6 rounded" :class="fillColor" :style="{ width: width + '%' }">{{ text }}</div>
    <div v-if="overflow" class="h-6 top-0 right-0 absolute rounded w-6 bg-gradient-to-l from-neutral-400"></div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  max: number;
  value: number;
  fillColor: string;
  label?: string;
  text?: string;
}

const props = defineProps<Props>();

const width = computed(() => (props.value / props.max) * 100);
const overflow = computed(() => width.value > 100);
</script>
