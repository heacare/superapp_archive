<template>
  <NuxtLayout name="default">
    <template #actions>
      <Button @click="update()">Refresh</Button>
    </template>
    <div v-if="secret && !error">
      <UserDataElement v-for="user in users" :key="user.id" :user="user" :period="{ start, end }" />
    </div>
    <form v-else class="px-4 py-2" method="get">
      <pre><code>{{ error }}</code></pre>
      <Input class="mr-2" type="text" name="secret" placeholder="secret" />
      <Button type="submit">Go</Button>
    </form>
  </NuxtLayout>
</template>

<script setup lang="ts">
import { DateTime } from 'luxon';

import type { Log } from '../types/api';

definePageMeta({
  layout: false,
});

const utc = DateTime.utc();
const now = ref(utc.set({ second: Math.floor(utc.second / 10) * 10, millisecond: 0 }));

const end = computed(() => now.value);
const start = computed(() => end.value.minus({ days: 8 }));
const endQuery = computed(() => now.value.plus({ minutes: 1 }));

const secret = useSecret();
const reqLogs = computed(() => useLogsRequest(secret ?? '', start.value.toISO(), endQuery.value.toISO()));
const { data: logs, error } = await useFetch<Log[]>(reqLogs, {
  // Because the deduplication is done by hashing reqLogs, and the hash
  // function does not handle ref() objects, we need to set our own key.
  key: 'logs',
});
const users = useProcessLogs(logs);

function update() {
  now.value = DateTime.utc().set({ millisecond: 0 });
}

watch(useTimer({ seconds: 60, repeat: true }), update);
</script>
