import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_tutorial.dart';
import 'package:get/instance_manager.dart';

class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomePageTutorial());
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
