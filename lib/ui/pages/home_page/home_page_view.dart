import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/available_kwh.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/computed_record_list_item.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/home_page_drawer.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/kwh.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            drawer: HomePageDrawer(),
            body: CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverAppBar(
                  elevation: 1,
                  pinned: true,
                  centerTitle: true,
                  title: Text(
                    'Buku Listrik',
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Get.theme.colorScheme.primary,
                    padding: const EdgeInsets.only(
                      left: Spacing.padding * 8,
                      right: Spacing.padding * 8,
                      top: Spacing.padding * 4,
                      bottom: Spacing.padding,
                    ),
                    child: Obx(() {
                      return AvailableKwh(
                        key: controller.tutorial.availableEnergyKey,
                        availableKwhKey: controller.tutorial.availableKwhKey,
                        availableMoneyKey:
                            controller.tutorial.availableMoneyKey,
                        availableDayleftKey:
                            controller.tutorial.availableDayKey,
                        available: controller.availableKwh,
                        inPrice: controller.availableKwhValue,
                        predictedDayLeft: controller.dayLeftPrediction,
                      );
                    }),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildChart(),
                ),
                SliverToBoxAdapter(
                  child: _buildRangeSelector(),
                ),
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        color: Get.theme.colorScheme.primary,
                        width: double.infinity,
                        height: 50,
                      ),
                      Positioned(
                        left: Spacing.width * 8,
                        right: Spacing.width * 8,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.surface,
                            borderRadius: Spacing.rounded,
                            boxShadow: [
                              BoxShadow(
                                color: Get.theme.colorScheme.shadow,
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                // listen to selectd range
                                controller.chartRage.value;

                                Color color = Get.theme.colorScheme.background;
                                IconData icon = Icons.circle_rounded;

                                double diff = controller
                                        .lifetimeAverageConsumption.value -
                                    controller.displayedAverageConsumption;

                                if (diff.abs().toPrecision(2) < 0.1) {
                                  color = Get.theme.colorScheme.secondary;
                                } else if (diff > 0) {
                                  color = Get.theme.colorScheme.tertiary
                                      .withOpacity(0.8);
                                  icon = Icons.swipe_down_alt_rounded;
                                } else {
                                  color = Get.theme.colorScheme.error
                                      .withOpacity(0.8);
                                  icon = Icons.swipe_up_alt_rounded;
                                }

                                return Row(
                                  key:
                                      controller.tutorial.averageConsumptionKey,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(icon, color: color, size: 20),
                                    Spacing.w4,
                                    Kwh(
                                      value: controller
                                          .displayedAverageConsumption,
                                      size: 32,
                                    ),
                                  ],
                                );
                              }),
                              Spacing.h4,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.data_usage_rounded,
                                      size: 14),
                                  Spacing.w2,
                                  Obx(() => RichText(
                                        key: controller.tutorial
                                            .lifetimeAverageConsumptionKey,
                                        text: TextSpan(
                                          text: controller
                                              .lifetimeAverageConsumption
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color:
                                                Get.theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ' kW H',
                                              style: TextStyle(
                                                color: Get.theme.colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Spacing.w2,
                                  SizedBox(
                                    height: 19,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'Sepanjang waktu',
                                        style: Get.theme.textTheme.caption!
                                            .copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 50 + Spacing.height * 12),
                ),
                Obx(() {
                  if (controller.computedRecords.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: Spacing.p8,
                        child: Column(
                          children: [
                            const Icon(Icons.note_outlined, size: 50),
                            Spacing.h4,
                            Text(
                              'Belum ada data, tambahkan sekarang!',
                              textAlign: TextAlign.center,
                              style: Get.theme.textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final cr = controller.computedRecords[i];

                        // difference from average consumption
                        final diff = (controller.calculationService.dailyMeta
                                .averageConsumption) -
                            cr.dailyUsage;
                        final color = controller.calculationService
                            .calculateDailyUsageColor(cr.dailyUsage);

                        String status = '-';
                        IconData icon = Icons.circle_rounded;

                        if (diff.abs().toPrecision(2) < 0.1) {
                          status = 'Penggunaan wajar';
                        } else if (diff < 0) {
                          status = 'Penggunaan lebih tinggi daripada biasanya';
                          icon = Icons.arrow_drop_up_rounded;
                        } else {
                          status = 'Penggunaan lebih rendah daripada biasanya';
                          icon = Icons.arrow_drop_down_rounded;
                        }

                        return ComputedRecordListItem(
                          key: i == 0
                              ? controller.tutorial.usageRecordKey
                              : null,
                          computedRecord: cr,
                          color: color,
                          icon: icon,
                          status: status,
                        );
                      },
                      childCount: controller.computedRecords.length,
                    ),
                  );
                }),
              ],
            ),
            floatingActionButton: _buildFAB(),
          ),
        ),
        Obx(() {
          final ad = controller.bannerAd.value;

          if (ad != null) {
            return Container(
              alignment: Alignment.center,
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget _buildFAB() {
    return Obx(() {
      return Wrap(
        direction: Axis.vertical,
        children: [
          AnimatedSwitcher(
            duration: 150.milliseconds,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            switchInCurve: Curves.easeIn,
            child: controller.showBackToTopButton.value
                ? FloatingActionButton(
                    heroTag: 'scroll-to-top-fab',
                    onPressed: controller.scrollToTop,
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Spacing.h6,
          FloatingActionButton(
            key: controller.tutorial.addRecordKey,
            onPressed: controller.onAddRecord,
            backgroundColor: Get.theme.colorScheme.primary,
            child: const Icon(Icons.add_rounded),
          ),
        ],
      );
    });
  }

  Obx _buildChart() {
    return Obx(() {
      // listen to computed records changes
      if (controller.computedRecords.isEmpty) {
        debugPrint('computed records is empty');
      }

      final range = controller.chartRage.value;

      return Container(
        key: controller.tutorial.usageChartKey,
        height: 150,
        color: Get.theme.colorScheme.primary,
        child: SfCartesianChart(
          key: ValueKey(range),
          series: <LineSeries<ComputedRecord, DateTime>>[
            LineSeries(
              dataSource: controller.displayedData,
              onRendererCreated: (chartController) {
                controller.chartController = chartController;
              },
              yValueMapper: (ComputedRecord cp, _) =>
                  double.parse(cp.dailyUsage.toStringAsFixed(2)),
              xValueMapper: (ComputedRecord cp, _) => cp.record.createdAt,
              xAxisName: 'Date',
              color: Get.theme.colorScheme.onPrimary.withOpacity(0.75),
              width: 2,
              dataLabelSettings: DataLabelSettings(
                isVisible: range == ChartRange.week || range == ChartRange.month
                    ? true
                    : false,
                textStyle: TextStyle(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: 12,
                ),
                connectorLineSettings: ConnectorLineSettings(
                  color: Get.theme.colorScheme.onPrimary,
                  width: 1,
                ),
              ),
            ),
          ],
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            isVisible: false,
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
          ),
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.zero,
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings:
                const InteractiveTooltip(format: 'point.x : point.y'),
          ),
        ),
      );
    });
  }

  Container _buildRangeSelector() {
    return Container(
      key: controller.tutorial.usageChartRangeKey,
      color: Get.theme.colorScheme.primary,
      padding: Spacing.p8,
      child: Obx(() {
        final chartRange = controller.chartRage.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.setRage(ChartRange.week);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: chartRange == ChartRange.week
                    ? Get.theme.colorScheme.onPrimary
                    : Colors.transparent,
                onPrimary: chartRange == ChartRange.week
                    ? Get.theme.colorScheme.primary
                    : Get.theme.colorScheme.onPrimary,
              ),
              child: const Text('1M'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.setRage(ChartRange.month);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: chartRange == ChartRange.month
                      ? Get.theme.colorScheme.onPrimary
                      : Colors.transparent,
                  onPrimary: chartRange == ChartRange.month
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.onPrimary),
              child: const Text('1B'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.setRage(ChartRange.year);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: chartRange == ChartRange.year
                      ? Get.theme.colorScheme.onPrimary
                      : Colors.transparent,
                  onPrimary: chartRange == ChartRange.year
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.onPrimary),
              child: const Text('1T'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.setRage(ChartRange.all);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: chartRange == ChartRange.all
                      ? Get.theme.colorScheme.onPrimary
                      : Colors.transparent,
                  onPrimary: chartRange == ChartRange.all
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.onPrimary),
              child: const Text('Semua'),
            ),
          ],
        );
      }),
    );
  }
}
