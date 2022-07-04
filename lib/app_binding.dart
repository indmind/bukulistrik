import 'package:bukulistrik/data/house_repository.dart';
import 'package:bukulistrik/data/record_repository.dart';
import 'package:bukulistrik/domain/services/ad_service.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:bukulistrik/domain/services/house_service.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:bukulistrik/ui/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // firebase
    Get.lazyPut<FirebaseAuth>(
      () => FirebaseAuth.instance,
      fenix: true,
    );
    Get.lazyPut<FirebaseAnalytics>(
      () => FirebaseAnalytics.instance,
      fenix: true,
    );
    Get.lazyPut<FirebaseCrashlytics>(
      () => FirebaseCrashlytics.instance,
      fenix: true,
    );
    Get.lazyPut<FirebasePerformance>(
      () => FirebasePerformance.instance,
      fenix: true,
    );

    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance
        ..settings = const Settings(
          persistenceEnabled: true,
        ),
      fenix: true,
    );

    // repositories
    Get.lazyPut<HouseRepository>(() => HouseRepository(Get.find()));
    Get.lazyPut<RecordRepository>(() => RecordRepository(Get.find()));

    // google sign in
    Get.lazyPut<GoogleSignIn>(() => GoogleSignIn());

    // global controllers
    Get.put<AuthController>(AuthController());

    // add
    Get.put<AdService>(AdService());

    Get.put<MemoizationService>(MemoizationService());
    Get.lazyPut<HouseService>(() => HouseService());
    Get.lazyPut<RecordService>(() => RecordService());
    Get.lazyPut<CalculationService>(() => CalculationService());
  }
}
