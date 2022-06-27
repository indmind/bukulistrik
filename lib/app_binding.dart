import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:get/instance_manager.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MemoizationService>(MemoizationService());
    Get.lazyPut<RecordService>(() => RecordService());
    Get.lazyPut<CalculationService>(() => CalculationService());
  }
}
