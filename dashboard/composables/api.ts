interface Log {
  id: number;
  key: string;
  timestamp: string;
  tsClient: string | null;
  tzClient: string | null;
  user: {
    id: number;
  };
  value: string;
}

export const useLogs = async (secret: string, start: Date, end: Date) => {
  const url = new URL('https://api.alpha.hea.care/api/logging/dump');
  url.searchParams.append('secret', secret);
  url.searchParams.append('start', start.toISOString());
  url.searchParams.append('end', end.toISOString());
  const { data: logs } = await useFetch<Log[]>(url.toString());
  if (logs.value === null) {
    return null;
  }
  return logs.value.map((log: Log) => ({
    ...log,
    timestamp: new Date(log.timestamp),
    tsClient: new Date(log.tsClient),
  }));
};
