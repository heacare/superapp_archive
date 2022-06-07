<template>
  <Head>
    <Title>Healer Dashboard</Title>
  </Head>
  <NuxtLayout name="default">
    <template #actions>
      <select
        v-model="days"
        class="px-3 py-2 rounded-md border border-neutral-300 bg-neutral-200 text-black hover:border-neutral-400 active:bg-neutral-300 mr-4"
        @change="update()"
      >
        <option value="3">3 days</option>
        <option value="7">7 days</option>
        <option value="10">10 days</option>
        <option value="14">14 days (SLOW)</option>
        <option value="21">21 days (SLOW)</option>
        <option value="30">30 days (SLOW)</option>
      </select>
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

const days = ref('7');

const utc = DateTime.utc();
const now = ref(utc.set({ second: Math.floor(utc.second / 10) * 10, millisecond: 0 }));

const end = computed(() => now.value);
const start = computed(() => end.value.minus({ days: parseInt(days.value) }));
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
