import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/opportunity.dart';

class OpportunityDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'opportunities';

  Future<void> addOpportunity(Opportunity opportunity) async {
    try {
      await _firestore.collection(_collectionName).doc(opportunity.id).set({
        'id': opportunity.id,
        'addedby': opportunity.addedBy,
        'title': opportunity.title,
        'content': opportunity.description,
        'status': opportunity.status,
        'letter_link': opportunity.letter_link,
        'budget': opportunity.budget
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
      snapshot.docs.forEach((doc) {
        opportunities.add(Opportunity(
          id: doc['id'],
          addedBy: doc['addedby'],
          title: doc['name'],
          description: doc['content'],
          status: doc['status'],
          material: doc['material'] ?? [],

          budget: doc['budget'] != null ? doc['budget'] : '-1',
          letter_link: doc['letter_link'],
        ));
      });
      return opportunities;
    } catch (e) {
      print('Error fetching opportunities: $e');
      throw e;
    }
  }

  Future<List<Opportunity>> fetchPendingOpportunities() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      List<Opportunity> opportunities = [];
      for (var doc in snapshot.docs) {
        //  status is "PENDING"
        if (doc['status'] == 'PENDING') {
          opportunities.add(Opportunity(
            id: doc['id'],
            addedBy: doc['addedby'],
            title: doc['name'],
            description: doc['content'],
            status: doc['status'],
            letter_link: doc['letter_link'],
            material: doc['material'] ?? [],
            budget: doc['budget'] ?? '-1',
          ));
        }
      }
      return opportunities;
    } catch (e) {
      print('Error fetching pending opportunities: $e');
      throw e;
    }
  }

  Future<void> updateOpportunityStatus(
      String opportunityId, String newStatus) async {
    try {
      await _firestore.collection(_collectionName).doc(opportunityId).update({
        'status': newStatus,
      });
    } catch (e) {
      print('Error updating opportunity status: $e');
      throw e;
    }
  }
}
