import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/opportunity.dart';
// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
class OpportunityDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'opportunities';

  Future<void> addOpportunity(Opportunity opportunity) async {
    try {
      await _firestore.collection(_collectionName).doc(opportunity.id).set({
        'id': opportunity.id,
        'addedby': opportunity.addedBy,
        'title': opportunity.title,
        'description': opportunity.description,
        'status': opportunity.status,
        'letter_link': opportunity.letter_link ?? "",
        'material': opportunity.material,
        'timestamp': opportunity.timestamp,
        'lastModified': opportunity.lastModified,
        'budget': opportunity.budget,
        'region':opportunity.region
      });
    } catch (e) {
      print('Error adding opportunity: $e');
      throw e;
    }
  }

  Future<List<Opportunity>> fetchOpportunities() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      List<Opportunity> opportunities = [];

      for (var doc in snapshot.docs) {
        List<String> materials =
            doc['material']?.cast<String>() ?? []; // Retrieve materials list

        opportunities.add(Opportunity(
          id: doc['id'],
          addedBy: doc['addedby'],
          title: doc['title'],
          description: doc['description'],
          status: doc['status'],
          timestamp: doc['timestamp'],
          lastModified: doc['lastModified'],
          material: materials,
          region: doc['region'],
          budget: doc['budget'] != null ? doc['budget'] : '-1',
          letter_link: doc['letter_link'],
        ));
      }

      return opportunities;
    } catch (e) {
      print('Error fetching opportunities: $e');
      throw e;
    }
  }

  Future<List<Opportunity>> fetchOpportunitiesByState(String state) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      List<Opportunity> opportunities = [];

      for (var doc in snapshot.docs) {
        List<String> materials = doc['material']?.cast<String>() ?? [];

        if (doc['status'] == state) {
          opportunities.add(Opportunity(
            id: doc['id'],
            addedBy: doc['addedby'],
            title: doc['title'],
            description: doc['description'],
            status: doc['status'],
            letter_link: doc['letter_link'],
            timestamp: doc['timestamp'],
            lastModified: doc['lastModified'],
            region: doc['region'],
            material: materials,
            budget: doc['budget'] ?? -1,
          ));
        }
      }
      return opportunities;
    } catch (e) {
      print('Error fetching opportunities by state: $e');
      throw e;
    }
  }

  Future<void> updateOpportunityStatus(
      String opportunityId, String newStatus, String path) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(opportunityId)
          .update({'status': newStatus, 'letter_link': path});
    } catch (e) {
      print('Error updating opportunity status: $e');
      throw e;
    }
  }
}
