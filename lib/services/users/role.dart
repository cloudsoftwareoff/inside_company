import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/role_model.dart';

class RoleService {
  final CollectionReference rolesCollection =
      FirebaseFirestore.instance.collection('roles');

  Future<List<RoleModel>> fetchRoles() async {
    try {
      QuerySnapshot querySnapshot = await rolesCollection.get();
      List<RoleModel> roles = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return RoleModel(
          id: doc.id,
          name: data['name'] ?? '',
          permission: data['permission'] ?? '',
        );
      }).toList();
      return roles;
    } catch (e) {
      print("Error fetching roles: $e");
      throw Exception('Failed to load roles');
    }
  }
}
