import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tailershop/helpers/nullables.dart';
import 'package:tailershop/screens/homepage.dart';

import '../auth/login.dart';
import '../constants/appColors.dart';
import '../constants/appImages.dart';
import '../provider/auth.dart';
import '../storage/config.dart';
import '../widgets/intro.dart';

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
      var v = await Config().getConfig();
      var user =
          await Provider.of<AuthVm>(context, listen: false).getUserData();

      if (v!.firstTime.toString() == "false") {
        Timer(const Duration(seconds: 3), () async {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              transitionDuration: const Duration(seconds: 3),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  context.watch<AuthVm>().introShow == true
                      ? const IntroPage()
                      : LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child)));
        });
      } else if (user != null &&
          user.uid.toString().toNullString().isNotEmpty) {
        Timer(const Duration(seconds: 3), () async {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              transitionDuration: const Duration(seconds: 3),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child)));
        });
      } else {
        Timer(const Duration(seconds: 3), () async {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              transitionDuration: const Duration(seconds: 3),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child)));
        });
      }
    } catch (e) {
      debugPrint("💥 UsergetData on splash Error:$e");
      Timer(const Duration(seconds: 3), () async {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            transitionDuration: const Duration(seconds: 3),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const IntroPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child)));
      });
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
            //

            Center(
              child: CachedNetworkImage(
                  width: 250,
                  imageUrl: context.watch<AuthVm>().splash_icon.toString(),
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return Icon(Icons.image_sharp,
                            size: 300, color: Colors.grey.shade200)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(color: Colors.white, duration: 2.seconds);
                  },
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(
                      AppImages.textLogo,
                      fit: BoxFit.cover,
                      width: 200,
                    );
                  }),
            ),
            const SizedBox(height: 0),
            SizedBox(
              width: 220,
              child: Opacity(
                opacity: 0.3,
                child: LinearProgressIndicator(
                  color: AppColors.primaryColor,
                  minHeight: 2,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
