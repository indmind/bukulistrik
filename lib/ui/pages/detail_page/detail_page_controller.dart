import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:get/get.dart';

class DetailPageController extends GetxController {
  late final ComputedRecord cr;

  @override
  void onInit() {
    super.onInit();

    cr = Get.arguments['computedRecord'] as ComputedRecord;
  }
}
