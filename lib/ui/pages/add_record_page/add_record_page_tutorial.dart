import 'package:bukulistrik/common/logger.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddRecordPageTutorial {
  final List<TargetFocus> targets = <TargetFocus>[];

  final availableKwhKey = GlobalKey();
  final createdAtKey = GlobalKey();
  final noteKey = GlobalKey();

  final purchaseKey = GlobalKey();
  final purchaseAmountCostKey = GlobalKey();
  final purchaseAmountKwhKey = GlobalKey();

  final saveKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  static const String storageKey = 'add_record_page_tutorial_has_shown';
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
      onClickOverlay: (target) async {
        Logger.d('AddRecordPageTutorial: onClickOverlay');

        if (target.keyTarget == noteKey) {
          Scrollable.ensureVisible(
            purchaseAmountKwhKey.currentContext!,
            duration: 500.milliseconds,
            curve: Curves.ease,
          );
        } else if (target.keyTarget == purchaseKey) {
          Scrollable.ensureVisible(
            saveKey.currentContext!,
            duration: 500.milliseconds,
            curve: Curves.ease,
          );
        }

        tutorialCoachMark?.next();
      },
    );

    tutorialCoachMark!.show();

    GetStorage().write(storageKey, true);

    Logger.d('AddRecordPageTutorial: start');
  }

  void initTargets() {
    targets.clear();

    targets.add(Helper.buildSimpleTarget(
      availableKwhKey,
      "Anda dapat memasukkan nilai kW H yang tertera pada meteran rumah Anda di sini.",
    ));

    targets.add(Helper.buildSimpleTarget(
      createdAtKey,
      "Setelah memasukkan nilai kW H, pastikan bahwa waktu pencatatan sesuai dengan waktu pengambilan data, agar data menjadi lebih akurat",
    ));

    targets.add(Helper.buildSimpleTarget(
      noteKey,
      "Anda juga dapat menambahkan catatan tentang penggunaan listrik Anda di sini.",
    ));

    targets.add(Helper.buildSimpleTarget(
      purchaseKey,
      "Jika pada hari pencataan anda melakukan pembelian token listrik, Jangan lupa untuk menambahkanya di sini",
      contentAlign: ContentAlign.top,
    ));

    targets.add(Helper.buildSimpleTarget(
      purchaseAmountCostKey,
      "Anda dapat memasukkan jumlah pembelian token listrik di sini. Contoh: Rp. 100.000",
      contentAlign: ContentAlign.top,
    ));

    targets.add(Helper.buildSimpleTarget(
      purchaseAmountKwhKey,
      "Setelah memasukkan jumlah pembelian, maka masukkan berapa total kW H yang Anda dapatkan di sini",
      contentAlign: ContentAlign.top,
    ));

    targets.add(Helper.buildSimpleTarget(
      saveKey,
      "Jika semua data sudah benar, klik tombol simpan untuk menyimpan data penggunaan listrik Anda.",
      contentAlign: ContentAlign.top,
    ));
  }
}
