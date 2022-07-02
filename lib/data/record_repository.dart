import 'package:bukulistrik/domain/models/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordRepository {
  final FirebaseFirestore db;

  RecordRepository(this.db);

  Future<void> addRecord(Record record) async {
    await db.collection('records').add(record.toJson());
  }

  Future<void> updateRecord(Record record) async {
    await db.collection('records').doc(record.id).update(record.toJson());
  }

  Future<void> deleteRecord(Record record) async {
    await db.collection('records').doc(record.id).delete();
  }

  Future<Record?> getRecord(String id) async {
    final doc = await db.collection('records').doc(id).get();

    if (doc.exists) {
      return Record.fromJson(doc.data()!).withId(doc.id);
    }

    return null;
  }

  Future<List<Record>> getRecords() async {
    final snapshot = await db.collection('records').get();

    return snapshot.docs.map((doc) {
      return Record.fromJson(doc.data()).withId(doc.id);
    }).toList();
  }

  // stream data
  Stream<List<Record>> getRecordsStream() {
    return db.collection('records').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Record.fromJson(doc.data()).withId(doc.id);
      }).toList();
    });
  }
}
