import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/ad_service.dart';
import 'package:bukulistrik/domain/services/calculation_service.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:bukulistrik/routes.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_tutorial.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRecordPageController extends GetxController {
  final CalculationService calculationService = Get.find();

  final AddRecordPageTutorial tutorial = Get.find();
  final AdService adService = Get.find();
  final formKey = GlobalKey<FormState>();

  final kwhController = TextEditingController();
  final dateController = TextEditingController(
    text: Helper.df.format(DateTime.now()),
  );
  final noteController = TextEditingController();
  final addedKwhPriceController = TextEditingController();
  final addedKwhController = TextEditingController();

  late final bool initiallyExpanded;

  Record? record;

  @override
  void onInit() {
    super.onInit();

    record = Get.arguments?['record'] as Record?;

    if (record != null) {
      kwhController.text = Helper.fromDouble(record!.availableKwh) ?? '';
      dateController.text = Helper.df.format(record!.createdAt);
      noteController.text = record!.note ?? '';
      addedKwhPriceController.text =
          Helper.fromDouble(record!.addedKwhPrice, 0) ?? '';
      addedKwhController.text = Helper.fromDouble(record!.addedKwh) ?? '';

      if (record!.addedKwh != null && record!.addedKwhPrice != null) {
        initiallyExpanded = true;
      } else {
        if (tutorial.hasShown) {
          initiallyExpanded = false;
        } else {
          initiallyExpanded = true;
        }
      }
    } else {
      if (tutorial.hasShown) {
        initiallyExpanded = false;
      } else {
        initiallyExpanded = true;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (!tutorial.hasShown && tutorial.tutorialCoachMark?.isShowing != true) {
      tutorial.start();
    }
  }

  ComputedRecord? get prev => record != null
      ? calculationService.computedRecordFor(record!)
      : calculationService.lastComputedRecord;

  bool get isValid => formKey.currentState?.validate() ?? false;

  String get availableKwhExample {
    if (prev == null) {
      return 'Contoh: 120.5';
    }
    if (record != null) {
      return 'Contoh: ${record!.availableKwh.toStringAsFixed(2)}';
    } else {
      double predicted = prev!.record.availableKwh - prev!.dailyUsage;

      predicted = predicted.clamp(0, prev!.record.availableKwh);

      return 'Contoh: ${predicted.toStringAsFixed(2)}';
    }
  }

  void clear() {
    kwhController.clear();
    dateController.text = Helper.df.format(DateTime.now());
    noteController.clear();
    addedKwhPriceController.clear();
    addedKwhController.clear();
  }

  @override
  void dispose() {
    kwhController.dispose();
    dateController.dispose();
    noteController.dispose();
    addedKwhPriceController.dispose();
    addedKwhController.dispose();

    super.dispose();
  }

  Future<void> onSave() async {
    if (isValid) {
      formKey.currentState!.save();

      final availableKwh = Helper.parseDouble(kwhController.text)!;
      final addedKwh = Helper.parseDouble(addedKwhController.text);

      final newRecord = Record(
        // IMPORTANT: set old record id for update
        id: record?.id,
        availableKwh: availableKwh,
        createdAt: Helper.df.parse(dateController.text),
        note: noteController.text.isEmpty ? null : noteController.text,
        addedKwhPrice: Helper.parseDouble(addedKwhPriceController.text),
        addedKwh: addedKwh,
      );

      final cr = ComputedRecord(
        record: newRecord,

        // if updating, set prev of this record to prev of old record
        prevRecord: prev?.record.id == newRecord.id ? prev?.prevRecord : prev,
      );

      if (cr.minutelyUsage < 0) {
        final confirmed = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Konfirmasi?"),
            insetPadding: Spacing.p8 * 2,
            titlePadding: Spacing.p8,
            contentPadding: Spacing.px8,
            content: const Text(
              "Data yang Anda masukkan tidak valid!\n\n"
              "Harap perhatikan apabila nilai sisa kW H telah sesuai "
              "dan pastikan juga apabila Anda telah melakukan pembelian token sebelumnya.\n",
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Get.theme.colorScheme.error,
                ),
                child: const Text("Tetap Simpan"),
                onPressed: () => Get.back(result: true),
              ),
              ElevatedButton(
                child: const Text("Perbaiki"),
                onPressed: () => Get.back(result: false),
              ),
            ],
          ),
        );

        if (confirmed != true) {
          return;
        }
      }

      if (record != null) {
        await Get.find<RecordService>().update(newRecord);
      } else {
        await Get.find<RecordService>().save(newRecord);
      }

      await adService.interstitialAd.value?.show();

      Get.until((_) => Get.currentRoute == Routes.home.name);
    }
  }

  deleteRecord() {
    if (record != null) {
      Get.find<RecordService>().delete(record!);
      Get.until((_) => Get.currentRoute == Routes.home.name);
    }
  }
}
