import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/appColors.dart';
import '../constants/appImages.dart';
import '../provider/auth.dart';
import '../widgets/dotloader.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primaryColor,
              title:
                  const Text('Three Star World', style: TextStyle(color: Colors.white))),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                              width: 180,
                              imageUrl: p.app_icon.toString(),
                              placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Icon(Icons.image,
                                              size: 140,
                                              color: Colors.grey.shade100)
                                          .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat())
                                          .shimmer(
                                              color: Colors.grey.shade300,
                                              duration: Duration(seconds: 2)))),
                              errorWidget: (context, url, error) => Image.asset(
                                  AppImages.logo,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4)),
                          const SizedBox(height: 70),
                          TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.grey),
                                  hintText: 'Email',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          const SizedBox(height: 20),
                          TextField(
                              obscureText: showPass,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.password,
                                      color: Colors.grey),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPass = !showPass;
                                        });
                                      },
                                      icon: showPass
                                          ? const Icon(Icons.visibility_off,
                                              color: Colors.grey)
                                          : const Icon(Icons.visibility,
                                              color: Colors.grey)),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () async {
                                    await p.loginF(context,
                                        email: emailController.text,
                                        password: passwordController.text);
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      child: p.isLoading
                                          ? const DotLoader(color: Colors.white)
                                          : Text("Login",
                                                  style: GoogleFonts.agbalumo(
                                                      color: Colors.white,
                                                      letterSpacing: 2,
                                                      fontSize: 20))
                                              .animate(
                                                  onPlay: (controller) =>
                                                      controller.repeat())
                                              .shimmer(
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  color: Colors.grey)))),
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignupPage()));
                                    },
                                    child: Text('No account? Sign up',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blueGrey.shade400)))
                              ])
                        ]),
                  ))));
    });
  }
}
