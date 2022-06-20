import 'dart:io' show File;

import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:hea/features/database/database.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late Database database;
  setUp(() async {
    database = await databaseOpen();
  });
  tearDown(() async {
    await database.close();
    await File(database.path).delete();
  });

  group('kv', () {
    test('read missing', () async {
      expect(await kvRead(database, 'test'), null);
    });
    test('write string', () async {
      await kvWrite(database, 'test', 'string to write');
    });
    test('write read string', () async {
      await kvWrite(database, 'test', 'string to read');
      expect(await kvRead(database, 'test'), 'string to read');
    });
    test('write number', () async {
      await kvWrite(database, 'test', 0.1);
    });
    test('write read number', () async {
      await kvWrite(database, 'test', 1.0);
      expect(await kvRead(database, 'test'), 1.0);
    });
    test('write object', () async {
      await kvWrite(database, 'test', {
        'key1': 'value1',
        'key2': {
          'key2.1': 'value2.1',
          'key2.2': 3.14,
        },
      });
    });
    test('write read object', () async {
      await kvWrite(database, 'test', {
        'key1': 'value1',
        'key2': {
          'key2.1': 'value2.1',
          'key2.2': 3.14,
        },
      });
      expect(await kvRead(database, 'test'), {
        'key1': 'value1',
        'key2': {
          'key2.1': 'value2.1',
          'key2.2': 3.14,
        },
      });
    });
  });
}
