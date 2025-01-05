import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailershop/auth/editprofile.dart';
import 'package:tailershop/constants/appColors.dart';
import 'package:tailershop/provider/auth.dart';
import 'package:tailershop/screens/itemDetails.dart';
import 'package:tailershop/widgets/logout.dart';

import '../constants/appImages.dart';
import 'chats.dart';
import 'contactus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    await Provider.of<AuthVm>(context, listen: false).getItmesF();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.shade700,
                      AppColors.primaryColor.shade400
                    ],
                  ),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(p.app_icon.toString()),
                      fit: BoxFit.cover),
                ),
                child: Row(children: [
                  Container(
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: CachedNetworkImage(
                              imageUrl: p.app_icon.toString(),
                              placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryColor)),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey.shade300)))
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          color: Colors.grey.withOpacity(0.7),
                          duration: Duration(seconds: 2)),
                  Text(p.app_name.toString(),
                          style: GoogleFonts.praise(
                              fontSize: 30, color: Colors.white))
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          color: Colors.grey.withOpacity(0.7),
                          duration: Duration(seconds: 2))
                ])),
            ListTile(
                leading: Icon(Icons.person_4_sharp, color: Colors.grey),
                title: const Text('Profile'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.call, color: Colors.grey),
                title: const Text('Contact Us'),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()));
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Logout'),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Logout().singOut(context);
                }),
            Divider(),
          ])),
          appBar: AppBar(
              leading: /* its Take A Child PLace Any Where */
                  Builder(builder: (context) {
                return IconButton(
                    icon: Icon(Icons.sort_outlined),
                    onPressed: (() {
                      Scaffold.of(context).openDrawer();
                    }));
              }),
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CachedNetworkImage(
                    width: 45,
                    height: 45,
                    imageUrl: p.app_icon,
                    placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor))),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image, color: Colors.transparent)),
                Text(p.app_name.toString(),
                    style: GoogleFonts.praise(fontSize: 30))
              ]),
              actions: [
                p.userProfile.profileImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage()));
                                },
                                child: CircleAvatar(
                                    child: CachedNetworkImage(
                                        width: 250,
                                        imageUrl: p.userProfile.profileImage
                                            .toString(),
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) {
                                          return Icon(Icons.image_sharp,
                                                  size: 300,
                                                  color: Colors.grey.shade200)
                                              .animate(
                                                  onPlay: (controller) =>
                                                      controller.repeat())
                                              .shimmer(
                                                  color: Colors.white,
                                                  duration: 2.seconds);
                                        },
                                        errorWidget:
                                            (context, error, stackTrace) {
                                          return Image.asset(AppImages.textLogo,
                                              fit: BoxFit.cover, width: 200);
                                        })))))
                    : IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        icon: Icon(Icons.person_4_outlined))
              ]),
          body: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(children: [
                p.show_banner
                    ? Center(
                        child: Container(
                            height: 250,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor.shade100
                                    .withOpacity(0.1)),
                            child: CachedNetworkImage(
                                imageUrl: p.banner,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primaryColor))),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image))))
                    : SizedBox.shrink(),
                SizedBox(height: 20),
                Wrap(
                    children: List.generate(p.itemsList.length, (index) {
                  var data = p.itemsList[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ItemsDetailsPage(data: data)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 187, 197, 255)
                                  .withOpacity(0.2)),
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(7),
                                child: Stack(children: [
                                  Container(
                                      clipBehavior: Clip.antiAlias,
                                      height: 170,
                                      foregroundDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white10),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       offset: const Offset(1, 26),
                                        //       blurRadius: 5,
                                        //       spreadRadius: 1,
                                        //       color: Colors.grey.withOpacity(.3))
                                        // ],
                                      ),
                                      child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: data.image,
                                          // imageUrl: p.app_icon.toString(),
                                          placeholder: (context, url) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 14),
                                              child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      const CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: AppColors
                                                              .primaryColor))),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.image))),
                                  Positioned(
                                      right: -3,
                                      top: -3,
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border(
                                                  top: BorderSide(
                                                      color: const Color.fromARGB(
                                                          255, 224, 229, 255),
                                                      width: 5),
                                                  bottom: BorderSide(
                                                      color: const Color.fromARGB(
                                                          255, 224, 229, 255),
                                                      width: 5),
                                                  left: BorderSide(
                                                      color: const Color.fromARGB(
                                                          255, 224, 229, 255),
                                                      width: 5))),
                                          child: Icon(Icons.remove_red_eye_outlined,
                                              color: Colors.grey.shade300)))
                                ])),
                            SizedBox(height: 5),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${data.title.toString().length > 12 ? data.title.substring(0, 12).toString() : data.title} ...",
                                          style: GoogleFonts.aclonica(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300)),
                                      Text("Rs: ${data.price}",
                                          style: GoogleFonts.aclonica(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300))
                                    ])),
                            SizedBox(height: 15),
                            // Text("Description $index")
                          ])),
                    ),
                  );
                }))
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
    });
  }
}
