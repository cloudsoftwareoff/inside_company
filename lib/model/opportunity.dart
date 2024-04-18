import 'package:cloud_firestore/cloud_firestore.dart';

class Opportunity {
  final String id;
  final String addedBy;
  String title;
  String description;
  List<String> material;
  String status;
  double budget;
  String region;
  final Timestamp? timestamp;
  final Timestamp? lastModified;
  String? letter_link;

  Opportunity({
    required this.id,
    required this.addedBy,
    required this.title,
    required this.description,
    required this.status,
    required this.budget,
    required this.material, // Updated parameter name: materials
    this.timestamp,
    this.lastModified,
    this.letter_link,
    required this.region
  });

  Map<String, dynamic> toMap() {
    return {
      'addedBy': addedBy,
      'title': title,
      'description': description,
      'material': material, // Updated parameter name: materials
      'status': status,
      'budget': budget,
      'timestamp': timestamp,
      'lastModified': lastModified,
      'letter_link': letter_link,
      'region':region
    };
  }

  static Opportunity fromMap(Map<String, dynamic> map, String id) {
    return Opportunity(
      id: id,
      addedBy: map['addedBy'],
      title: map['title'],
      description: map['description'],
      material: List<String>.from(map['material'] ?? []),
      status: map['status'],
      budget: map['budget'],
      timestamp: map['timestamp'],
      lastModified: map['lastModified'],
      letter_link: map['letter_link'],
      region: map['region']
    );
  }
}
