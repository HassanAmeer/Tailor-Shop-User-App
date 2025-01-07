import 'package:tailor_admin/helpers/nullables.dart';

class ChatModel {
  final String user;
  final String msg;
  final String profileImage;
  final String timestamp;
  final String uid;

  ChatModel({
    this.user = "",
    this.msg = "",
    this.profileImage = "",
    this.timestamp = "",
    this.uid = "",
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      user: data['user'].toString().toNullString(),
      msg: data['msg'].toString().toNullString(),
      profileImage: data['profileImage'].toString().toNullString(),
      timestamp: data['timestamp'].toString().toNullString(),
      uid: data['uid'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'msg': msg,
      'profileImage': profileImage,
      'timestamp': timestamp,
      'uid': uid,
    };
  }
}

// Example usage:
final chat = ChatModel(
  user: "user",
  msg: "want to buy uniform",
  profileImage:
      "https://res.cloudinary.com/dal3uq1y5/image/upload/v1736066205/profile_images/1736066203186.jpg",
  timestamp: "1736077150241",
  uid: "ojtMqKGl7gOXSFmOLUOgLC3acRr1",
);
