class UserModel {
  final String uid;
  String username;
  final String roleId;
  String picture;
  String email;
  String? verified = "no";

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.picture,
      required this.roleId,
      this.verified});
}
