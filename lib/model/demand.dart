import 'package:cloud_firestore/cloud_firestore.dart';

class Demand {
  String id;
  String opportunityId;
  double budget;
  Timestamp dateDA;
  List<String> materials;
  String state;
  String region;

  Demand({
    required this.id,
    required this.opportunityId,
    required this.budget,
    required this.materials,
    required this.dateDA,
    required this.state,
    required this.region
  });

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'budget': budget,
      'materials': materials,
      'dateDA': dateDA,
      'state': state,
      'region':region
    };
  }

  static Demand fromMap(Map<String, dynamic> map, String id) {
    return Demand(
      id: id,
      opportunityId: map['opportunityId'],
      budget: map['budget'],
      materials: List<String>.from(map['materials'] ?? []),
      dateDA: map['dateDA'],
      state: map['state'],
      region: map['region']
    );
  }
}
