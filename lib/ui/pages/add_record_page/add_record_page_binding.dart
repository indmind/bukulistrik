import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_controller.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_tutorial.dart';
import 'package:get/instance_manager.dart';

class AddRecordPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddRecordPageTutorial());
    Get.lazyPut<AddRecordPageController>(() => AddRecordPageController());
  }
}
