import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/region.dart';

class RegionDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'region';

  Future<List<Region>?> fetchRegion() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      List<Region> regions = [];
      snapshot.docs.forEach((doc) {
        regions.add(Region(
            id: doc['id'] ?? 'null',
            name: doc["name"] ?? 'null',
            address: doc['address'] ?? 'unknown'));
      });
      return regions;
    } catch (e) {
      return null;
    }
  }

  Future<Region?> fetchRegionById(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection(_collectionName).doc(id).get();
      if (snapshot.exists) {
        return Region(
          id: snapshot.id,
          name: snapshot['name'] ?? 'null',
          address: snapshot['address'] ?? 'unknown',
        );
      } else {
        print('Region with ID $id not found');
        return null;
      }
    } catch (e) {
      print('Error fetching region by ID: $e');
      return null;
    }
  }
}
