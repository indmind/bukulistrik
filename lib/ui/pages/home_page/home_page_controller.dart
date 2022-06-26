import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final CalculationService _calculationService = Get.find<CalculationService>();

  RxString averageConsumption = '0'.obs;
  RxString calculationTime = ''.obs;
  final List<ComputedRecord> computedRecords = [];

  @override
  void onInit() {
    super.onInit();
    calculate();
  }

  void calculate() async {
    Stopwatch stopwatch = Stopwatch()..start();
    _calculationService.calculate();

    averageConsumption.value =
        _calculationService.averageConsumption.toString();

    final records = Get.find<RecordService>().records;
    final memoization = Get.find<MemoizationService>();

    computedRecords.clear();

    for (int i = 0; i < records.length; i++) {
      if (i == 0) {
        computedRecords.add(ComputedRecord(
          record: records[i],
          memoizationService: memoization,
        ));
      } else {
        computedRecords.add(ComputedRecord(
          record: records[i],
          prevRecord: computedRecords.last,
          memoizationService: memoization,
        ));
      }

      // OPTIMIZATION: eager load memoization
      computedRecords.last.initialize();
    }

    stopwatch.stop();

    calculationTime.value = 'Time elapsed: ${stopwatch.elapsed}';
  }

  // void on
}
