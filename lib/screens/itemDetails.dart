import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tailershop/models/itemModel.dart';

import '../constants/appColors.dart';
import 'chats.dart';

class ItemsDetailsPage extends StatelessWidget {
  final ItemModel data;
  const ItemsDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
            title: const Text('Item Details')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  height: 250,
                  width: double.infinity,
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey[300]!.withOpacity(0.3),
                  ),
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: data.image,
                      // imageUrl: p.app_icon.toString(),
                      placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor))),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image))),
              const SizedBox(height: 16.0),
              Text('${data.title}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                      color: Colors.white,
                      duration: const Duration(seconds: 2)),
              const SizedBox(height: 20),
              Text('${data.desc}', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 4),
              Row(children: [
                Row(children: [
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(' Price: ',
                          style: TextStyle(fontSize: 16))),
                  Text("${data.price}")
                ]),
                const Spacer(),
                Row(children: [
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(' Size: ',
                          style: TextStyle(fontSize: 16))),
                  Text("${data.size}")
                ])
              ]),
              Divider(),
            ])),
        floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatsPage()));
                },
                child: const Icon(Icons.chat, color: Colors.white)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                        color: AppColors.orange,
                        duration: Duration(seconds: 2)))
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
                color: Colors.white.withOpacity(0.2),
                duration: Duration(seconds: 2)));
  }
}
