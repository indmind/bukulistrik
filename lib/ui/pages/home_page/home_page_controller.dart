import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final CalculationService _calculationService = Get.find<CalculationService>();

  RxString averageConsumption = '0'.obs;
  RxString calculationTime = ''.obs;
  RxList<ComputedRecord> computedRecords = <ComputedRecord>[].obs;

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

    computedRecords.value =
        _calculationService.computedRecords.reversed.toList();

    stopwatch.stop();

    calculationTime.value = 'Time elapsed: ${stopwatch.elapsed}';
  }
}
