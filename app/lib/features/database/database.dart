import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:io' show Platform;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
import 'package:sqflite/sqflite.dart'
    show
        Database,
        ConflictAlgorithm,
        OpenDatabaseOptions,
        DatabaseFactory,
        databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show sqfliteFfiInit, databaseFactoryFfi;

export 'package:sqflite/sqflite.dart' show Database;

/// Open a database for HEA. Currently, FHIR data is stored separately from the
/// main application database
Future<Database> databaseOpen() async {
  DatabaseFactory factory = databaseFactory;
  String path = 'hea.db';
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    factory = databaseFactoryFfi;
    path = join((await getApplicationSupportDirectory()).path, path);
  }

  Database database = await factory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: _databaseOnCreate,
    ),
  );
  return database;
}

Future<void> _databaseOnCreate(Database database, int version) async {
  await database.execute(
    '''
CREATE TABLE kv (
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  PRIMARY KEY (key)
);''',
  );
}

/// Reads a value from the key-value database. Useful for JSON serializable
/// global objects
Future<dynamic> kvRead(Database database, String key) async {
  List<Map<String, Object?>> rows = await database.query(
    'kv',
    where: 'key = ?',
    whereArgs: [key],
  );
  if (rows.isEmpty) {
    return null;
  }
  Map<String, Object?> row = rows.first;
  return jsonDecode(row['value']! as String);
}

/// Writes a value to the key-value database. Useful for JSON serializable
/// global objects
Future<void> kvWrite(Database database, String key, dynamic value) async {
  await database.insert(
    'kv',
    {
      'key': key,
      'value': jsonEncode(value),
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
