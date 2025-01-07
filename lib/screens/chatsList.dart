import 'package:tailor_admin/screens/chats.dart';
import 'package:tailor_admin/widgets/dotloader.dart';

import '../provider/auth.dart';
import '../constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    AuthVm p = Provider.of<AuthVm>(context, listen: false);
    if (p.usersList.isEmpty) {
      await p.getUsersListF();
    }
    await p.getChatsListF();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(title: Text("Chats List")),
          body: p.isLoading
              ? DotLoader(color: AppColors.primaryColor)
              : p.getChatsList.isEmpty
                  ? Center(child: Text("Empty"))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: p.usersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var user = p.usersList[index];
                        // Filter messages for the current user
                        var userMessages = p.getChatsList
                            .where((chat) => chat.uid == user.uid)
                            .toList();

                        if (userMessages.isEmpty) {
                          return SizedBox
                              .shrink(); // Skip users with no messages
                        }

                        // Get the latest message for the user
                        var latestMessage =
                            userMessages.last.msg ?? "No message available";

                        return ListTile(
                            leading: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 37,
                              height: 37,
                              imageUrl: user.profileImage.toString(),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator.adaptive(
                                      strokeWidth: 2),
                            ),
                            title: Text(user.name),
                            subtitle: Text(latestMessage),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatsPage(user: user)));
                            });
                      }));
    });
  }
}
