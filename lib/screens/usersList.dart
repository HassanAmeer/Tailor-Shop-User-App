import 'package:direct_call_plus/direct_call_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_admin/models/authmodel.dart';

import '../provider/auth.dart';
import '../constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/dotloader.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    await Provider.of<AuthVm>(context, listen: false).getUsersListF();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(title: Text("Users List")),
          body: p.isLoading
              ? DotLoader(color: AppColors.primaryColor)
              : p.usersList.isEmpty
                  ? Center(child: Text("Empty"))
                  : ListView.separated(
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemCount: p.usersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = p.usersList[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                        user: data,
                                      ),
                                  fullscreenDialog: true),
                            );
                          },
                          leading: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 37,
                              height: 37,
                              imageUrl: data.profileImage,
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator.adaptive(
                                      strokeWidth: 2)),
                          title: Text(data.name),
                          subtitle: Text(data.email),
                        );
                      }));
    });
  }
}

class UserDetails extends StatelessWidget {
  final AuthModel user;

  const UserDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      var data = user;
      return Scaffold(
        appBar: AppBar(title: Text(data.name)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                              imageUrl: data.profileImage,
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor,
                                  size: 100),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator.adaptive(
                                      strokeWidth: 2))))
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                      duration: const Duration(seconds: 2),
                      delay: const Duration(seconds: 1),
                      color: AppColors.primaryColor),
              const SizedBox(height: 50),
              Divider(),
              ListTile(
                title: Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(Icons.mail, size: 18),
                title: Text(data.email, style: const TextStyle(fontSize: 18)),
              ),
              Divider(),
              const SizedBox(height: 5),
              ListTile(
                  leading: const Icon(Icons.phone, size: 18),
                  title: Text(data.phone, style: const TextStyle(fontSize: 18)),
                  trailing: CircleAvatar(
                      child: IconButton(
                          onPressed: () async {
                            await DirectCallPlus.makeCall(data.phone);
                          },
                          icon: Icon(Icons.call)))),
              Divider(),
              ListTile(
                  leading: const Icon(Icons.school, size: 18),
                  subtitle:
                      Text("school name", style: TextStyle(color: Colors.grey)),
                  title: Text(data.schoolName,
                      style: const TextStyle(fontSize: 18))),
              Divider(),
              ListTile(
                  leading: Icon(Icons.key),
                  title: Text("User Id",
                      style: GoogleFonts.lato(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  subtitle:
                      Text(data.uid, style: const TextStyle(fontSize: 18))),
              Divider(),
            ],
          ),
        ),
      );
    });
  }
}
