import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class Logger {
  static final FirebaseCrashlytics _crashlytics = Get.find();

  // ignore: constant_identifier_names
  static const String _TAG = 'Logger';

  static void d(String message) {
    _crashlytics.log(message);
    debugPrint('$_TAG: $message');
  }

  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _crashlytics.log(message);
    _crashlytics.recordError(error, stackTrace);
    debugPrint('$_TAG: $message');
  }
}
