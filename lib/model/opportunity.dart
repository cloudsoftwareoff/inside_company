import 'package:cloud_firestore/cloud_firestore.dart';

class Opportunity {
  final String id;
  final String addedBy;
  String title;
  String description;
  List<String> material;
  String status;
  String budget;
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
    required this.material,
    this.timestamp,
    this.lastModified,
    this.letter_link,
  });
}
