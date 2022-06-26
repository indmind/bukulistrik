import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:get/get.dart';

/// This class is used for records calculation
class CalculationService extends GetxService {
  /// This variable stores average consumption
  double averageConsumption = 0.0;

  /// This method is used to calculate total consumption
  void calculate() {
    final records = Get.find<RecordService>().records;

    double totalConsumption = 0.0;

    for (int i = 0; i < records.length; i++) {
      if (i != 0) {
        final recordBefore = records[i - 1];
        final consumption = recordBefore.availableKwh - records[i].availableKwh;

        totalConsumption += consumption;
      }
    }

    averageConsumption = totalConsumption / (records.length - 1);
  }
}
