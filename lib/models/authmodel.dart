import 'package:tailor_admin/helpers/nullables.dart';

class AuthModel {
  String uid;
  String profileImage;
  String name;
  String email;
  String phone;
  String schoolName;
  String password;

  AuthModel({
    this.uid = "",
    this.profileImage = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.schoolName = "",
    this.password = "",
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uid: json['uid'].toString().toNullString(),
      profileImage: json['profileImage'].toString().toNullString(),
      name: json['name'].toString().toNullString(),
      email: json['email'].toString().toNullString(),
      password: json['password'].toString().toNullString(),
      phone: json['phone'].toString().toNullString(),
      schoolName: json['schoolName'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profileImage': profileImage,
      'name': name,
      'email': email,
      'phone': phone,
      'schoolName': schoolName,
      'password': password,
    };
  }
}
