<template>
  <div class="px-4 py-2">
    <div class="flex flex-col md:flex-row gap-4">
      <div class="flex-none md:w-72">
        <h2 class="text-xl font-bold">{{ user.id }}: {{ user.name }}</h2>
        <ul class="text-xs list-disc pl-3">
          <li>
            <strong>Group accept</strong>:
            <span :class="user.groupAccept?.toLowerCase() === 'yes' ? 'text-green-700' : 'text-red-500'">{{
              user.groupAccept ?? 'no'
            }}</span>
          </li>
          <li v-if="user.continueAction"><strong>Continue action</strong>: {{ user.continueAction }}</li>
          <li v-if="user.person"><strong>Person</strong>: {{ user.person.join(', ') }}</li>
          <li v-if="user.otherHealthAspects">
            <strong>Other aspects</strong>: {{ user.otherHealthAspects.join(', ') }}
          </li>
          <li v-if="user.trackingTools"><strong>Tracking tools</strong>: {{ trackingTools }}</li>
          <li v-if="user.timeGoBed"><strong>(Pre) Go bed</strong>: {{ formatTimeOfDay(user.timeGoBed) }}</li>
          <li v-if="user.sleepLatency">
            <strong>(Pre) Latency</strong>: {{ formatMinutesDuration(user.sleepLatency) }}
          </li>
          <li v-if="user.minutesAsleep">
            <strong>(Pre) Asleep</strong>: {{ formatMinutesDuration(user.minutesAsleep) }}
          </li>
          <li v-if="user.timeOutBed"><strong>(Pre) Out bed</strong>: {{ formatTimeOfDay(user.timeOutBed) }}</li>
          <li v-if="user.sleepGoals"><strong>Goals</strong>: {{ user.sleepGoals.join(', ') }}</li>
          <li v-if="user.goalsSleepTime"><strong>(Goals) Sleep</strong>: {{ formatTimeOfDay(user.goalsSleepTime) }}</li>
          <li v-if="user.goalsWakeTime"><strong>(Goals) Wake</strong>: {{ formatTimeOfDay(user.goalsWakeTime) }}</li>
        </ul>
        <details>
          <summary class="text-xs my-1">More details</summary>
          <ul class="text-xs list-disc pl-3">
            <li v-if="user.timeToSleep"><strong>(Pre) When it's time</strong>: {{ user.timeToSleep.join(', ') }}</li>
            <li v-if="user.doingBeforeBed">
              <strong>(Pre) Do before bed</strong>: {{ user.doingBeforeBed.join(', ') }}
            </li>
            <li v-if="user.includedActivities">
              <strong>(Goals) Wind down activities</strong>: {{ user.includedActivities.join(', ') }}
            </li>
          </ul>
        </details>
      </div>
      <div class="flex-1">
        <TimeRulerBar :start="period.start" :end="period.end" :zone="user.zone" />
        <h3 class="font-semibold">Navigations</h3>
        <RangeBar :start-range="startRange" :end-range="endRange" :ranges="navigations" fill-color="bg-yellow-500" />
        <h3 class="font-semibold">App Activity</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="active"
          fill-color="bg-red-500"
          :dot="user.currentlyActive"
        />
        <h3 class="font-semibold">Check-in Sleep</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="sleeps"
          fill-color="bg-violet-400 from-violet-400"
          inner-fill-color="bg-violet-800 from-violet-800"
          :marks="sleepsMarks"
          marks-fill-color="bg-red-500"
        />
        <h3 class="font-semibold">Autofill</h3>
        <RangeBar
          :start-range="startRange"
          :end-range="endRange"
          :ranges="autofills"
          fill-color="bg-violet-400 from-violet-400"
          inner-fill-color="bg-violet-800 from-violet-800"
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
              :max="user.checkInTotal"
              :value="user.checkInCount"
              fill-color="bg-neutral-300"
              :label="checkInLabel"
              :text="checkInText"
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

interface SimpleRange {
  start: number;
  end: number;
}
const sleepsMarks = computed(() => {
  const marks: SimpleRange[] = [];
  if (!props.user.goalsSleepTime || !props.user.goalsWakeTime) {
    return marks;
  }

  const startM = props.period.start.toMillis();
  const endM = props.period.end.toMillis();

  const start = props.period.start.setZone(props.user.zone).set({ hour: 0, minute: 0, second: 0, millisecond: 0 });

  let t = start;
  while (t.toMillis() < endM) {
    let start = t.set(props.user.goalsSleepTime);
    const end = t.set(props.user.goalsWakeTime);
    if (start.toMillis() > end.toMillis()) {
      start = start.minus({ day: 1 });
    }
    if (end.toMillis() > startM) {
      marks.push({
        start: start.toMillis(),
        end: end.toMillis(),
      });
    }
    t = t.plus({ day: 1 });
  }

  return marks;
});
const autofills = computed(() => props.user.autofills.map(periodToMillis));

const checkInText = computed(() => `${props.user.checkInCount} of ${props.user.checkInTotal}`);
const checkInLabel = computed(
  () => `${props.user.checkInCount} of ${props.user.checkInTotal}\nDay: ${props.user.checkInDay}`,
);
const trackingTools = computed(
  () => `${props.user.trackingTools?.join(', ') ?? ''} (${props.user.trackingToolModel ?? ''})`,
);
</script>
