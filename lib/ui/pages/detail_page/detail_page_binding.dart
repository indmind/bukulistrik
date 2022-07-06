import 'package:bukulistrik/ui/pages/detail_page/detail_page_controller.dart';
import 'package:get/instance_manager.dart';

class DetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPageController>(() => DetailPageController());
  }
}
