import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/demand.dart';

// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
class DemandDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDemand(Demand demand) async {
    try {
      await _firestore.collection('demands').doc(demand.id).set(demand.toMap());
    } catch (e) {
      throw Exception('Failed to add demand: $e');
    }
  }

  Future<List<Demand>> getDemands() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('demands')
          .orderBy('dateDA', descending: true)
          .get();
      List<Demand> demands = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return Demand.fromMap(data, doc.id);
        } else {
          throw Exception('Document data is null');
        }
      }).toList();
      return demands;
    } catch (e) {
      throw Exception('Failed to get demands: $e');
    }
  }

  Future<void> updateDemand(Demand demand) async {
    try {
      await _firestore
          .collection('demands')
          .doc(demand.id)
          .update(demand.toMap());
    } catch (e) {
      throw Exception('Failed to update demand: $e');
    }
  }

  Future<void> deleteDemand(String id) async {
    try {
      await _firestore.collection('demands').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete demand: $e');
    }
  }
}
