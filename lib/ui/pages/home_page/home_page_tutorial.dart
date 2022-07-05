import 'package:bukulistrik/common/logger.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePageTutorial {
  final List<TargetFocus> targets = <TargetFocus>[];

  final availableEnergyKey = GlobalKey();
  final availableKwhKey = GlobalKey();
  final availableMoneyKey = GlobalKey();
  final availableDayKey = GlobalKey();

  final averageConsumptionKey = GlobalKey();
  final lifetimeAverageConsumptionKey = GlobalKey();
  final usageChartKey = GlobalKey();
  final usageChartRangeKey = GlobalKey();
  final usageRecordKey = GlobalKey();
  final addRecordKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  static const String storageKey = 'home_page_tutorial_has_shown';
  bool get hasShown => GetStorage().read(storageKey) ?? false;

  void start() {
    initTargets();

    if (tutorialCoachMark?.isShowing == true) {
      tutorialCoachMark?.finish();
    }

    tutorialCoachMark = TutorialCoachMark(
      Get.overlayContext!,
      targets: targets,
      textSkip: "Skip",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickOverlay: (target) {
        Logger.d('HomePageTutorial: onClickOverlay');

        tutorialCoachMark?.next();
      },
    );

    tutorialCoachMark!.show();

    GetStorage().write(storageKey, true);

    Logger.d('HomePageTutorial: start');
  }

  void initTargets() {
    targets.clear();

    targets.add(Helper.buildSimpleTarget(
      availableEnergyKey,
      "Ini adalah sisa energi listrik yang tersedia saat ini.",
    ));

    targets.add(Helper.buildSimpleTarget(
      availableKwhKey,
      "Ini adalah sisa energi yang tersedia dalam satuan kW H atau Kilowatt Jam.",
    ));

    targets.add(Helper.buildSimpleTarget(
      availableMoneyKey,
      "Ini adalah sisa energi yang tersedia dalam satuan Rupiah.",
    ));

    targets.add(Helper.buildSimpleTarget(
      availableDayKey,
      "Ini adalah prediksi jumlah hari sampai energi habis. Kalkulasi dilakukan berdasarkan data-data penggunaan terakhir.",
      shape: ShapeLightFocus.Circle,
    ));

    targets.add(Helper.buildSimpleTarget(
      usageChartKey,
      "Ini adalah grafik penggunaan listrik dalam rentang waktu tertentu.",
    ));

    targets.add(Helper.buildSimpleTarget(
      usageChartRangeKey,
      "Ini adalah pilihan rentang waktu untuk menyesuaikan tampilan grafik dan tampilan rata-rata penggunaan.",
    ));

    targets.add(Helper.buildSimpleTarget(
      averageConsumptionKey,
      "Ini adalah rata-rata penggunaan listrik dalam rentang waktu tertentu satuan kWh H.\n\n"
      "Tanda akan menyesuaikan dengan rata-rata penggunaan secara keseluruhan.",
    ));

    targets.add(Helper.buildSimpleTarget(
      lifetimeAverageConsumptionKey,
      "Ini adalah rata-rata penggunaan listrik secara keseluruhan.",
    ));

    targets.add(Helper.buildSimpleTarget(
      usageRecordKey,
      "Ini adalah data penggunaan listrik per HARI.\n\n"
      "Nilai ini dihitung berdasarkan rata-rata penggunaan listrik per menit sejak catatan terakhir.",
      contentAlign: ContentAlign.top,
    ));

    targets.add(Helper.buildSimpleTarget(
      addRecordKey,
      "Anda dapat menambahkan catatan dengan cara menekan tombol berikut."
      "\n\nSebaiknya catatlah meteran listrik Anda setiap hari pada jam yang sama untuk mendapatkan data yang akurat.",
      shape: ShapeLightFocus.Circle,
      contentAlign: ContentAlign.top,
    ));
  }
}
