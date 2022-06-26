import 'package:bukulistrik/domain/models/record.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

/// This class is used to store records
class RecordService extends GetxService {
  /// This variable stores records
  List<Record> records = [
    Record(
      createdAt: DateTime.parse('2022-06-02 18:51:02'),
      availableKwh: 71,
      addedKwh: 67.3,
      addedKwhPrice: 100000,
      note: 'Pembelian awal',
    ),
    Record(
      createdAt: DateTime.parse('2022-06-03 18:50:43'),
      availableKwh: 68.87,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-04 19:19:20'),
      availableKwh: 66.22,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-05 19:44:01'),
      availableKwh: 64.02,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-06 18:41:21'),
      availableKwh: 61.8,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-07 17:40:57'),
      availableKwh: 59.74,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-08 20:10:57'),
      availableKwh: 57.53,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-09 18:17:16'),
      availableKwh: 55.64,
    ),
    Record(
      createdAt: DateTime.parse('2022-06-10 19:33:12'),
      availableKwh: 52.63,
    ),
    // Record(
    //   createdAt: DateTime.parse('2022-06-11 20:17:02'),
    //   availableKwh: 60.5,
    //   addedKwh: 10,
    //   addedKwhPrice: 14870,
    // ),

    // for performance benchmarking
    // for (int i = 0; i < 100; i++)
    //   Record(
    //     createdAt:
    //         DateTime.parse('2022-06-11 20:17:02').add(Duration(days: i + 1)),
    //     availableKwh: 60.5,
    //   )
  ];

  List<Record> getCurrentRecords() {
    return records;
  }
}
