import 'package:elogbook/app.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  CredentialSaver.instance();
  await initializeDateFormatting('en_EN', null)
      .then((_) => runApp(const App()));
}
