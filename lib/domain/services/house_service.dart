import 'package:bukulistrik/common/logger.dart';
import 'package:bukulistrik/data/house_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Used to retreive user houses
class HouseService extends GetxService {
  final HouseRepository _houseRepository = Get.find();
  final FirebaseAuth _auth = Get.find();

  final RxnString activeHouse = RxnString();

  final RxList<String> availableHouses = RxList<String>();

  DocumentReference? get activeHouseRef => activeHouse.value == null
      ? null
      : _houseRepository.collection.doc(activeHouse.value);

  @override
  void onInit() {
    super.onInit();

    _auth.userChanges().listen(_fetchHouses);
  }

  void _fetchHouses(User? user) async {
    Logger.d('HouseService._fetchHouses');

    if (user == null) {
      availableHouses.clear();
      activeHouse.value = null;

      Logger.d('HouseService._fetchHouses: user is null');
      return;
    }

    List<String> houses = await _houseRepository.getHousesFor(user);

    if (houses.isEmpty) {
      Logger.d('HouseService._fetchHouses: user has no house, creating one');

      _houseRepository.createHouse(user);

      houses = await _houseRepository.getHousesFor(user);

      Logger.d('HouseService._fetchHouses: done creating house');
    }

    availableHouses.value = houses;
    Logger.d('HouseService._fetchHouses: availableHouses: $availableHouses');

    activeHouse.value = houses.isNotEmpty ? houses.first : null;
  }
}
