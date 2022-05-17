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

const now = ref(DateTime.utc());
const end = computed(() => now.value.set({ millisecond: 0 }));
const start = computed(() => end.value.minus({ days: 8 }));
const endQuery = computed(() => now.value.set({ millisecond: 0 }).plus({ minutes: 1 }));

const secret = useSecret();
const reqLogs = computed(() => useLogsRequest(secret ?? '', start.value.toISO(), endQuery.value.toISO()));
const { data: logs, error } = await useFetch<Log[]>(reqLogs);
const users = useProcessLogs(logs);

function update() {
  now.value = DateTime.utc();
}

watch(useTimer({ seconds: 60, repeat: true }), update);
</script>
