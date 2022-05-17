<template>
  <Button @click="logs.refresh()">Refresh</Button>
  <UserDataElement v-for="user in users" :key="user.id" :user="user" :period="{ start, end }" />
</template>

<script setup lang="ts">
import { DateTime } from 'luxon';

const now = DateTime.utc().set({ hour: 0, minute: 0, second: 0, millisecond: 0 });
const start = now.minus({ days: 7 });
const end = now.plus({ days: 1 });

const secret = useSecret();
const logs = secret ? await useLogs(secret, start.toJSDate(), end.toJSDate()) : null;
const users = useProcessLogs(logs?.data ?? null);
</script>
