import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tailershop/provider/auth.dart';
import 'package:tailershop/widgets/dotloader.dart';
import '../auth/login.dart';
import '../constants/appImages.dart';
import '../storage/config.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Column(children: [
            Expanded(
                child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: p.introData.length,
                    // itemCount: introDataModel.length,
                    itemBuilder: (context, index) {
                      return _IntroPageItem(data: p.introData[index]);
                    })),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentIndex > 0)
                          TextButton(
                              onPressed: () {
                                _controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: const Text('Prev',
                                  style: TextStyle(color: Colors.indigo)))
                        else
                          const SizedBox(width: 60),
                        Row(
                            children: List.generate(
                                p.introData.length,
                                (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: _currentIndex == index
                                                ? Colors.indigo
                                                : Colors.grey[300],
                                            shape: BoxShape.circle))))),
                        if (_currentIndex < p.introData.length - 1)
                          TextButton(
                              onPressed: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: const Text('Next',
                                  style: TextStyle(color: Colors.indigo)))
                        else
                          const SizedBox(width: 60)
                      ]),
                  const SizedBox(height: 20),
                  if (_currentIndex == p.introData.length - 1)
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Config().setConfig(isVFirstTime: true);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: const Text('Continue',
                                style: TextStyle(color: Colors.white))))
                ]))
          ])));
    });
  }
}

class _IntroPageItem extends StatelessWidget {
  const _IntroPageItem({required this.data});

  final IntroDataModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Image Section
          Expanded(
              flex: 5,
              child: CachedNetworkImage(
                  imageUrl: data.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return Icon(Icons.image_sharp,
                            size: 300, color: Colors.grey.shade200)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(color: Colors.white, duration: 2.seconds);
                  },
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(AppImages.dress1, fit: BoxFit.contain);
                  })),

          const SizedBox(height: 30),

          // Title
          Text(data.title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
              textAlign: TextAlign.center),

          const SizedBox(height: 15),

          // Description
          Text(data.description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Model class for intro data
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
