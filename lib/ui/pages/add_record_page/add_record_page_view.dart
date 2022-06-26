import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddRecordPageView extends GetView<AddRecordPageController> {
  const AddRecordPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text(controller.title)),
    );
  }
}
