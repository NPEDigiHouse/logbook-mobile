import 'package:core/configure/notification_configure.dart';
import 'package:data/utils/api_header.dart';
import 'package:elogbook/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationUtils.configureFirebaseMessaging();
  CredentialSaver.instance();
  await initializeDateFormatting('en_EN', null)
      .then((_) => runApp(const App()));
}
