import 'package:cloud_firestore/cloud_firestore.dart';

class Region {
  String id;
  String name;
  String address;
  Region({required this.id, required this.name, required this.address});

  factory Region.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Region(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }
}