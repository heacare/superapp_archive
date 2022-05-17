<template>
  <UserDataElement />
  <Button @click="logs.refresh()">Refresh</Button>
  <p>{{ users }}</p>
</template>

<script setup lang="ts">
import { DateTime } from 'luxon';

const now = DateTime.utc().set({ hour: 0, minute: 0, second: 0, millisecond: 0 });
const start = now.minus({ days: 7 });
const end = now.plus({ years: 1 });

const secret = useSecret();
const logs = secret ? await useLogs(secret, start.toJSDate(), end.toJSDate()) : null;
const users = useProcessLogs(logs?.data ?? null);
</script>
