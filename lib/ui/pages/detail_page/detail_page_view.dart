import 'package:bukulistrik/ui/pages/detail_page/detail_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/kwh.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPageView extends GetView<DetailPageController> {
  const DetailPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemakaian'),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              Get.toNamed('/add-record', arguments: {
                'record': controller.cr.record,
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Spacing.p2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("Nilai Meteran"),
              Row(
                children: [
                  Expanded(
                    child: DetailCard(
                      icon: Icon(
                        Icons.electric_meter_rounded,
                        color: Get.theme.colorScheme.primary,
                      ),
                      title: const Text('Jumlah kW H'),
                      value: Kwh(
                        value: controller.cr.record.availableKwh,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DetailCard(
                      icon: Icon(
                        Icons.attach_money_rounded,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      title: const Text('Nominal'),
                      value: Rp(controller.cr.costOfAvailableKwh),
                    ),
                  ),
                ],
              ),
              DetailCard(
                icon: Icon(
                  Icons.electric_meter_outlined,
                  color: Get.theme.colorScheme.onBackground,
                ),
                title: const Text('Sebelumnya'),
                value: Row(
                  children: [
                    Kwh(value: controller.cr.prevRecord?.record.availableKwh),
                    Spacing.w4,
                    Text(
                      'atau',
                      style: Get.textTheme.caption,
                    ),
                    Spacing.w4,
                    Rp(controller.cr.prevRecord?.costOfAvailableKwh),
                  ],
                ),
              ),
              if (controller.cr.record.addedPricePerKwh != null) ...[
                _title("Pembelian"),
                Row(
                  children: [
                    Expanded(
                      child: DetailCard(
                        icon: Icon(
                          Icons.attach_money_rounded,
                          color: Get.theme.colorScheme.secondary,
                        ),
                        title: const Text('Nominal'),
                        value: Rp(controller.cr.record.addedKwhPrice),
                      ),
                    ),
                    Expanded(
                      child: DetailCard(
                        icon: Icon(
                          Icons.money_rounded,
                          color: Get.theme.colorScheme.primary,
                        ),
                        title: const Text('Jumlah Didapat'),
                        value: Kwh(
                          value: controller.cr.record.addedKwh,
                        ),
                      ),
                    ),
                  ],
                ),
                DetailCard(
                  icon: Icon(
                    Icons.calculate_rounded,
                    color: Get.theme.colorScheme.primary,
                  ),
                  title: const Text('Harga Per Kwh Pembelian'),
                  value: Rp(
                    controller.cr.record.addedPricePerKwh,
                  ),
                ),
                DetailCard(
                  icon: Icon(
                    Icons.find_replace_rounded,
                    color: Get.theme.colorScheme.primary,
                  ),
                  statusIcon: Helper.iconFromStatus(
                    controller.cr.totalCostPerKwhStatus,
                    false,
                  ),
                  title: const Text('Perubahan Total Harga Per Kwh'),
                  value: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Rp(
                        controller.cr.totalCostPerKwh,
                      ),
                      if (controller.cr.prevRecord != null) ...[
                        Spacing.w2,
                        Text(
                          'Sebelumnya',
                          style: Get.theme.textTheme.caption,
                        ),
                        Spacing.w2,
                        Rp(
                          controller.cr.prevRecord!.totalCostPerKwh,
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              _title("Penggunaan"),
              DetailCard(
                icon: Icon(
                  Icons.av_timer_rounded,
                  color: Get.theme.colorScheme.primary,
                ),
                title: const Text('Durasi Sejak Catatan Sebelumnya'),
                value: Text(
                  prettyDuration(
                    controller.cr.durationFromLastRecord,
                    locale: DurationLocale.fromLanguageCode('id')!,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DetailCard(
                icon: Icon(
                  Icons.electrical_services_rounded,
                  color: Get.theme.colorScheme.primary,
                ),
                statusIcon: Helper.iconFromStatus(
                  controller.cr.fromLastRecordUsageStatus,
                  false,
                ),
                title: const Text('Penggunaan Sejak Catatan Sebelumnya'),
                value: Row(
                  children: [
                    Kwh(value: controller.cr.fromLastRecordUsage),
                    Spacing.w4,
                    Text(
                      'atau',
                      style: Get.textTheme.caption,
                    ),
                    Spacing.w4,
                    Rp(controller.cr.fromLastRecordCost),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DetailCard(
                      icon: Icon(
                        Icons.timelapse_rounded,
                        color: Get.theme.colorScheme.primary,
                      ),
                      statusIcon: Helper.iconFromStatus(
                        controller.cr.hourlyUsageStatus,
                        false,
                      ),
                      title: const Text('kW H/Jam'),
                      value: Kwh(
                        value: controller.cr.hourlyUsage,
                        fractions: 5,
                      ),
                      // noIcon: true,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DetailCard(
                      icon: Icon(
                        Icons.attach_money_rounded,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      statusIcon: Helper.iconFromStatus(
                        controller.cr.hourlyCostStatus,
                        false,
                      ),
                      title: const Text('Biaya/Jam'),
                      value: Rp(controller.cr.hourlyCost),
                      // noIcon: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DetailCard(
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: Get.theme.colorScheme.primary,
                      ),
                      statusIcon: Helper.iconFromStatus(
                        controller.cr.dailyUsageStatus,
                        false,
                      ),
                      title: const Text('kW H/Hari'),
                      value: Kwh(value: controller.cr.dailyUsage),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: DetailCard(
                      icon: Icon(
                        Icons.attach_money_rounded,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      statusIcon: Helper.iconFromStatus(
                        controller.cr.dailyCostStatus,
                        false,
                      ),
                      title: const Text('Biaya/Hari'),
                      value: Rp(controller.cr.dailyCost),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _title(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12, 8.0, 8.0),
      child: Text(
        title,
        style: Get.textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  final Widget title;
  final Widget value;
  final Icon icon;
  final bool noIcon;
  final Icon? statusIcon;

  const DetailCard({
    Key? key,
    required this.title,
    required this.value,
    this.icon = const Icon(Icons.info_outline_rounded),
    this.noIcon = false,
    this.statusIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget computedTitle = title;

    if (computedTitle is Text) {
      final defaultTs = Get.theme.textTheme.caption!;

      computedTitle = Text(
        computedTitle.data!,
        style: defaultTs.merge(computedTitle.style),
        // overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.shadow,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: Spacing.p8,
      margin: Spacing.p2,
      child: Row(
        children: [
          if (!noIcon)
            if (statusIcon != null)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  icon,
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Icon(
                      statusIcon!.icon,
                      color: statusIcon!.color,
                      size: (icon.size ?? 24) * 0.5,
                    ),
                  ),
                ],
              )
            else
              icon,
          Spacing.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                computedTitle,
                Spacing.h4,
                value,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Rp extends StatelessWidget {
  final double? value;
  final double size;
  final TextStyle? style;
  final int fractions;

  const Rp(
    this.value, {
    Key? key,
    this.size = 16,
    this.style,
    this.fractions = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mergedStyle = TextStyle(
      color: Get.theme.colorScheme.onBackground.withOpacity(0.9),
      fontSize: size,
      fontWeight: FontWeight.bold,
    ).merge(style);

    return RichText(
      text: TextSpan(
        text: "Rp. ",
        style: TextStyle(
          color: Get.theme.colorScheme.onBackground.withOpacity(0.75),
          fontSize: size * 0.5,
        ),
        children: [
          TextSpan(
            text: value != null ? Helper.rp.format(value) : '-',
            style: mergedStyle,
          ),
        ],
      ),
    );
  }
}
