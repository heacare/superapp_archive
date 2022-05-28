import { DateTime, Duration, DurationLikeObject } from 'luxon';

export interface TimeOfDay {
  hour: number;
  minute: number;
}

export function formatTimeOfDay(timeOfDay: TimeOfDay): string {
  if (!formatTimeOfDay) {
    return 'undefined';
  }
  return DateTime.fromObject(timeOfDay).toLocaleString(DateTime.TIME_SIMPLE);
}

export function formatDuration(object: DurationLikeObject): string {
  if (!object) {
    return 'undefined';
  }
  return Duration.fromDurationLike(object).toHuman({ unitDisplay: 'short' });
}

export function formatMinutesDuration(minutes: number): string {
  if (minutes === undefined) {
    return 'undefined';
  }
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return Duration.fromDurationLike({
    hours: h,
    minutes: m,
  }).toHuman({ unitDisplay: 'short' });
}
