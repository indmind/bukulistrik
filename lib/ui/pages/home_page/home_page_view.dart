import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/available_kwh.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              // elevation: 0,
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
                child: AvailableKwh(
                  available: controller
                          .lastComputedRecord.value?.record.availableKwh ??
                      0,
                  inPrice:
                      controller.lastComputedRecord.value?.costOfAvailableKwh,
                ),
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

                            double diff =
                                controller.lifetimeAverageConsumption.value -
                                    controller.displayedAverageConsumption;

                            if (diff.abs().toPrecision(2) >= 0 &&
                                diff.abs().toPrecision(2) < 0.1) {
                              color = Get.theme.colorScheme.secondary;
                            } else if (diff > 0) {
                              color = Get.theme.colorScheme.tertiary
                                  .withOpacity(0.8);
                              icon = Icons.swipe_down_alt_rounded;
                            } else {
                              color =
                                  Get.theme.colorScheme.error.withOpacity(0.8);
                              icon = Icons.swipe_up_alt_rounded;
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, color: color, size: 20),
                                Spacing.w4,
                                RichText(
                                  text: TextSpan(
                                    text: controller.displayedAverageConsumption
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Get.theme.colorScheme.onBackground
                                          .withOpacity(0.75),
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' kW H',
                                        style: Get.theme.textTheme.caption!
                                            .copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          Spacing.h4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.data_usage_rounded, size: 14),
                              Spacing.w2,
                              RichText(
                                text: TextSpan(
                                  text: controller.lifetimeAverageConsumption
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' kW H',
                                      style: TextStyle(
                                        color:
                                            Get.theme.colorScheme.onBackground,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacing.w2,
                              Text(
                                'Sepanjang waktu',
                                style: Get.theme.textTheme.caption!.copyWith(
                                  fontSize: 10,
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final cr = controller.computedRecords[i];

                  // difference from average consumption
                  final diff = controller.calculationService
                      .calculateDiff(cr.dailyUsage);
                  final color = controller.calculationService
                      .calculateColor(cr.dailyUsage);

                  String status = '-';
                  IconData icon = Icons.circle_rounded;

                  if (diff.abs().toPrecision(2) >= 0 &&
                      diff.abs().toPrecision(2) < 0.1) {
                    status = 'Penggunaan wajar';
                  } else if (diff < 0) {
                    status = 'Penggunaan lebih tinggi daripada biasanya';
                    icon = Icons.arrow_drop_up_rounded;
                  } else {
                    status = 'Penggunaan lebih rendah daripada biasanya';
                    icon = Icons.arrow_drop_down_rounded;
                  }

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color,
                          child: Container(
                            padding: Spacing.p2,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.background,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: color,
                            ),
                          ),
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Kwh(value: cr.dailyUsage, size: 20),
                            Spacing.w2,
                            RichText(
                              text: TextSpan(
                                text: "/ Rp. ",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onBackground
                                      .withOpacity(0.75),
                                  fontSize: 9,
                                ),
                                children: [
                                  TextSpan(
                                    text: Helper.rp.format(cr.dailyCost),
                                    style:
                                        Get.theme.textTheme.caption!.copyWith(
                                      fontSize: 12,
                                      color: Get.theme.colorScheme.onBackground
                                          .withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Helper.df.format(cr.record.createdAt),
                              style: TextStyle(
                                color: Get.theme.colorScheme.onBackground,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacing.h2,
                            Text(
                              status,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Spacing.h2,
                            if (cr.record.note != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Catatan: ",
                                    style: Get.theme.textTheme.titleSmall,
                                  ),
                                  Expanded(
                                    child: Text(
                                      cr.record.note!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Get.theme.colorScheme.onBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (cr.record.addedPricePerKwh != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacing.h2,
                                  Text(
                                    "Pembelian".tr,
                                    style: Get.theme.textTheme.titleSmall,
                                  ),
                                  Spacing.h2,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: Get.theme.colorScheme.tertiary,
                                        size: 18,
                                      ),
                                      Kwh(value: cr.record.addedKwh!, size: 18),
                                      const Spacer(),
                                      Container(
                                        height: 16,
                                        width: 1,
                                        color: Get
                                            .theme.colorScheme.onBackground
                                            .withOpacity(0.5),
                                      ),
                                      const Spacer(),
                                      RichText(
                                        text: TextSpan(
                                          text: "Rp. ",
                                          style: TextStyle(
                                            color: Get
                                                .theme.colorScheme.onBackground
                                                .withOpacity(0.75),
                                            fontSize: 12,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: Helper.rp.format(
                                                cr.record.addedKwhPrice,
                                              ),
                                              style: Get
                                                  .theme.textTheme.caption!
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Get.theme.colorScheme
                                                    .onBackground
                                                    .withOpacity(0.75),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const Divider(height: Spacing.height * 12),
                    ],
                  );
                },
                childCount: controller.computedRecords.length,
              ),
            ),
          ],
        ),
        floatingActionButton: controller.showBackToTopButton.value
            ? FloatingActionButton(
                onPressed: controller.scrollToTop,
                child: const Icon(
                  Icons.arrow_upward_rounded,
                ),
              )
            : null,
      );
    });
  }

  Obx _buildChart() {
    return Obx(() {
      final range = controller.chartRage.value;

      return Container(
        height: 180,
        color: Get.theme.colorScheme.primary,
        child: SfCartesianChart(
          key: ValueKey(range),
          series: <LineSeries<ComputedRecord, DateTime>>[
            LineSeries(
              dataSource: controller.displayedData,
              onRendererCreated: (chartController) {
                controller.chartController = chartController;
              },
              yValueMapper: (ComputedRecord cp, _) => cp.dailyUsage,
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

class Kwh extends StatelessWidget {
  final double value;
  final double size;
  final TextStyle? style;

  const Kwh({
    Key? key,
    required this.value,
    this.size = 16,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mergedStyle = TextStyle(
      color: Get.theme.colorScheme.onBackground.withOpacity(0.75),
      fontSize: size,
      fontWeight: FontWeight.bold,
    ).merge(style);

    return RichText(
      text: TextSpan(
        text: value.toStringAsFixed(2),
        style: mergedStyle,
        children: [
          TextSpan(
            text: ' kW H',
            style: Get.theme.textTheme.caption!.copyWith(
              fontSize: size * 0.4,
              color: mergedStyle.color?.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
