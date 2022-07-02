import 'package:bukulistrik/ui/pages/login_page/login_page_controller.dart';
import 'package:get/instance_manager.dart';

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginPageController>(() => LoginPageController());
  }
}
