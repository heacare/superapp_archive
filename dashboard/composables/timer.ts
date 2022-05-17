import { ref, onMounted, onUnmounted } from 'vue';

interface UseTimerOptions {
  seconds: number;
  repeat?: boolean;
}

function useTimerFunc<T>(
  set: (handler: () => void, timeout: number) => T,
  clear: (timer: T) => void,
  call: () => void,
  timeout: number,
) {
  let timer: T | null = null;
  onMounted(() => {
    timer = set(call, timeout);
  });
  onUnmounted(() => {
    clear(timer as T);
  });
}

export function useTimer({ seconds, repeat }: UseTimerOptions) {
  const time = ref(new Date().getTime());
  const set = repeat ? setInterval : setTimeout;
  const clear = repeat ? clearInterval : clearTimeout;
  useTimerFunc(
    set,
    clear,
    () => {
      time.value = new Date().getTime();
    },
    seconds * 1000,
  );
  return time;
}
