import 'package:intl/intl.dart' show Intl;
import 'package:intl/intl_standalone.dart' show findSystemLocale;
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

Future<void> intlInitialize() async {
  // Locale
  await findSystemLocale();
  initializeDateFormatting(Intl.systemLocale);
}
