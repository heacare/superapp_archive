export const useSecret = (): string => {
  const route = useRoute();
  return Array.isArray(route.query.secret) ? route.query.secret[0] : route.query.secret;
};
