import 'package:bukulistrik/data/record_repository.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:get/get.dart';

/// This class is used to store records
class RecordService extends GetxService {
  final _repository = RecordRepository(Get.find());

  // Stream of records
  Stream<List<Record>> get recordsStream => _repository.getRecordsStream();

  Future<List<Record>> getCurrentRecords() async {
    // IMPORTANT: send the value, not the reference
    return _repository.getRecords();
  }

  Future<void> save(Record record) async {
    if (record.id == null) {
      await _repository.addRecord(record);
    } else {
      await _repository.updateRecord(record);
    }
  }

  Future<void> delete(Record record) async {
    await _repository.deleteRecord(record);
  }

  Future<void> update(Record record) async {
    await _repository.updateRecord(record);
  }
}

/// This variable stores records
RxList<Record> records = [
  Record(
    id: 'ajrhiuvhj',
    createdAt: DateTime.parse('2022-06-02 18:51:02'),
    availableKwh: 71,
    addedKwh: 67.3,
    addedKwhPrice: 100000,
    note: 'Pembelian awal',
  ),
  Record(
    id: 'ieoijfdf',
    createdAt: DateTime.parse('2022-06-03 18:50:43'),
    availableKwh: 68.87,
  ),
  Record(
    id: 'jhgfhj',
    createdAt: DateTime.parse('2022-06-04 19:19:20'),
    availableKwh: 66.22,
  ),
  Record(
    id: 'asdfeve',
    createdAt: DateTime.parse('2022-06-05 19:44:01'),
    availableKwh: 64.02,
  ),
  Record(
    id: 'asdfevf',
    createdAt: DateTime.parse('2022-06-06 18:41:21'),
    availableKwh: 61.8,
  ),
  Record(
    id: 'asdfevg',
    createdAt: DateTime.parse('2022-06-07 17:40:57'),
    availableKwh: 59.74,
  ),
  Record(
    id: 'asdfevh',
    createdAt: DateTime.parse('2022-06-08 20:10:57'),
    availableKwh: 57.53,
  ),
  Record(
    id: 'asdfevi',
    createdAt: DateTime.parse('2022-06-09 18:17:16'),
    availableKwh: 55.64,
  ),
  Record(
    id: 'asdfevj',
    createdAt: DateTime.parse('2022-06-10 19:33:12'),
    availableKwh: 52.63,
  ),
  Record(
    id: 'asdfevk',
    createdAt: DateTime.parse('2022-06-11 19:33:12'),
    availableKwh: 100,
    addedKwh: 50,
    addedKwhPrice: 80000,
  ),
  // Record(
  //   createdAt: DateTime.parse('2022-06-11 20:17:02'),
  //   availableKwh: 60.5,
  //   addedKwh: 10,
  //   addedKwhPrice: 14870,
  // ),

  // for performance benchmarking
  // for (int i = 0; i < 10000; i++)
  //   Record(
  //     createdAt:
  //         DateTime.parse('2022-06-12 20:17:02').add(Duration(days: i + 1)),
  //     availableKwh: (100 - i).clamp(0, 100).toDouble(),
  //   )
].obs;
