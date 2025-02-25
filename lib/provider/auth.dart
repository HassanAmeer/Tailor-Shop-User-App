import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login.dart';
import '../models/authmodel.dart';
import '../models/itemModel.dart';
import '../screens/homepage.dart';
import '../storage/config.dart';
import '../storage/userstorage.dart';
import '../widgets/intro.dart';
import '../widgets/toast.dart';

class AuthVm with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoadingF(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthModel? _user;
  AuthModel get userProfile => _user!;
  Future<AuthModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(UserStorage.uidKey).toString();
    final profileImage =
        prefs.getString(UserStorage.profileImageKey).toString();
    final name = prefs.getString(UserStorage.nameKey).toString();
    final phone = prefs.getString(UserStorage.phoneKey).toString();
    final schoolName = prefs.getString(UserStorage.phoneKey).toString();
    final email = prefs.getString(UserStorage.emailKey).toString();
    final password = prefs.getString(UserStorage.passKey).toString();
    _user = AuthModel.fromJson({
      "uid": uid,
      "profileImage": profileImage,
      "name": name,
      "email": email,
      "phone": phone,
      "schoolName": schoolName,
      "password": password
    });
    notifyListeners();
    return _user;
  }

  Future loginF(context, {String email = "", String password = ""}) async {
    isLoadingF = true;

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        snackBarColorF("🛜 Network Not Available", context);
        return;
      }

      if (email.isEmpty) {
        snackBarColorF("Email is required", context);
        return;
      }
      if (password.isEmpty) {
        snackBarColorF("Password is required", context);
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      if (userDoc.exists) {
        _user = AuthModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }

      await UserStorage.setUserF(
        uid: userCredential.user!.uid.toString(),
        profileImage: _user!.profileImage.toString(),
        email: _user!.email.toString(),
      );
      // notifyListeners();
      EasyLoading.showSuccess("Login Successfully");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: $e");
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User not found";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'user-disabled':
          errorMessage = "User account has been disabled";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Try again later";
          break;
        case 'invalid-credential':
          errorMessage =
              "Invalid credentials. Please check your email and password.";
          break;
        case 'network-request-failed':
          errorMessage = "Please check your network connection.";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
          break;
      }
      // snackBarColorF(errorMessage, context);
      EasyLoading.showError(errorMessage.toString());
    } catch (e, st) {
      debugPrint("💥 error: $e , st:$st");
      snackBarColorF("$e", context);
    } finally {
      isLoadingF = false;
    }
  }

  Future signupF(
    context, {
    String name = "",
    String phone = "",
    String schoolName = "",
    String email = "",
    String password = "",
  }) async {
    isLoadingF = true;

    try {
      await Config().setConfig(isVFirstTime: false);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        snackBarColorF("🛜 Network Not Available", context);
        return;
      }
      if (name.isEmpty) {
        snackBarColorF("Name is required", context);
        return;
      }

      if (phone.isEmpty) {
        snackBarColorF("Phone is required", context);
        return;
      }

      if (email.isEmpty) {
        snackBarColorF("Email is required", context);
        return;
      }
      if (password.isEmpty) {
        snackBarColorF("Password is required", context);
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'profileImage':
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq3t9dFOmI3lGU6fDJmGn3cagEbJwaqiOi9YKw1lyGxGZ_T1QLEx7-hlt5DpVd-vDEBb8&usqp=CAU",
        'name': name,
        'email': email,
        'phone': phone,
        'schoolName': schoolName,
        'password': password,
        'uid': userCredential.user!.uid,
      });

      // snackBarColorF("Signup Successfully", context);
      EasyLoading.showSuccess("Signup Successfully");
      await UserStorage.setUserF(
        uid: userCredential.user!.uid.toString(),
        profileImage:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq3t9dFOmI3lGU6fDJmGn3cagEbJwaqiOi9YKw1lyGxGZ_T1QLEx7-hlt5DpVd-vDEBb8&usqp=CAU",
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      notifyListeners();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e, st) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            snackBarColorF("Signup Failed: Invalid Email Format", context);
            break;
          case 'email-already-in-use':
            snackBarColorF("Signup Failed: Email Already In Use", context);
            break;
          case 'weak-password':
            snackBarColorF("Signup Failed: Password is Too Weak", context);
            break;
          case 'operation-not-allowed':
            snackBarColorF("Signup Failed: Operation Not Allowed", context);
            break;
          case 'network-request-failed':
            snackBarColorF("Please check your network connection.", context);
            break;
          default:
            snackBarColorF("Signup Failed: ${e.message}", context);
            break;
        }
      } else {
        snackBarColorF("Signup Failed: Try Again", context);
      }
      debugPrint("💥 error: $e , st:$st");
    } finally {
      isLoadingF = false;
    }
  }

  ////////////////////////////////////////////////
  ////////////////////////////////////////////////
  ////////////////////////////////////////////////
  ////////////////////////////////////////////////
  bool show_banner = false;
  bool introShow = false;
  bool show_contact_number = false;

  ///
  String contact_us_number = "";
  String contact_us_text =
      'If you have any questions, feel free to reach out to us. We are here to help you!';
  String banner =
      "https://www.shutterstock.com/shutterstock/photos/1447117268/display_1500/stock-vector-back-to-school-sale-banner-with-kids-vector-illustration-flat-design-1447117268.jpg";
  String app_icon =
      "https://github.com/HassanAmeer/Emergency-Flutter-App/blob/main/logo.png";
  String splash_icon =
      "https://github.com/HassanAmeer/Emergency-Flutter-App/blob/main/textlogo.png";
  String app_name = "Three Star World";

  List<IntroDataModel> introData = [
    IntroDataModel(
        image:
            'https://lh4.googleusercontent.com/proxy/hQisSV-q3a3910Fo29TcCVN_yRMVBQNio5KWdNh3rs2Pcejx6FL1TG5rqY4RBN1XhttmoMsiL_WTpBFcJvvrZ7Wri8UuMpUn-Dv9C59Sv8Q0Pnb7LlA',
        title: 'Measure and Design',
        description:
            "Your measurements and designs are protected with top-notch security measures. Rest assured that your data is safe and confidential."),
    IntroDataModel(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPukiDaL31WVsydLveaHzGesAueIDWe33OlSGAUlOf9lpgFo4IJ_z3NpajfWXgdV0nUYs&usqp=CAU',
        title: 'Secure',
        description:
            "Your measurements and designs are protected with top-notch security measures. Rest assured that your data is safe and confidential."),
    IntroDataModel(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1yKJqOsdgFNTuilOW8YGDXoS8vU20FqXCZbYlxtzEVi53hoI95xq02faJWqJQPL2RBPo&usqp=CAU',
        title: 'Easy to Use',
        description:
            'Our user-friendly interface makes managing your measurements and designs simple and efficient. Get started in just a few clicks.'),
  ];

  Future<void> getAppSettingsF() async {
    try {
      QuerySnapshot<Map<String, dynamic>> keysSnapshot =
          await FirebaseFirestore.instance.collection("app_settings").get();

      if (keysSnapshot.docs.isNotEmpty) {
        // for (var doc in keysSnapshot.docs) {
        //   debugPrint(" 👉 ${doc.data()}");
        // }

        var app = keysSnapshot.docs[0].data(); // by keys
        app_icon = app['app_icon'].toString();
        app_name = app['app_name'].toString();
        splash_icon = app['splash_icon'].toString();
        banner = app['banner'].toString();
        show_banner = app['show_banner'] as bool;
        show_contact_number = app['show_contact_number'] as bool;
        contact_us_text = app['contact_us_text'].toString();
        contact_us_number = app['contact_us_number'].toString();

        var intro = keysSnapshot.docs[1].data(); // by keys
        introShow = intro['show'] as bool;

        if (introShow) {
          introData = [];
          for (var i = 0; i < (intro['intro'] as List).length; i++) {
            // debugPrint("intro data: ${intro['intro']}");
            introData.add(IntroDataModel(
                image: intro['intro'][i]['image'].toString(),
                title: intro['intro'][i]['title'].toString(),
                description: intro['intro'][i]['desc'].toString()));
          }
        }
      } else {}
      debugPrint(" 👉 ${keysSnapshot.docs}");
      notifyListeners();
    } catch (e, st) {
      debugPrint("💥 Error retrieving App Settings: $e, st:$st");
      notifyListeners();
    } finally {
      isLoadingF = false;
      notifyListeners();
    }
  }

  List<ItemModel> itemsList = [];
  Future<void> getItmesF() async {
    try {
      QuerySnapshot<Map<String, dynamic>> keysSnapshot =
          await FirebaseFirestore.instance.collection("items").get();

      if (keysSnapshot.docs.isNotEmpty) {
        itemsList = [];
        for (var doc in keysSnapshot.docs) {
          itemsList.add(ItemModel.fromMap(doc.data()));
        }
      }
      debugPrint(" 👉 ${keysSnapshot.docs}");
      notifyListeners();
    } catch (e, st) {
      debugPrint("💥 Error retrieving App Settings: $e, st:$st");
      notifyListeners();
    } finally {
      isLoadingF = false;
      notifyListeners();
    }
  }

  ///
}
