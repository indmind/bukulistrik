import 'package:bukulistrik/domain/models/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

extension DocRecordsExtension on DocumentReference {
  CollectionReference<Map<String, dynamic>> get records =>
      collection('records');
}

class RecordRepository extends GetxService {
  final FirebaseFirestore db;

  final RxnString _houseId = RxnString();

  RecordRepository(this.db);

  void setHouseId(String? houseId) {
    _houseId.value = houseId;
  }

  /// [DocumentReference] should be referencing houses/{houseId}
  DocumentReference get house => _houseId.value == null
      ? db.collection('temp_records').doc()
      : db.collection('houses').doc(_houseId.value);

  Future<void> addRecord(Record record) async {
    house.records.add(record.toJson());
  }

  Future<void> updateRecord(Record record) async {
    house.records.doc(record.id).update(record.toJson());
  }

  Future<void> deleteRecord(Record record) async {
    house.records.doc(record.id).delete();
  }

  Future<Record?> getRecord(String id) async {
    final doc = await house.records.doc(id).get();

    if (doc.exists) {
      return Record.fromJson(doc.data()!).withId(doc.id);
    }

    return null;
  }

  Future<List<Record>> getRecords() async {
    final snapshot = await house.records.get();

    return snapshot.docs.map((doc) {
      return Record.fromJson(doc.data()).withId(doc.id);
    }).toList();
  }

  // stream data
  Stream<List<Record>> getRecordsStream() {
    return house.records.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Record.fromJson(doc.data()).withId(doc.id);
      }).toList();
    });
  }
}
