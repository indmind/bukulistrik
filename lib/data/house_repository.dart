import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HouseRepository {
  final FirebaseFirestore db;

  HouseRepository(this.db);

  late final collection = db.collection('houses');

  Future<void> createHouse(User user) async {
    collection.add({
      'name': '${user.displayName} House',
      'owner': user.uid,
      'members': [user.uid],
    });
  }

  Future<void> addMember(String houseId, User user) async {
    await collection.doc(houseId).update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
  }

  Future<void> removeMember(String houseId, User user) async {
    await collection.doc(houseId).update({
      'members': FieldValue.arrayRemove([user.uid]),
    });
  }

  Future<void> deleteHouse(String houseId) async {
    await collection.doc(houseId).delete();
  }

  /// For now just return the list of house ID, but later we can add more data like
  ///   - electrical power
  ///   - electronic devices
  ///   - etc
  Future<List<String>> getHousesFor(User user) async {
    final snapshot =
        await collection.where('members', arrayContains: user.uid).get();

    return snapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  }
}
