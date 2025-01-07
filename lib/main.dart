import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/appColors.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'provider/auth.dart';
import 'screens/splashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dal3uq1y5");
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
        title: "Tailor Admin",
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




// Platform  Firebase App Id
// android   1:102183749136:android:2ea5ad04edc4db617f2c95
// ios       1:102183749136:ios:ea64450fef1bec827f2c95







