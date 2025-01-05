import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tailershop/constants/appColors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../constants/appImages.dart';
import '../provider/auth.dart';
import '../widgets/dotloader.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _messageController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users_chats");
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  Future<void> _sendMessage(p) async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a message")));
      return;
    }

    final message = _messageController.text.trim();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _dbRef.push().set({
      "msg": message,
      "timestamp": timestamp,
      "from": "user",
      "uid": p.userProfile.uid,
      "profileImage": p.userProfile.profileImage,
    });

    // if(mounted) {
    // _messageController.clear();
    // _chatScrollController.animateTo(
    //   _chatScrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );}
  }

  syncFirstF() async {
    // var user = await Provider.of<AuthVm>(context).userProfile;
    // if (user.uid.isEmpty) {
    //   var user = await Provider.of<AuthVm>(context).getUserData();
    //   currentUserId = user!.uid;
    // } else {
    //   currentUserId = user.uid;
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              title: const Text('Live Chats',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              actions: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(AppImages.chatIcon,
                        color: AppColors.primaryColor.shade100))
              ],
              backgroundColor: AppColors.primaryColor,
              elevation: 0),
          body: Column(children: [
            Expanded(
                child: StreamBuilder(
                    stream: _dbRef
                        .orderByChild("timestamp")
                        // .equalTo(p.userProfile.uid, key: "uid")
                        .onValue,
                    // stream: _dbRef.orderByChild("timestamp").onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: DotLoader(
                                color: AppColors.primaryColor.shade100));
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        final data = (snapshot.data!).snapshot.value
                            as Map<dynamic, dynamic>?;

                        if (data == null) {
                          return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Image.asset(AppImages.chatIcon,
                                        color: AppColors.primaryColor.shade100,
                                        opacity:
                                            const AlwaysStoppedAnimation(0.3))),
                                const Center(
                                    child: Text("No messages yet",
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))
                              ])
                              .animate(
                                  delay: 500.ms,
                                  onPlay: (controller) => controller.repeat())
                              .shimmer(
                                  duration: const Duration(milliseconds: 1500),
                                  delay: const Duration(milliseconds: 1000))
                              .shimmer(
                                  color: AppColors.primaryColor.shade100
                                      .withOpacity(0.3),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInOut);
                        }

                        final messages = data.entries.toList()
                          ..sort((a, b) => a.value["timestamp"]
                              .compareTo(b.value["timestamp"]));

                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                                controller: _chatScrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final chat = messages[index].value;
                                  final isAdmin =
                                      chat["uid"] == p.userProfile.uid &&
                                          chat["from"] == "admin";

                                  return isAdmin
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                              InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .orange.shade100
                                                          .withOpacity(0.6),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              width: 37,
                                                              height: 37,
                                                              imageUrl: "https://www.creativefabrica.com/wp-content/uploads/2021/06/02/Admin-Roles-Icon-Graphics-12796525-1.jpg",
                                                                 
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons.person_4, color: Colors.orange),
                                                              placeholder: (context, url) => const CircularProgressIndicator.adaptive(strokeWidth: 2))))),
                                              BubbleSpecialOne(
                                                  text: chat['msg'].toString(),
                                                  isSender: false,
                                                  color: Colors.orange.shade100,
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ])
                                      : (chat["uid"] == p.userProfile.uid &&
                                              chat["from"] == "user")
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                  BubbleSpecialOne(
                                                      text: chat['msg']
                                                          .toString(),
                                                      isSender: true,
                                                      color: AppColors
                                                          .primaryColor.shade100
                                                          .withOpacity(0.6),
                                                      textStyle: TextStyle(
                                                          color: AppColors
                                                              .primaryColor
                                                              .shade700,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      onTap: () {},
                                                      child: CircleAvatar(
                                                          backgroundColor: AppColors
                                                              .primaryColor
                                                              .shade100
                                                              .withOpacity(0.6),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      50),
                                                              child: CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 37,
                                                                  height: 37,
                                                                  imageUrl: context
                                                                          .read<
                                                                              AuthVm>()
                                                                          .userProfile
                                                                          .profileImage
                                                                          .isEmpty
                                                                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq3t9dFOmI3lGU6fDJmGn3cagEbJwaqiOi9YKw1lyGxGZ_T1QLEx7-hlt5DpVd-vDEBb8&usqp=CAU"
                                                                      : context
                                                                          .read<AuthVm>()
                                                                          .userProfile
                                                                          .profileImage,
                                                                  errorWidget: (context, url, error) => const Icon(Icons.person, color: AppColors.primaryColor),
                                                                  placeholder: (context, url) => const CircularProgressIndicator.adaptive(strokeWidth: 2)))))
                                                ])
                                          : Text("");
                                }));
                      }

                      return const Center(child: Text("No messages yet"));
                    })),
            Padding(
                padding: const EdgeInsets.all(14),
                child: Expanded(
                    child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: AppColors.primaryColor),
                                onPressed: () {
                                  _sendMessage(
                                    p,
                                  );
                                })))))
          ]));
    });
  }
}
