<template>
  <div class="px-4 py-2">
    <h2>{{ user.name }}</h2>
    <h3>Navigations</h3>
    <ul>
      <li v-for="event in user.navigations" :key="event.timestamp.toString()">
        <code>
          {{ event.timestamp }}
          {{ event.page }}
        </code>
      </li>
    </ul>
    <h3>Active</h3>
    <ul>
      <li v-for="period in user.active" :key="period.timestampStart.toString()">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
    <h3>In Bed</h3>
    <ul>
      <li v-for="period in user.inBed" :key="period.timestamp.toString()">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
    <h3>Asleep</h3>
    <ul>
      <li v-for="period in user.asleep" :key="period.timestamp.toString()">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
    <ul>
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
  </div>
</template>

<script setup lang="ts">
import { formatTimeOfDay, formatMinutesDuration } from '../types/datetime';
import type { User } from '../composables/processLogs';

const props = defineProps<{ user: User }>();
const user = toRef(props, 'user');
</script>
