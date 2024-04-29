// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
class UserModel {
  final String uid;
  String username;
  final String roleId;
  String picture;
  String email;
  String region;
  bool? isActive;
  String? verified = "no";

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.picture,
      required this.roleId,
      required this.region,
      this.isActive=true,
      this.verified});
}
