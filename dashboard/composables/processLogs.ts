import { Ref, unref } from 'vue';
import { DateTime, FixedOffsetZone } from 'luxon';
import type { Log } from '../types/api';

export interface User {
  id: number;
  name: string;
  timezone: string;
  navigations: UserNavigation[];
  inBed: UserSleep[];
  asleep: UserSleep[];
}

interface UserEvent {
	timestamp: DateTime
}

interface UserPeriod {
	timestampStart: DateTime
	timestampEnd: DateTime
}

interface UserNavigation extends UserEvent {
	page: string;
}

interface UserSleep extends UserPeriod, UserEvent {
}

interface TimeOfDay {
	hour: number
	minute: number
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

function processLogs(logs: Log[]): Record<string, User> {
  let users: Record<string, User> = {};
  for (const log of logs) {
    const userId = log.user.id;
	let zone = FixedOffsetZone.parseSpecifier("UTC" + log.tzClient ?? "+0");
	let timestamp = DateTime.fromISO(log.timestamp, { zone });

	const user = users[userId.toString(10)] ??= {
		id: userId,
		name: `User ${userId.toString()}`,
		timezone: log.tzClient!,
		navigations: [],
		inBed: [],
		asleep: [],
	};

    if (log.key === 'navigate') {
		user.navigations.push({
			timestamp,
			page: log.value
		});
    } if (log.key === "sleep-checkin") {
		const checkins = JSON.parse(log.value);
		const checkin = checkins[0];
		if (checkin) {
			timestamp = DateTime.fromISO(checkin.time, { zone});
			user.inBed.push({
				timestamp,
				timestampStart: processSleepTimeOfDay(timestamp, checkin["time-go-bed"]),
				timestampEnd: processSleepTimeOfDay(timestamp, checkin["time-out-bed"]),
			});
			const asleepStart = processSleepTimeOfDay(timestamp, checkin["time-asleep-bed"]);
			const asleepEnd = asleepStart.plus({ minutes: checkin["sleep-duration"] ?? 0 });
			user.asleep.push({
				timestamp,
				timestampStart: asleepStart,
				timestampEnd: asleepEnd,
			});
		}
	}
  }
  return users;
}

export function useProcessLogs(logs: Log[] | Ref<Log[]> | null): Ref<Record<string, User>> {
  return computed(() => processLogs(unref(logs ?? [])));
}
