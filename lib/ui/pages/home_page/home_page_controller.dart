import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartRange { week, month, year, all }

class HomePageController extends GetxController {
  final CalculationService calculationService = Get.find<CalculationService>();

  late final ScrollController scrollController;
  ChartSeriesController? chartController;

  RxBool showBackToTopButton = false.obs;
  RxDouble lifetimeAverageConsumption = 0.0.obs;
  Rx<ComputedRecord?> lastComputedRecord = Rx(null);
  RxString calculationTime = ''.obs;
  RxList<ComputedRecord> computedRecords = <ComputedRecord>[].obs;

  Rx<ChartRange> chartRage = ChartRange.week.obs;

  List<ComputedRecord> weeklyUsage = [];
  List<ComputedRecord> monthlyUsage = [];
  List<ComputedRecord> yearlyUsage = [];
  List<ComputedRecord> allUsage = [];

  @override
  void onInit() {
    super.onInit();
    calculate();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= 400) {
          showBackToTopButton.value = true;
        } else {
          showBackToTopButton.value = false;
        }
      });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: 500.milliseconds,
      curve: Curves.linear,
    );
  }

  List<ComputedRecord> get displayedData {
    late final List<ComputedRecord> dataSource;

    switch (chartRage.value) {
      case ChartRange.week:
        dataSource = weeklyUsage;
        break;
      case ChartRange.month:
        dataSource = monthlyUsage;
        break;
      case ChartRange.year:
        dataSource = yearlyUsage;
        break;
      case ChartRange.all:
        dataSource = allUsage;
        break;
    }

    return dataSource;
  }

  double get displayedAverageConsumption {
    switch (chartRage.value) {
      case ChartRange.week:
        return weeklyAverageConsumption;
      case ChartRange.month:
        return monthlyAverageConsumption;
      case ChartRange.year:
        return yearlyAverageConsumption;
      case ChartRange.all:
        return lifetimeAverageConsumption.value;
    }
  }

  double get weeklyAverageConsumption {
    if (weeklyUsage.isEmpty) return 0;

    final sum = weeklyUsage.fold<double>(
      0,
      (value, element) => value + element.dailyUsage,
    );

    return sum / weeklyUsage.length;
  }

  double get monthlyAverageConsumption {
    if (monthlyUsage.isEmpty) return 0;

    final sum = monthlyUsage.fold<double>(
      0,
      (value, element) => value + element.dailyUsage,
    );

    return sum / monthlyUsage.length;
  }

  double get yearlyAverageConsumption {
    if (yearlyUsage.isEmpty) return 0;

    final sum = yearlyUsage.fold<double>(
      0,
      (value, element) => value + element.dailyUsage,
    );

    return sum / yearlyUsage.length;
  }

  double get availableKwh {
    return lastComputedRecord.value?.record.availableKwh ?? 0;
  }

  double? get availableKwhValue {
    return lastComputedRecord.value?.costOfAvailableKwh;
  }

  int? get dayLeftPrediction {
    double benchmark = weeklyAverageConsumption;

    if (benchmark == 0) {
      benchmark = monthlyAverageConsumption;
    }

    if (benchmark == 0) {
      benchmark = yearlyAverageConsumption;
    }

    if (benchmark == 0) {
      benchmark = lifetimeAverageConsumption.value;
    }

    if (benchmark == 0) {
      return -1;
    }

    return lastComputedRecord.value?.record.availableKwh != null
        ? lastComputedRecord.value!.record.availableKwh ~/ benchmark
        : null;
  }

  void calculate() async {
    Stopwatch stopwatch = Stopwatch()..start();
    calculationService.calculate();

    lifetimeAverageConsumption.value = calculationService.averageConsumption;

    computedRecords.value =
        calculationService.computedRecords.reversed.toList();

    lastComputedRecord.value = computedRecords.firstWhereOrNull((_) => true);

    final today = DateTime.now();

    weeklyUsage = computedRecords.where(
      (cp) {
        return cp.record.createdAt.isAfter(today.subtract(7.days)) &&
            cp.record.createdAt.isBefore(today);
      },
    ).toList();

    monthlyUsage = computedRecords.where(
      (cp) {
        return cp.record.createdAt.isAfter(today.subtract(30.days)) &&
            cp.record.createdAt.isBefore(today);
      },
    ).toList();

    yearlyUsage = computedRecords.where(
      (cp) {
        return cp.record.createdAt.isAfter(today.subtract(365.days)) &&
            cp.record.createdAt.isBefore(today);
      },
    ).toList();

    allUsage = computedRecords.toList();

    stopwatch.stop();

    calculationTime.value = 'Time elapsed: ${stopwatch.elapsed}';
  }

  void setRage(ChartRange range) {
    chartRage.value = range;
  }
}
