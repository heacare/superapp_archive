<template>
  <div class="px-4 py-2">
    <div class="flex flex-col md:flex-row gap-4">
      <div class="flex-none md:w-72">
        <h2 class="text-xl font-bold">{{ user.id }}: {{ user.name }}</h2>
        <ul class="text-xs">
          <li v-if="user.trackingTools">
            Tracking tools: {{ user.trackingTools.join(', ') }} ({{ user.trackingToolModel }})
          </li>
          <li v-if="user.timeGoBed">(Pre) Go bed: {{ formatTimeOfDay(user.timeGoBed) }}</li>
          <li v-if="user.sleepLatency">(Pre) Latency: {{ formatMinutesDuration(user.sleepLatency) }}</li>
          <li v-if="user.minutesAsleep">(Pre) Asleep: {{ formatMinutesDuration(user.minutesAsleep) }}</li>
          <li v-if="user.timeOutBed">(Pre) Out bed: {{ formatTimeOfDay(user.timeOutBed) }}</li>
          <li v-if="user.sleepGoals">Goals: {{ user.sleepGoals.join(', ') }}</li>
          <li v-if="user.goalsSleepTime">(Goals) Sleep: {{ formatTimeOfDay(user.goalsSleepTime) }}</li>
          <li v-if="user.goalsWakeTime">(Goals) Wake: {{ formatTimeOfDay(user.goalsWakeTime) }}</li>
          <li>
            Group accept: <strong>{{ user.groupAccept ?? 'no' }}</strong>
          </li>
          <li v-if="user.continueAction">Continue action: {{ user.continueAction }}</li>
        </ul>
      </div>
      <div class="flex-1">
        <h3 class="font-semibold">Navigations</h3>
        <RangeBar :start-range="startRange" :end-range="endRange" :ranges="navigations" fill-color="bg-yellow-400" />
        <h3 class="font-semibold">App Activity</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="active"
          fill-color="bg-red-400"
          :dot="user.currentlyActive"
        />
        <h3 class="font-semibold">Check-in Sleep</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="sleeps"
          fill-color="bg-blue-600 from-blue-600"
          inner-fill-color="bg-purple-600 from-purple-600"
        />
        <h3 class="font-semibold">Autofill</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="autofills"
          fill-color="bg-blue-600 from-blue-600"
          inner-fill-color="bg-purple-600 from-purple-600"
        />
        <div class="flex gap-4 max-w-md">
          <div class="flex-1">
            <h3 class="font-semibold">Page</h3>
            <ProgressBar
              :max="user.pageTotal"
              :value="user.pageCount < 0 ? 0 : user.pageCount"
              fill-color="bg-neutral-300"
              :label="user.pageCount + ' of ' + user.pageTotal"
              :text="user.navigationsRecent"
            />
          </div>
          <div class="flex-1">
            <h3 class="font-semibold">Check-ins</h3>
            <ProgressBar
              :max="7"
              :value="user.checkInCount"
              fill-color="bg-neutral-300"
              :label="user.checkInCount + ' of ' + 7"
              :text="user.checkInCount + ''"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { DateTime } from 'luxon';

import { formatTimeOfDay, formatMinutesDuration } from '../types/datetime';
import type { User, UserPeriod, UserNestedPeriod } from '../composables/processLogs';

interface Props {
  user: User;
  period: Period;
}

interface Period {
  start: DateTime;
  end: DateTime;
}

const props = defineProps<Props>();

const startRange = computed(() => props.period.start.toMillis());
const endRange = computed(() => props.period.end.toMillis());

const periodToLabel = (p: Partial<UserPeriod | UserNestedPeriod>): string => {
  let string = '';
  if (p.start) {
    string += p.start.toLocaleString(DateTime.DATETIME_SHORT);
  }
  string += ' - ';
  if (p.end) {
    string += p.end.toLocaleString(DateTime.DATETIME_SHORT);
  }
  if ('innerStart' in p && (p.innerStart || p.innerEnd)) {
    string += '\n(';
    if (p.innerStart) {
      string += p.innerStart.toLocaleString(DateTime.DATETIME_SHORT);
    }
    string += ' - ';
    if (p.innerEnd) {
      string += p.innerEnd.toLocaleString(DateTime.DATETIME_SHORT);
    }
    string += ')';
  }
  return string;
};

const periodToMillis = (p: Partial<UserPeriod | UserNestedPeriod>) => ({
  start: p.start?.toMillis(),
  end: p.end?.toMillis(),
  innerStart: 'innerStart' in p ? p.innerStart?.toMillis() : undefined,
  innerEnd: 'innerEnd' in p ? p.innerEnd?.toMillis() : undefined,
  label: periodToLabel(p),
});

const navigations = computed(() =>
  props.user.navigations.map((e) => ({
    start: e.timestamp.toMillis(),
    end: e.timestamp.toMillis(),
    label: e.page || 'null',
  })),
);

const active = computed(() => props.user.active.map(periodToMillis));
const sleeps = computed(() => props.user.sleeps.map(periodToMillis));
const autofills = computed(() => props.user.autofills.map(periodToMillis));
</script>
