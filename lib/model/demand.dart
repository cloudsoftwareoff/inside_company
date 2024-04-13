import 'package:cloud_firestore/cloud_firestore.dart';

class Demand {
  String id;
  String opportunityId;
  double budget;
  Timestamp dateDA;
  String state;

  Demand(
      {required this.id,
      required this.opportunityId,
      required this.budget,
      required this.dateDA,
      required this.state});

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'budget': budget,
      'dateDA': dateDA,
      'state': state
    };
  }

  static Demand fromMap(Map<String, dynamic> map, String id) {
    return Demand(
        id: id,
        opportunityId: map['opportunityId'],
        budget: map['budget'],
        dateDA: map['dateDA'],
        state: map['state']);
  }
}
