<template>
  <div class="px-4 py-2">
    <h2 class="text-xl">{{ user.name }}</h2>
    <div class="md:flex">
      <ul class="flex-none w-72">
        <li>Check-ins: {{ user.checkInCount }}</li>
        <li v-if="user.navigationsRecent">Page: {{ user.navigationsRecent }}</li>
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
        <li v-if="user.groupAccept">Group accept: {{ user.groupAccept }}</li>
        <li v-if="user.continueAction">Continue action: {{ user.continueAction }}</li>
      </ul>
      <div class="flex-1">
        <h3>Navigations</h3>
        <RangeBar :start-range="startRange" :end-range="endRange" :ranges="navigations" fill-color="bg-yellow-400" />
        <h3>App Activity</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="active"
          fill-color="bg-red-400"
          :dot="user.currentlyActive"
        />
        <h3>Check-in Sleep</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="sleeps"
          fill-color="bg-blue-600 from-blue-600"
          inner-fill-color="bg-purple-600 from-purple-600"
        />
        <h3>Autofill</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="autofills"
          fill-color="bg-blue-600 from-blue-600"
          inner-fill-color="bg-purple-600 from-purple-600"
        />
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
