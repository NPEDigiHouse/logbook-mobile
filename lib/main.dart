import 'package:elogbook/app.dart';
import 'package:elogbook/injection.dart' as di;
import 'package:flutter/material.dart';

Future<void> main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}
