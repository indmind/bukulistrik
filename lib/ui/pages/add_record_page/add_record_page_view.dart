import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddRecordPageView extends GetView<AddRecordPageController> {
  const AddRecordPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Get.theme.colorScheme.background,
        foregroundColor: Get.theme.colorScheme.onBackground,
        title: const Text("Tambah"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(child: Text(controller.title)),
    );
  }
}
