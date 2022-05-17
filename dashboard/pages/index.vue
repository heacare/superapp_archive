<template>
  <p>{{ logs }}</p>
</template>

<script setup lang="ts">
import { DateTime } from 'luxon';

const secret = useSecret();
const start = DateTime.utc().minus({ days: 1 });
const end = DateTime.utc().plus({ years: 1 });
const logs = await useLogs(secret, start.toJSDate(), end.toJSDate());
console.debug(logs);
</script>
