class UserModel {
  final String uid;
  final String fullname;
  final String email;
  final String role;
  final Map<String, dynamic>? address;
  final int id;

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.role,
    this.address,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "role": role,
      "address": address,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      fullname: map["fullname"],
      email: map["email"],
      role: map["role"],
      address: map["address"],
      id: map['id'] ?? 0,
    );
  }
}
