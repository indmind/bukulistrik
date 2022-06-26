import 'package:bukulistrik/app_binding.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_binding.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_view.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_binding.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_view.dart';
import 'package:bukulistrik/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting();
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
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePageView(),
          binding: HomePageBinding(),
        ),
        GetPage(
          name: '/add-record',
          page: () => const AddRecordPageView(),
          binding: AddRecordPageBinding(),
        ),
      ],
      initialRoute: '/',
    );
  }
}
