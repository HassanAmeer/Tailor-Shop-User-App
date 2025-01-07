import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/authmodel.dart';
import '../models/chatModel.dart';
import '../models/itemModel.dart';
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

  Future<void> updateUserProfileF(context,
      {String uid = "",
      String email = "",
      String name = "",
      String phone = ""}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        snackBarColorF("🛜 Network Not Available", context);
        return;
      }
      if (uid.isEmpty) {
        snackBarColorF("Select User", context);
        return;
      }
      if (email.isEmpty) {
        snackBarColorF("Email is required", context);
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

      await _firestore.collection('users').doc(uid).update({
        'email': email,
        'name': name,
        'phone': phone,
      });

      snackBarColorF("Profile updated successfully", context);
    } catch (e) {
      snackBarColorF("Error updating profile: $e", context);
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
  String app_name = "Tailor";

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

  List<AuthModel> usersList = [];
  Future<void> getUsersListF() async {
    try {
      isLoadingF = true;
      notifyListeners();
      QuerySnapshot<Map<String, dynamic>> keysSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      if (keysSnapshot.docs.isNotEmpty) {
        usersList = [];
        for (var doc in keysSnapshot.docs) {
          usersList.add(AuthModel.fromJson(doc.data()));
        }
      }
      debugPrint(" 👉 getUsersListF  ${keysSnapshot.docs}");
      isLoadingF = false;
      notifyListeners();
    } catch (e, st) {
      debugPrint("💥 Error retrieving App Settings: $e, st:$st");
      notifyListeners();
    } finally {
      isLoadingF = false;
      notifyListeners();
    }
  }

  List<ChatModel> getChatsList = [];
  Future<void> getChatsListF() async {
    try {
      isLoadingF = true;
      notifyListeners();
      final database =
          FirebaseDatabase.instance.ref().child("users_chats").get();
      await database.then((snapshot) {
        if (snapshot.exists) {
          getChatsList = [];
          for (var child in snapshot.children) {
            final value = Map<String, dynamic>.from(child.value as Map);
            getChatsList.add(ChatModel.fromMap(value));
          }
        }
      });

      debugPrint(" 👉 getChatsListF  $getChatsList");
      isLoadingF = false;
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
      isLoadingF = true;
      notifyListeners();
      QuerySnapshot<Map<String, dynamic>> keysSnapshot =
          await FirebaseFirestore.instance.collection("items").get();

      if (keysSnapshot.docs.isNotEmpty) {
        itemsList = [];
        for (var doc in keysSnapshot.docs) {
          itemsList.add(ItemModel.fromMap({...doc.data(), 'id': doc.id}));
        }
      }
      debugPrint(" 👉 getItmesF ${keysSnapshot.docs}");
      isLoadingF = false;
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

class IntroDataModel {
  final String image;
  final String title;
  final String description;

  IntroDataModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
