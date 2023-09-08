import 'package:elogbook/app.dart';
import 'package:elogbook/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_EN', null)
      .then((_) => runApp(const App()));
}
