import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartRange { week, month, year, all }

class HomePageController extends GetxController {
  final CalculationService calculationService = Get.find<CalculationService>();

  RxDouble averageConsumption = 0.0.obs;
  RxString calculationTime = ''.obs;
  RxList<ComputedRecord> computedRecords = <ComputedRecord>[].obs;

  Rx<ChartRange> chartRage = ChartRange.week.obs;

  ChartSeriesController? chartController;

  List<ComputedRecord> weeklyUsage = [];
  List<ComputedRecord> monthlyUsage = [];
  List<ComputedRecord> yearlyUsage = [];
  List<ComputedRecord> allUsage = [];

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

  @override
  void onInit() {
    super.onInit();
    calculate();
  }

  void calculate() async {
    Stopwatch stopwatch = Stopwatch()..start();
    calculationService.calculate();

    averageConsumption.value = calculationService.averageConsumption;

    computedRecords.value =
        calculationService.computedRecords.reversed.toList();

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
