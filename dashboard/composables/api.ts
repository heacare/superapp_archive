import type { Log } from '../types/api';

export const useLogs = async (secret: string, start: Date, end: Date) => {
  const url = new URL('https://api.alpha.hea.care/api/logging/dump');
  url.searchParams.append('secret', secret);
  url.searchParams.append('start', start.toISOString());
  url.searchParams.append('end', end.toISOString());
  return await useFetch<Log[]>(url.toString());
};
