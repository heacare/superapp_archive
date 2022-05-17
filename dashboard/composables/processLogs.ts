import { Ref, unref } from 'vue';
import { DateTime, FixedOffsetZone } from 'luxon';
import type { Log } from '../types/api';

export interface User {
  id: number;
  name: string;
  timezone: string | null;
  navigations: UserNavigation[];
  active: UserActive[];
  inBed: UserSleep[];
  asleep: UserSleep[];
}

interface UserEvent {
  timestamp: DateTime;
}

interface UserPeriod {
  timestampStart: DateTime;
  timestampEnd: DateTime;
}

interface UserNavigation extends UserEvent {
  page: string;
}

type UserActive = UserPeriod;

interface UserSleep extends UserPeriod, UserEvent {}

interface TimeOfDay {
  hour: number;
  minute: number;
}

function processSleepTimeOfDay(reference: DateTime, timeOfDay: TimeOfDay): DateTime {
  // Treat a time-of-day as "last night"
  const day = reference.set({ hour: 0, minute: 0, second: 0, millisecond: 0 });
  if (timeOfDay.hour > 12) {
    return day.minus({ days: 1 }).set(timeOfDay);
  } else {
    return day.set(timeOfDay);
  }
}

interface LogCheckIn {
  time: string;
  'time-go-bed': TimeOfDay;
  'time-out-bed': TimeOfDay;
  'time-asleep-bed': TimeOfDay;
  'sleep-duration': number;
}

function validateCheckIn(checkIn: unknown): checkIn is LogCheckIn {
  const c = checkIn as LogCheckIn;
  if (!c.time || c['sleep-duration'] == null || !c['time-asleep-bed'] || !c['time-go-bed'] || !c['time-out-bed']) {
    return false;
  }
  return true;
}

function processLogs(logs: Log[]): Record<string, User> {
  const users: Record<string, User> = {};

  let lastActive: DateTime | null = DateTime.fromMillis(0);

  for (const log of logs) {
    const userId = log.user.id;
    const zone = FixedOffsetZone.parseSpecifier('UTC' + (log.tzClient ?? '+0'));
    let timestamp = DateTime.fromISO(log.timestamp, { zone });

    const user = (users[userId.toString(10)] ??= {
      id: userId,
      name: `User ${userId.toString()}`,
      timezone: log.tzClient,
      navigations: [],
      active: [],
      inBed: [],
      asleep: [],
    });

    if (log.key === 'navigate') {
      user.navigations.push({
        timestamp,
        page: JSON.parse(log.value) as string,
      });
    }
    if (log.key === 'state') {
      const state: boolean = JSON.parse(log.value) as boolean;
      if (state) {
        lastActive = timestamp;
      } else {
        if (lastActive === null) {
          // Repeated false
          continue;
        }
        user.active.push({
          timestampStart: lastActive,
          timestampEnd: timestamp,
        });
        lastActive = null;
      }
    }
    if (log.key === 'sleep-checkin') {
      const checkIns: unknown = JSON.parse(log.value);
      if (Array.isArray(checkIns)) {
        const checkIn: unknown = checkIns[0];
        if (checkIn && validateCheckIn(checkIn)) {
          timestamp = DateTime.fromISO(checkIn.time, { zone });
          user.inBed.push({
            timestamp,
            timestampStart: processSleepTimeOfDay(timestamp, checkIn['time-go-bed']),
            timestampEnd: processSleepTimeOfDay(timestamp, checkIn['time-out-bed']),
          });
          const asleepStart = processSleepTimeOfDay(timestamp, checkIn['time-asleep-bed']);
          const asleepEnd = asleepStart.plus({ minutes: checkIn['sleep-duration'] ?? 0 });
          user.asleep.push({
            timestamp,
            timestampStart: asleepStart,
            timestampEnd: asleepEnd,
          });
        }
      }
    }
  }
  return users;
}

export function useProcessLogs(logs: Log[] | Ref<Log[]> | null): Ref<Record<string, User>> {
  return computed(() => processLogs(unref(logs ?? [])));
}
