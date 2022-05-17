export const useSecret = (): string | null => {
  const { query } = useRoute();
  if (Array.isArray(query.secret)) {
    if (query.secret.length < 1) {
      return null;
    }
    return query.secret[0];
  }
  return query.secret;
};
