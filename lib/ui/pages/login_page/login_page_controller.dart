import 'package:bukulistrik/ui/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  void signInWithGoogle() {
    _authController.signInWithGoogle();
  }
}
