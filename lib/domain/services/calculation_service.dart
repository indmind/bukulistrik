import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rainbow_color/rainbow_color.dart';

/// This class is used for records calculation
class CalculationService extends GetxService {
  /// This variable stores average consumption
  double averageConsumption = 0.0;
  double minConsumption = 0.0;
  double maxConsumption = 0.0;

  /// This variable stores computed records
  final List<ComputedRecord> computedRecords = [];

  /// This method is used to calculate total consumption
  void calculate() {
    final records = Get.find<RecordService>().records;
    final memoization = Get.find<MemoizationService>();

    double totalConsumption = 0.0;

    // IMPORTANT: order by date
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    computedRecords.clear();

    for (int i = 0; i < records.length; i++) {
      // copy each record to computedRecord
      _copyToComputedRecord(records[i], memoization, i == 0);

      // calculate usage
      if (i != 0) {
        final recordBefore = records[i - 1];
        final consumption = recordBefore.availableKwh - records[i].availableKwh;

        totalConsumption += consumption;
        minConsumption =
            consumption < minConsumption ? consumption : minConsumption;
        maxConsumption =
            consumption > maxConsumption ? consumption : maxConsumption;
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

  Color calculateColor(double kwh) {
    // get color based from averageConsumption
    // if kwh == averageConsumption, return white
    // if kwh > averageConsumption, return redder the more the difference is, max follows maxConsumption
    // if kwh < averageConsumption, return greener the more the difference is, max follows minConsumption

    final belowAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 181, 242, 183),
        Get.theme.colorScheme.tertiary,
      ],
      rangeStart: averageConsumption,
      rangeEnd: minConsumption,
    );

    final aboveAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 255, 145, 185),
        Get.theme.colorScheme.error,
      ],
      rangeStart: averageConsumption,
      rangeEnd: maxConsumption,
    );

    double diff = calculateDiff(kwh);

    if (diff.abs().toPrecision(2) >= 0 && diff.abs().toPrecision(2) < 0.1) {
      return const Color.fromARGB(255, 101, 207, 246);
    } else if (kwh > averageConsumption) {
      return aboveAvgSpectrum[kwh];
    } else {
      return belowAvgSpectrum[kwh];
    }
  }

  /// Calculate the difference from averageConsumption
  double calculateDiff(double kwh) {
    return averageConsumption - kwh;
  }
}
