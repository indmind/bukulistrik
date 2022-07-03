import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/record_service.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_tutorial.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRecordPageController extends GetxController {
  final AddRecordPageTutorial tutorial = Get.find();
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

  bool get isValid => formKey.currentState?.validate() ?? false;

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

      final newRecord = Record(
        // IMPORTANT: set old record id for update
        id: record?.id,
        availableKwh: Helper.parseDouble(kwhController.text)!,
        createdAt: Helper.df.parse(dateController.text),
        note: noteController.text.isEmpty ? null : noteController.text,
        addedKwhPrice: Helper.parseDouble(addedKwhPriceController.text),
        addedKwh: Helper.parseDouble(addedKwhController.text),
      );

      if (record != null) {
        await Get.find<RecordService>().update(newRecord);
      } else {
        await Get.find<RecordService>().save(newRecord);
      }

      Get.back();
    }
  }

  deleteRecord() {
    if (record != null) {
      Get.find<RecordService>().delete(record!);
      Get.back();
    }
  }
}
