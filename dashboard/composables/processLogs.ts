import { Ref, unref } from 'vue';
import { DateTime, Zone, FixedOffsetZone } from 'luxon';
import type { Log } from '../types/api';
import type { TimeOfDay } from '../types/datetime';
import { pages } from './genPages_sleep';

export interface User {
  id: number;
  name: string;
  zone: Zone;
  navigations: UserNavigation[];
  navigationsRecent?: string;
  active: UserActive[];
  sleeps: UserSleep[];
  autofills: UserAutofill[];
  resets: UserReset[];

  person?: string[];
  trackingTools?: string[];
  trackingToolModel?: string;
  timeGoBed?: TimeOfDay;
  timeOutBed?: TimeOfDay;
  minutesAsleep?: number;
  sleepLatency?: number;
  sleepGoals?: string[];
  timeToSleep?: string[];
  doingBeforeBed?: string[];
  goalsSleepTime?: TimeOfDay;
  goalsWakeTime?: TimeOfDay;
  includedActivities?: string[];
  optInGroup?: string;
  groupAccept?: string;
  continueAction?: string;
  checkInDay: number;
  checkInTotal: number;

  // Derived
  sleepEfficiency: number;
  checkInCount: number;
  currentlyActive: boolean;
  pageCount: number;
  pageTotal: number;
}

export interface UserEvent {
  timestamp: DateTime;
}

export interface UserPeriod {
  start: DateTime;
  end: DateTime;
}

export interface UserNestedPeriod extends UserPeriod {
  innerStart: DateTime;
  innerEnd: DateTime;
}

type UserAutofill = Partial<UserNestedPeriod>;

interface UserNavigation extends UserEvent {
  page: string | null;
}

interface UserReset extends UserEvent {
  description: string;
}

type UserActive = UserPeriod;

interface UserSleep extends UserEvent, UserNestedPeriod {}

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

function expectDateTime(data: unknown, zone: Zone): DateTime | undefined {
  if (!data || typeof data != 'string') {
    return undefined;
  }
  return DateTime.fromISO(data, { zone });
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

function pageTotal(): number {
  return pages.length;
}
function pageCount(name: string): number {
  return pages.indexOf(name);
}

function processLogs(logs: Log[]): Record<string, User> {
  const users: Record<string, User> = {};

  let lastActive: DateTime | null = DateTime.fromMillis(0);

  for (const log of logs) {
    const userId = log.user.id;
    const userName = log.user.name;
    const zone = FixedOffsetZone.parseSpecifier('UTC' + (log.tzClient ?? '+0'));
    let timestamp = DateTime.fromISO(log.timestamp, { zone });

    const user = (users[userId.toString(10)] ??= {
      id: userId,
      name: userName,
      zone: zone,
      navigations: [],
      active: [],
      sleeps: [],
      autofills: [],
      resets: [],
      // Derived
      sleepEfficiency: 0,
      checkInCount: 0,
      checkInDay: 0,
      checkInTotal: 7,
      currentlyActive: false,
      pageCount: 0,
      pageTotal: pageTotal(),
    });

    if (log.key === 'navigate') {
      const page = JSON.parse(log.value) as string;
      user.navigations.push({
        timestamp,
        page,
      });
      if (page != 'home' && page != null) {
        user.navigationsRecent = page;
        user.pageCount = pageCount(page);
      }
    }
    if (log.key === 'state') {
      const state: boolean = JSON.parse(log.value) as boolean;
      user.currentlyActive = state;
      if (state) {
        lastActive = timestamp;
      } else {
        if (lastActive === null) {
          // Repeated false
          continue;
        }
        user.active.push({
          start: lastActive,
          end: timestamp,
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
        user.person = expectStringArray(d['person']);
        user.trackingTools = expectStringArray(d['tracking-tool']);
        user.trackingToolModel = d['tracking-tool-model'] as string | undefined;
        user.timeGoBed = expectTimeOfDay(d['time-go-bed']);
        user.timeOutBed = expectTimeOfDay(d['time-out-bed']);
        user.minutesAsleep = d['minutes-asleep'] as number | undefined;
        user.sleepLatency = d['sleep-latency'] as number | undefined;
        user.sleepGoals = expectStringArray(d['sleep-goals']);
        user.timeToSleep = expectStringArray(d['time-to-sleep']);
        user.doingBeforeBed = expectStringArray(d['doing-before-bed']);
        user.goalsSleepTime = expectTimeOfDay(d['goals-sleep-time']);
        user.goalsWakeTime = expectTimeOfDay(d['goals-wake-time']);
        user.includedActivities = expectStringArray(d['included-activities']);
        user.optInGroup = expectOneOrNone(d['opt-in-group']);
        user.groupAccept = expectOneOrNone(d['group-accept']);
        user.continueAction = expectOneOrNone(d['continue-action']);
      }
      user.sleepEfficiency = 0; // TODO
    }
    if (log.key === 'sleep-autofill') {
      // {"in-bed":"2022-05-18T01:45:00.000","asleep":"2022-05-18T02:07:00.000","awake":null,"out-bed":"2022-05-18T09:02:00.000"}
      const data: unknown = JSON.parse(log.value);
      if (data === null) {
        continue;
      }
      if (typeof data === 'object') {
        const d = data as Record<string, unknown>;
        const autofill = {
          start: expectDateTime(d['in-bed'], zone),
          innerStart: expectDateTime(d['asleep'], zone),
          innerEnd: expectDateTime(d['awake'], zone),
          end: expectDateTime(d['out-bed'], zone),
        };
        user.autofills = user.autofills.filter(
          (o) =>
            o.start?.toSeconds() !== autofill.start?.toSeconds() && o.end?.toSeconds() !== autofill.end?.toSeconds(),
        );
        user.autofills.push(autofill);
      }
    }
    if (log.key === 'sleep-checkin-progress') {
      const data: unknown = JSON.parse(log.value);
      if (data === null) {
        continue;
      }
      if (typeof data === 'object') {
        const d = data as Record<string, unknown>;
        user.checkInDay = d['day'] as number;
        user.checkInTotal = d['total'] as number;
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
          const asleepStart = processSleepTimeOfDay(timestamp, checkIn['time-asleep-bed']);
          const asleepEnd = asleepStart.plus({ minutes: checkIn['sleep-duration'] ?? 0 });
          user.sleeps.push({
            timestamp,
            start: processSleepTimeOfDay(timestamp, checkIn['time-go-bed']),
            end: processSleepTimeOfDay(timestamp, checkIn['time-out-bed']),
            innerStart: asleepStart,
            innerEnd: asleepEnd,
          });
        }
      }
    }
  }
  return users;
}

export function useProcessLogs(logs: Log[] | Ref<Log[]>): Ref<Record<string, User>> {
  return computed(() => processLogs(unref(logs) ?? []));
}
