import 'package:test/test.dart';

import 'package:hea/models/log.dart';

void main() {
  test('zero', () {
    expect(dateOffset(Duration.zero), "+00:00");
  });
  test('one', () {
    expect(dateOffset(const Duration(hours: 1)), "+01:00");
  });
  test('negative one', () {
    expect(dateOffset(Duration.zero - const Duration(hours: 1)), "-01:00");
  });
  test('one hour 25 minutes', () {
    expect(dateOffset(const Duration(hours: 1, minutes: 25)), "+01:25");
  });
  test('negative one hour 25 minutes', () {
    expect(dateOffset(Duration.zero - const Duration(hours: 1, minutes: 25)),
        "-01:25");
  });
}
