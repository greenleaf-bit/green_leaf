class UserModel {
  final String uid;
  final String fullname;
  final String email;
  final String role;
  final Map<String, dynamic>? address; // null initially

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.role,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "role": role,
      "address": address, // null save hoga jab register karega
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      fullname: map["fullname"],
      email: map["email"],
      role: map["role"],
      address: map["address"],
    );
  }
}
