import 'provider/auth.dart';
import 'firebase_options.dart';
import 'screens/splashPage.dart';
import 'constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';

class AgoraChatConfig {
  static const String appKey = "511278b4bc1d45fcbdcab26f62146843";
  static const String userId = "<#Your created user#>";
  static const String agoraToken = "<#User Token#>";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dal3uq1y5");
  // final settingsController = SettingsController(SettingsService());
  // await settingsController.loadSettings();
  // runApp(MyApp(settingsController: settingsController));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthVm>(create: (_) => AuthVm()),
  ], child: const MyApp()));
  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() async {
    await Provider.of<AuthVm>(context, listen: false).getAppSettingsF();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Three Star World",
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primaryColor,
              titleTextStyle: TextStyle(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
              // backgroundColor: AppColors.primaryColor.shade100.withOpacity(0.2),
            ),
            scaffoldBackgroundColor: Colors.white,
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            useMaterial3: true),
        home: const SplashPage(),
        builder: EasyLoading.init());
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.indigoAccent
    ..backgroundColor = Colors.black45
    ..indicatorColor = Colors.indigoAccent
    ..textColor = Colors.indigoAccent
    ..maskColor = Colors.black45
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}













// Cloud name: dal3uq1y5
// API Key
// 191182111899947
// API Secret
// cqOT8xRwcZoaaw9z0bm9bIsQDYE

// API environment variable
// CLOUDINARY_URL=cloudinary://<your_api_key>:<your_api_secret>@dal3uq1y5



// bundle id
// com.three.starworld

// Platform  Firebase App Id
// android   1:102183749136:android:2b203cb206853c317f2c95
// ios       1:102183749136:ios:18b2965581fcacc27f2c95


///////// play store setups
///
// Three Star World

// Explore, shop, and experience the world of Three Star like never before!

// Welcome to Three Star World, your ultimate platform for discovering premium products and services. Our app offers a seamless experience for browsing, purchasing, and engaging with exclusive collections. Whether you're looking for the latest trends, top-tier services, or personalized recommendations, Three Star World brings everything to your fingertips.

// Key Highlights:
// ✔️ Intuitive and user-friendly interface
// ✔️ Seamless navigation for a smooth shopping experience
// ✔️ Exclusive deals, discounts, and promotions
// ✔️ Secure payment options for hassle-free transactions
// ✔️ Personalized recommendations based on your preferences
// ✔️ Reliable customer support to assist with your queries

// Join Three Star World today and elevate your shopping experience!

// policy
// https://doc-hosting.flycricket.io/three-star-world-privacy-policy/58579872-5ef5-4f78-b5a0-4c2c1a17fe2e/privacy
// delete account
// https://form.jotform.com/250351650590048