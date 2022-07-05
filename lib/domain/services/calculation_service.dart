import 'dart:async';
import 'dart:math';

import 'package:bukulistrik/common/logger.dart';
import 'package:bukulistrik/domain/models/calculation_meta.dart';
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

  final hourlyMeta = CalculationMeta();
  final dailyMeta = CalculationMeta();

  /// This variable stores computed records
  final RxList<ComputedRecord> computedRecords = <ComputedRecord>[].obs;

  final Rx<Duration> calculationTime = Duration.zero.obs;

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
    Logger.d("CalculationService.calculate");

    final records = availableRecords ?? await recordService.getCurrentRecords();
    final memoization = Get.find<MemoizationService>();
    final performance = Get.find<FirebasePerformance>();

    Trace calculationTrace = performance.newTrace('record-calculation-trace');
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

    hourlyMeta.reset();
    dailyMeta.reset();

    for (var record in tempComputedRecords) {
      hourlyMeta.calculate(
        consumption: record.hourlyUsage,
        cost: record.hourlyCost,
      );

      dailyMeta.calculate(
        consumption: record.dailyUsage,
        cost: record.dailyCost,
      );
    }

    // IMPORTANT: update computed records last, to make sure all data is updated
    computedRecords.value = tempComputedRecords;

    calculationTrace.putAttribute(
      'number_of_records',
      tempComputedRecords.length.toString(),
    );

    await calculationTrace.stop();
    stopwatch.stop();

    calculationTime.value = stopwatch.elapsed;

    Logger.d(
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

  double? minNull(double? a, double? b) {
    if (a == null && b != null) {
      return b;
    } else if (b == null && a != null) {
      return a;
    } else if (a != null && b != null) {
      return min(a, b);
    } else {
      return null;
    }
  }

  double? maxNull(double? a, double? b) {
    if (a == null && b != null) {
      return b;
    } else if (b == null && a != null) {
      return a;
    } else if (a != null && b != null) {
      return max(a, b);
    } else {
      return null;
    }
  }

  Color calculateColor(
    double kwh,
    double lowerBound,
    double midBound,
    double upperBound,
  ) {
    // get color based from averageConsumption
    // if kwh == averageConsumption, return white
    // if kwh > averageConsumption, return redder the more the difference is, max follows maxConsumption
    // if kwh < averageConsumption, return greener the more the difference is, max follows minConsumption

    double diff = midBound - kwh;

    if (diff.abs().toPrecision(2) < 0.1 ||
        midBound == lowerBound ||
        midBound == upperBound) {
      return Get.theme.colorScheme.secondary;
    }

    final belowAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 181, 242, 183),
        Get.theme.colorScheme.tertiary,
      ],
      rangeStart: min(midBound, lowerBound),
      rangeEnd: max(midBound, lowerBound),
    );

    final aboveAvgSpectrum = Rainbow(
      spectrum: [
        const Color.fromARGB(255, 255, 145, 185),
        Get.theme.colorScheme.error,
      ],
      rangeStart: min(midBound, upperBound),
      rangeEnd: max(midBound, upperBound),
    );

    if (kwh > midBound) {
      return aboveAvgSpectrum[kwh];
    } else {
      return belowAvgSpectrum[kwh];
    }
  }

  Color calculateDailyUsageColor(double usage) {
    return calculateColor(
      usage,
      dailyMeta.minConsumption ?? 0,
      dailyMeta.averageConsumption ?? 0,
      dailyMeta.maxConsumption ?? 0,
    );
  }

  Color calculateHourlyUsageColor(double usage) {
    return calculateColor(
      usage,
      hourlyMeta.minConsumption ?? 0,
      hourlyMeta.averageConsumption ?? 0,
      hourlyMeta.maxConsumption ?? 0,
    );
  }
}
