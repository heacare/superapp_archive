<template>
  <div class="w-full h-8 relative overflow-hidden">
    <template v-for="mark in marks" :key="mark.offset">
      <div
        v-if="mark.type === 'day'"
        class="h-3 absolute bottom-0 rounded w-0.5 bg-neutral-400"
        :style="{ left: mark.offset + '%' }"
      >
        <span class="absolute -top-5 w-24 -left-12 text-center text-xs">{{ mark.label }}</span>
      </div>
      <div
        v-if="mark.type === 'partial-day'"
        class="h-2 absolute bottom-0 rounded w-px bg-neutral-400"
        :style="{ left: mark.offset + '%' }"
      >
        <span class="absolute -top-4 w-12 -left-6 text-center text-xs">{{ mark.label }}</span>
      </div>
      <div
        v-if="mark.type === 'hour'"
        class="h-1 absolute bottom-0 rounded w-px bg-neutral-400"
        :style="{ left: mark.offset + '%' }"
      ></div>
    </template>
    <div class="h-8 px-2 py-1 absolute left-0 bg-white/60">{{ zone.name }}</div>
  </div>
</template>

<script setup lang="ts">
import type { DateTime, Zone } from 'luxon';

interface Props {
  start: DateTime;
  end: DateTime;
  zone: Zone;
}

const props = defineProps<Props>();

interface Mark {
  offset: number;
  type: 'day' | 'partial-day' | 'hour';
  label?: string;
}

const marks = computed<Mark[]>(() => {
  let marks: Mark[] = [];

  const startM = props.start.toMillis();
  const endM = props.end.toMillis();
  const totalM = endM - startM;

  const start = props.start.setZone(props.zone).set({ hour: 0, minute: 0, second: 0, millisecond: 0 });

  let t = start;
  while (t.toMillis() < endM) {
    marks.push({
      offset: ((t.toMillis() - startM) / totalM) * 100,
      type: 'day',
      label: t.toLocaleString({ month: 'numeric', day: 'numeric' }),
    });
    t = t.plus({ day: 1 });
  }

  t = start;
  while (t.toMillis() < endM) {
    marks.push({
      offset: ((t.toMillis() - startM) / totalM) * 100,
      type: 'partial-day',
      label: t.hour == 0 ? '' : t.hour.toString(),
    });
    t = t.plus({ hour: 24 / 4 });
  }

  t = start;
  while (t.toMillis() < endM) {
    marks.push({
      offset: ((t.toMillis() - startM) / totalM) * 100,
      type: 'hour',
    });
    t = t.plus({ hour: 1 });
  }

  return marks;
});
</script>
