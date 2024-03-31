import 'package:cloud_firestore/cloud_firestore.dart';

class Opportunity {
  final String id;
  final String addedby;
  String name;
  String content;
  String status;
  //final Timestamp timestamp;
  String? letter_link;
  Opportunity({
    required this.id,
    required this.addedby,
    required this.name,
    required this.content,
    required this.status,
    // this.timestamp,
    this.letter_link,
  });
}
