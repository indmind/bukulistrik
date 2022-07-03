import 'dart:async';
import 'dart:math';

import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/house_service.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rainbow_color/rainbow_color.dart';

/// This class is used for records calculation
class CalculationService extends GetxService {
  final HouseService houseService = Get.find();
  final RecordService recordService = Get.find();

  /// This variable stores average consumption
  double averageConsumption = 0.0;
  double minConsumption = 0.0;
  double maxConsumption = 0.0;

  /// This variable stores computed records
  final RxList<ComputedRecord> computedRecords = <ComputedRecord>[].obs;

  StreamSubscription<List<Record>>? _recordSubscription;

  @override
  void onInit() {
    super.onInit();

    ever(houseService.activeHouse, (String? houseId) async {
      _recordSubscription?.cancel();
      _recordSubscription = recordService.recordsStream.listen((records) {
        calculate(records);
      });
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();

  //   // initial call
  //   calculate();
  // }

  /// This method is used to calculate total consumption
  Future<void> calculate([List<Record>? availableRecords]) async {
    debugPrint("CalculationService.calculate");

    final records = availableRecords ?? await recordService.getCurrentRecords();
    final memoization = Get.find<MemoizationService>();

    double totalConsumption = 0.0;

    Trace calculationTrace =
        FirebasePerformance.instance.newTrace('record-calculation-trace');
    await calculationTrace.start();
    Stopwatch stopwatch = Stopwatch()..start();

    // IMPORTANT: order by date
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    memoization.clear();

    // copy to temp list to avoid listener being called multiple times
    final tempComputedRecords = <ComputedRecord>[];

    for (int i = 0; i < records.length; i++) {
      // copy each record to computedRecord
      _copyComputedTo(tempComputedRecords, records[i], memoization, i == 0);
    }

    totalConsumption = tempComputedRecords.fold<double>(0, (value, element) {
      final consumption = element.dailyUsage;

      minConsumption =
          consumption < minConsumption ? consumption : minConsumption;
      maxConsumption =
          consumption > maxConsumption ? consumption : maxConsumption;

      return value + consumption;
    });

    if (tempComputedRecords.isNotEmpty) {
      averageConsumption = totalConsumption / tempComputedRecords.length;
    } else {
      averageConsumption = 0;
    }

    // IMPORTANT: update computed records last, to make sure all data is updated
    computedRecords.value = tempComputedRecords;

    calculationTrace.putAttribute(
      'number_of_records',
      tempComputedRecords.length.toString(),
    );

    await calculationTrace.stop();
    stopwatch.stop();
    debugPrint(
      "CalculationService.calculate took ${stopwatch.elapsedMilliseconds} ms (${computedRecords.length} records)",
    );
  }

  void _copyComputedTo(
      List<ComputedRecord> list, Record record, MemoizationService memoization,
      [bool isFirst = false]) {
    if (isFirst) {
      list.add(ComputedRecord(
        record: record,
        memoizationService: memoization,
      ));
    } else {
      list.add(ComputedRecord(
        record: record,
        prevRecord: list.last,
        memoizationService: memoization,
      ));
    }

    // OPTIMIZATION: eager load memoization
    list.last.initialize();
  }

  Color calculateColor(double kwh) {
    // get color based from averageConsumption
    // if kwh == averageConsumption, return white
    // if kwh > averageConsumption, return redder the more the difference is, max follows maxConsumption
    // if kwh < averageConsumption, return greener the more the difference is, max follows minConsumption

    double diff = calculateDiff(kwh);

    if (diff.abs().toPrecision(2) < 0.1 ||
        averageConsumption == minConsumption ||
        averageConsumption == maxConsumption) {
      return Get.theme.colorScheme.secondary;
    }

    final belowAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 181, 242, 183),
        Get.theme.colorScheme.tertiary,
      ],
      rangeStart: min(averageConsumption, minConsumption),
      rangeEnd: max(averageConsumption, minConsumption),
    );

    final aboveAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 255, 145, 185),
        Get.theme.colorScheme.error,
      ],
      rangeStart: min(averageConsumption, maxConsumption),
      rangeEnd: max(averageConsumption, maxConsumption),
    );

    if (kwh > averageConsumption) {
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
