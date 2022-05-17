export const useLogsRequest = (secret: string, start: string, end: string): RequestInfo | string => {
  const url = new URL('https://api.alpha.hea.care/api/logging/dump');
  url.searchParams.append('secret', secret);
  url.searchParams.append('start', start);
  url.searchParams.append('end', end);
  return url.toString();
};
