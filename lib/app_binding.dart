import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:bukulistrik/ui/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // firebase
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance);

    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance
        ..settings = const Settings(
          persistenceEnabled: true,
        ),
    );

    // google sign in
    Get.lazyPut<GoogleSignIn>(() => GoogleSignIn());

    // global controllers
    Get.put<AuthController>(AuthController());

    Get.put<MemoizationService>(MemoizationService());
    Get.lazyPut<RecordService>(() => RecordService());
    Get.lazyPut<CalculationService>(() => CalculationService());
  }
}
