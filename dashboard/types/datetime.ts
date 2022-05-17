import { DateTime, Duration, DurationLikeObject } from 'luxon';

export interface TimeOfDay {
  hour: number;
  minute: number;
}

export function formatTimeOfDay(timeOfDay: TimeOfDay): string {
  return DateTime.fromObject(timeOfDay).toLocaleString(DateTime.TIME_SIMPLE);
}

export function formatDuration(object: DurationLikeObject): string {
  return Duration.fromDurationLike(object).toHuman({ unitDisplay: 'short' });
}

export function formatMinutesDuration(minutes: number): string {
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return Duration.fromDurationLike({
    hours: h,
    minutes: m,
  }).toHuman({ unitDisplay: 'short' });
}
