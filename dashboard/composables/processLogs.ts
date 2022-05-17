import { Ref, unref } from 'vue';
import { DateTime, FixedOffsetZone } from 'luxon';
import type { Log } from '../types/api';
import type { TimeOfDay } from '../types/datetime';

export interface User {
  id: number;
  name: string;
  timezone: string | null;
  navigations: UserNavigation[];
  navigationsRecent?: string;
  active: UserActive[];
  inBed: UserSleep[];
  asleep: UserSleep[];
  resets: UserReset[];
  checkInCount: number;

  trackingTools?: string[];
  trackingToolModel?: string;
  timeGoBed?: TimeOfDay;
  timeOutBed?: TimeOfDay;
  minutesAsleep?: number;
  sleepLatency?: number;
  sleepGoals?: string[];
  goalsSleepTime?: TimeOfDay;
  goalsWakeTime?: TimeOfDay;
  optInGroup?: string;
  groupAccept?: string;
  continueAction?: string;
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

interface UserReset extends UserEvent {
  description: string;
}

type UserActive = UserPeriod;

interface UserSleep extends UserPeriod, UserEvent {}

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

function expectTimeOfDay(data: unknown): TimeOfDay | undefined {
  if (!data || typeof data != 'object') {
    return undefined;
  }
  if ('hour' in data && 'minute' in data) {
    return data as TimeOfDay;
  }
  return undefined;
}

function expectStringArray(data: unknown): string[] | undefined {
  if (Array.isArray(data)) {
    // Note: If any array element is not a string, this will be incorrect
    return data as string[];
  }
  return undefined;
}

function expectOneOrNone(data: unknown): string | undefined {
  if (Array.isArray(data)) {
    if (data.length >= 1 && typeof data[0] === 'string') {
      return data[0];
    }
  }
  return undefined;
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
      resets: [],
      checkInCount: 0,
    });

    if (log.key === 'navigate') {
      const page = JSON.parse(log.value) as string;
      user.navigations.push({
        timestamp,
        page,
      });
      user.navigationsRecent = page;
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
    if (log.key === 'sleep') {
      const data: unknown = JSON.parse(log.value);
      if (data === null) {
        continue;
      }
      if (typeof data === 'object' && 'reset' in data) {
        user.resets.push({
          timestamp,
          description: 'Sleep content',
        });
      }
      if (typeof data === 'object') {
        const d = data as Record<string, unknown>;
        // Extract key information
        user.trackingTools = expectStringArray(d['tracking-tool']);
        user.trackingToolModel = d['tracking-tool-model'] as string | undefined;
        user.timeGoBed = expectTimeOfDay(d['time-go-bed']);
        user.timeOutBed = expectTimeOfDay(d['time-out-bed']);
        user.minutesAsleep = d['minutes-asleep'] as number | undefined;
        user.sleepLatency = d['sleep-latency'] as number | undefined;
        user.sleepGoals = expectStringArray(d['sleep-goals']);
        user.goalsSleepTime = expectTimeOfDay(d['goals-sleep-time']);
        user.goalsWakeTime = expectTimeOfDay(d['goals-wake-time']);
        user.optInGroup = expectOneOrNone(d['opt-in-group']);
        user.groupAccept = expectOneOrNone(d['group-accept']);
        user.continueAction = expectOneOrNone(d['continue-action']);
      }
    }
    if (log.key === 'sleep-checkin') {
      const data: unknown = JSON.parse(log.value);
      if (data === null) {
        continue;
      }
      if (typeof data === 'object' && 'reset' in data) {
        user.resets.push({
          timestamp,
          description: 'Check-ins',
        });
      }
      if (Array.isArray(data)) {
        user.checkInCount = data.length;
        const checkIn: unknown = data[0];
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
