import 'package:bukulistrik/app_binding.dart';
import 'package:bukulistrik/firebase_options.dart';
import 'package:bukulistrik/routes.dart';
import 'package:bukulistrik/ui/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Buku Listrik',
      initialBinding: AppBinding(),
      theme: kAppTheme,
      getPages: Routes.all,
      initialRoute: Routes.initialRoute,
    );
  }
}
