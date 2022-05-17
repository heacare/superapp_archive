export interface Log {
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
