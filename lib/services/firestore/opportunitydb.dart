import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/opportunity.dart';

class OpportunityDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'opportunities';

  Future<void> addOpportunity(Opportunity opportunity) async {
    try {
      await _firestore.collection(_collectionName).doc(opportunity.id).set({
        'id': opportunity.id,
        'addedby': opportunity.addedby,
        'name': opportunity.name,
        'content': opportunity.content,
        'status': opportunity.status,
        'letter_link': opportunity.letter_link,
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
          addedby: doc['addedby'],
          name: doc['name'],
          content: doc['content'],
          status: doc['status'],
          letter_link: doc['letter_link'],
        ));
      });
      return opportunities;
    } catch (e) {
      print('Error fetching opportunities: $e');
      throw e;
    }
  }
}
