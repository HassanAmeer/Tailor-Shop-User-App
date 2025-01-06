import 'package:shared_preferences/shared_preferences.dart';
import '../models/authModel.dart';

class UserStorage {
  static const String uidKey = 'uid';
  static const String profileImageKey = 'profileImage';
  static const String nameKey = 'pname';
  static const String emailKey = 'pname';
  static const String phoneKey = 'pname';
  static const String schoolNameKey = 'schoolname';
  static const String passKey = 'pname';

  static Future<void> setUserF(
      {String uid = "",
      String profileImage = "",
      String name = "",
      String email = "",
      String phone = "",
      String schoolName = "",
      String password = ""}) async {
    await SharedPreferences.getInstance().then((prefs) {
      if (uid.isNotEmpty) {
        prefs.setString(uidKey, uid);
      }
      if (profileImage.isNotEmpty) {
        prefs.setString(profileImageKey, profileImage);
      }
      if (name.isNotEmpty) {
        prefs.setString(nameKey, name);
      }
      if (email.isNotEmpty) {
        prefs.setString(emailKey, email);
      }
      if (phone.isNotEmpty) {
        prefs.setString(phoneKey, phone);
      }
      if (schoolName.isNotEmpty) {
        prefs.setString(schoolNameKey, schoolName);
      }
      if (password.isNotEmpty) {
        prefs.setString(passKey, password);
      }
    });
  }

  static Future<AuthModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(uidKey).toString();
    final profileImage = prefs.getString(profileImageKey).toString();
    final name = prefs.getString(nameKey).toString();
    final email = prefs.getString(emailKey).toString();
    final phone = prefs.getString(phoneKey).toString();
    final schoolName = prefs.getString(schoolNameKey).toString();
    final pass = prefs.getString(passKey).toString();

    return AuthModel(
      uid: uid,
      profileImage: profileImage,
      name: name,
      email: email,
      schoolName: schoolName,
      password: pass,
      phone: phone,
    );
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
