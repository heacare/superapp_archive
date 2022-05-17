<template>
  <div class="px-4 py-2">
    <h2>{{ user.name }}</h2>
    <h3>Navigations</h3>
    <ul>
      <li v-for="event in user.navigations" :key="event.timestamp">
        <code>
          {{ event.timestamp }}
          {{ event.page }}
        </code>
      </li>
    </ul>
    <h3>Active</h3>
    <ul>
      <li v-for="period in user.active" :key="period.timestampStart">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
    <h3>In Bed</h3>
    <ul>
      <li v-for="period in user.inBed" :key="period.timestamp">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
    <h3>Asleep</h3>
    <ul>
      <li v-for="period in user.awake" :key="period.timestamp">
        <code>
          {{ period.timestampStart }}
          {{ period.timestampEnd }}
        </code>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
const props = defineProps(['user']);
const user = toRef(props, 'user');
</script>
