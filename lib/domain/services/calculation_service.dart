import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:get/get.dart';

/// This class is used for records calculation
class CalculationService extends GetxService {
  /// This variable stores average consumption
  double averageConsumption = 0.0;

  /// This variable stores computed records
  final List<ComputedRecord> computedRecords = [];

  /// This method is used to calculate total consumption
  void calculate() {
    final records = Get.find<RecordService>().records;
    final memoization = Get.find<MemoizationService>();

    double totalConsumption = 0.0;

    for (int i = 0; i < records.length; i++) {}

    computedRecords.clear();

    for (int i = 0; i < records.length; i++) {
      // copy each record to computedRecord
      _copyToComputedRecord(records[i], memoization, i == 0);

      // calculate usage
      if (i != 0) {
        final recordBefore = records[i - 1];
        final consumption = recordBefore.availableKwh - records[i].availableKwh;

        totalConsumption += consumption;
      }
    }

    averageConsumption = totalConsumption / (records.length - 1);
  }

  void _copyToComputedRecord(Record record, MemoizationService memoization,
      [bool isFirst = false]) {
    if (isFirst) {
      computedRecords.add(ComputedRecord(
        record: record,
        memoizationService: memoization,
      ));
    } else {
      computedRecords.add(ComputedRecord(
        record: record,
        prevRecord: computedRecords.last,
        memoizationService: memoization,
      ));
    }

    // OPTIMIZATION: eager load memoization
    computedRecords.last.initialize();
  }
}
