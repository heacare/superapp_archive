import 'dart:convert' show jsonEncode;

import 'package:http/http.dart' as http;

import '../../system/log.dart';
import '../account/account.dart';

final Uri _logUnauthUrl =
    Uri.parse('https://api.alpha.hea.care/api/logging/unauth');

class _Log {
  _Log(this.key, this.ts, this.value, this.accountId);
  _Log.fromDynamic(this.key, this.ts, final dynamic value, this.accountId)
      : value = jsonEncode(value);

  final String key;
  final DateTime ts;
  final String value;
  final String accountId;

  Map<String, dynamic> toJson() => {
        'key': key,
        'ts': ts.toIso8601String(),
        'tz': dateOffset(ts.timeZoneOffset),
        'value': value,
        'accountId': accountId,
      };
}

String _twoDigits(final int n) {
  if (n >= 10) {
    return '$n';
  }
  return '0$n';
}

String dateOffset(final Duration offset) {
  String sign = '+';
  Duration o = offset;
  if (o < Duration.zero) {
    o = o.abs();
    sign = '-';
  }
  final int minutes = o.inMinutes.remainder(Duration.minutesPerHour);
  final int hours = o.inMinutes ~/ Duration.minutesPerHour;
  final String m = _twoDigits(minutes);
  final String h = _twoDigits(hours);
  return '$sign$h:$m';
}

Account? _account;

void interimDataCollectionSetup(final Account account) {
  _account = account;
}

Future<void> collectSimpleKv(final String key, final dynamic value) async {
  final String accountId = _account?.metadata.id ?? '';
  final Map<String, dynamic> body =
      _Log.fromDynamic(key, DateTime.now(), value, accountId).toJson();
  final http.Response resp = await http.post(
    _logUnauthUrl,
    body: jsonEncode(body),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8'
    },
  );
  if (resp.statusCode == 201) {
    return;
  } else {
    logW('Failure in createLog: ${resp.statusCode}');
  }
}
