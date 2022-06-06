import 'package:test/test.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import 'package:hea/old/services/health_service.dart';

void main() {
  group('meanTimeOfDay', () {
    test('mean of none', () {
      expect(meanTimeOfDay([]), null);
    });
    test('mean of two', () {
      expect(
          meanTimeOfDay([
            const TimeOfDay(hour: 23, minute: 59),
            const TimeOfDay(hour: 0, minute: 1),
          ]),
          const TimeOfDay(hour: 0, minute: 0));
    });
    test('mean of three', () {
      expect(
          meanTimeOfDay([
            const TimeOfDay(hour: 23, minute: 59),
            const TimeOfDay(hour: 0, minute: 1),
            const TimeOfDay(hour: 0, minute: 3),
          ]),
          const TimeOfDay(hour: 0, minute: 1));
    });
    test('mean of four', () {
      expect(
          meanTimeOfDay([
            const TimeOfDay(hour: 20, minute: 59),
            const TimeOfDay(hour: 1, minute: 1),
            const TimeOfDay(hour: 5, minute: 3),
          ]),
          const TimeOfDay(hour: 1, minute: 1));
    });
    test('opposite times', () {
      expect(
          meanTimeOfDay([
            const TimeOfDay(hour: 20, minute: 50),
            const TimeOfDay(hour: 8, minute: 50),
          ]),
          null);
    });
    test('slightly angled times', () {
      expect(
          meanTimeOfDay([
            const TimeOfDay(hour: 23, minute: 51),
            const TimeOfDay(hour: 11, minute: 50),
          ]),
          const TimeOfDay(hour: 5, minute: 50));
    });
  });
}
