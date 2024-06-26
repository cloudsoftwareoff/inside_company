import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside_company/model/user_model.dart';

class UserDB {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUserToDB(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set({
        'uid': user.uid,
        'username': user.username,
        'email': user.email,
        'roleId': user.roleId,
        'picture': user.picture,
        'verified': user.verified,
        'region': user.region,
        'isActive': true
      });
      print('User added to database successfully');
    } catch (e) {
      print('Error adding user to database: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).update({
        'uid': user.uid,
        'username': user.username,
        'email': user.email,
        'roleId': user.roleId,
        'picture': user.picture,
        'region': user.region,
        'verified': user.verified
      });
      print('User updated successfully');
    } catch (e) {
      print('Error updating user to database: $e');
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        return UserModel(
            uid: data['uid'] ?? 'boid',
            email: data['email'] ?? 'no_email',
            username: data['username'] ?? 'no_username',
            picture: data['picture'] ??
                'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg',
            roleId: data['roleId'] ?? '',
            verified: data['verified'] ?? 'no',
            isActive: data['isActive'] ?? true,
            region: data['region'] ?? 'null');
      } else {
        print('User with ID $uid not found.');
        return null;
      }
    } catch (error) {
      print('Error fetching user by ID: $error');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> userList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        UserModel user = UserModel(
            uid: data['uid'] ?? '',
            email: data['email'] ?? '',
            username: data['username'] ?? '',
            picture: data['picture'] ??
                'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg',
            roleId: data['roleId'] ?? '',
            verified: data['verified'] ?? 'no',
            region: data['region'] ?? 'null');

        userList.add(user);
      }
    } catch (error) {
      print('Error fetching all users: $error');
    }

    return userList;
  }

  Future<List<UserModel>> getUsersByRole(String roleId) async {
    List<UserModel> userList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('roleId', isEqualTo: roleId)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        UserModel user = UserModel(
            uid: data['uid'] ?? '',
            email: data['email'] ?? '',
            username: data['username'] ?? '',
            picture: data['picture'] ??
                'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg',
            roleId: data['roleId'] ?? '',
            verified: data['verified'] ?? 'no',
            region: data['region'] ?? 'null');
        userList.add(user);
      }
    } catch (error) {
      print('Error fetching users by role: $error');
    }

    return userList;
  }

  Future<List<UserModel>> getVerifiedUsers(bool verified) async {
    List<UserModel> userList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('verified', isEqualTo: verified ? "yes" : "no")
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        UserModel user = UserModel(
            uid: data['uid'] ?? '',
            email: data['email'] ?? '',
            username: data['username'] ?? '',
            picture: data['picture'] ??
                'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg',
            roleId: data['roleId'] ?? '',
            verified: data['verified'] ?? 'no',
            region: data['region'] ?? 'null');
        userList.add(user);
      }
    } catch (error) {
      print('Error fetching users by role: $error');
    }

    return userList;
  }
}
