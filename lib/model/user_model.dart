

class UserModel {
  final String uid;
  final String username;
  final String roleId;
  final String picture;
  final String email;

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.picture,
      required this.roleId});
}
