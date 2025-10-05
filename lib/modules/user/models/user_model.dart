class UserModel {
  final String uid;
  final String fullname;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {"uid": uid, "fullname": fullname, "email": email, "role": role};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      fullname: map["fullname"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "user",
    );
  }
}
