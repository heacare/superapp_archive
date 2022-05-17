interface LogData {
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
  return await useFetch<LogData[]>(url.toString());
};
