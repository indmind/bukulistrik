import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_binding.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_view.dart';
import 'package:bukulistrik/ui/pages/debug/debug_page_view.dart';
import 'package:bukulistrik/ui/pages/detail_page/detail_page_binding.dart';
import 'package:bukulistrik/ui/pages/detail_page/detail_page_view.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_binding.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_view.dart';
import 'package:bukulistrik/ui/pages/login_page/login_page_binding.dart';
import 'package:bukulistrik/ui/pages/login_page/login_page_view.dart';
import 'package:get/route_manager.dart';

abstract class Routes {
  static final login = GetPage(
    name: '/login',
    page: () => const LoginPageView(),
    binding: LoginPageBinding(),
  );
  static final home = GetPage(
    name: '/home',
    page: () => const HomePageView(),
    binding: HomePageBinding(),
  );
  static final addRecord = GetPage(
    name: '/add-record',
    page: () => const AddRecordPageView(),
    binding: AddRecordPageBinding(),
  );
  static final debug = GetPage(
    name: '/debug',
    page: () => const DebugPageView(),
    binding: HomePageBinding(),
  );
  static final detail = GetPage(
    name: '/detail',
    page: () => const DetailPageView(),
    binding: DetailPageBinding(),
  );

  static List<GetPage> get all => [login, home, addRecord, detail, debug];
  static String get initialRoute => login.name;
}
