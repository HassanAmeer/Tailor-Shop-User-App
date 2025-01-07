import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailor_admin/screens/homePage.dart';
// import 'package:tailor_admin/homepage.dart';
import '../constants/appColors.dart';
import '../constants/appImages.dart';
import '../provider/auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    try {
      await Provider.of<AuthVm>(context, listen: false).getAppSettingsF();

      Timer(const Duration(seconds: 1), () async {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            transitionDuration: const Duration(seconds: 2),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child)));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Image.asset(AppImages.textLogo,
                          fit: BoxFit.cover, width: 200)),
                  const SizedBox(height: 0),
                  Text("Admin App",
                          style: GoogleFonts.agbalumo(
                              color: Colors.black, fontSize: 30))
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          color: Colors.red, duration: Duration(seconds: 2)),
                  SizedBox(
                      width: 220,
                      child: Opacity(
                          opacity: 0.3,
                          child: LinearProgressIndicator(
                              color: AppColors.primaryColor,
                              minHeight: 2,
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.3))))
                ])));
  }
}
