import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailor_admin/screens/items.dart';
import 'package:tailor_admin/screens/settingsMenu.dart';
import 'package:tailor_admin/widgets/logout.dart';
import '../constants/appColors.dart';
import '../provider/auth.dart';
import 'chatsList.dart';

import 'usersList.dart';

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
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Admin App", style: GoogleFonts.agbalumo())]),
            actions: [
              IconButton(
                  onPressed: () {
                    Logout().exitDialoge(context);
                  },
                  icon: Icon(Icons.exit_to_app))
            ]),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("Welcome to your Dashboard",
                      style: GoogleFonts.agbalumo(
                          fontSize: 20, color: Colors.grey))
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                      color: AppColors.primaryColor,
                      duration: Duration(seconds: 2)),
              SizedBox(height: 20),
              Center(
                  child: Wrap(
                      runSpacing: 10,
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 10,
                      children: List.generate(4, (index) {
                        return InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UsersPage()));
                              } else if (index == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatsListPage()));
                              } else if (index == 2) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ItemPage()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsMenu()));
                              }
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(
                                                255, 187, 197, 255)
                                            .withOpacity(0.4)),
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    child: Column(children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              height: 140,
                                              foregroundDecoration:
                                                  BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Icon(
                                                      index == 0
                                                          ? Icons.people
                                                          : index == 1
                                                              ? Icons.chat_sharp
                                                              : index == 2
                                                                  ? Icons
                                                                      .shopping_bag
                                                                  : Icons
                                                                      .settings,
                                                      size: 80,
                                                      color:
                                                          Colors.grey.shade300)
                                                  .animate(
                                                      onPlay: (c) => c.repeat())
                                                  .shimmer(
                                                      color: Colors.grey,
                                                      delay: Duration(
                                                          seconds: index * 2),
                                                      duration: Duration(
                                                          seconds: 2)))),
                                      SizedBox(height: 5),
                                      Text(
                                          index == 0
                                              ? "Users"
                                              : index == 1
                                                  ? "Chats"
                                                  : index == 2
                                                      ? "Items"
                                                      : "Settings",
                                          style: GoogleFonts.agbalumo(
                                              letterSpacing: 2,
                                              color: Colors.black,
                                              fontSize: 17)),
                                      SizedBox(height: 15),
                                      // Text("Description $index")
                                    ]))));
                      }))).animate().slideX().fadeIn(),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          leading: Icon(Icons.app_settings_alt),
                          tileColor: Colors.grey.shade200,
                          // tileColor: AppColors.primaryColor.shade100,
                          title: Text("Trailor Shop",
                              style: GoogleFonts.aclonica(color: Colors.black)),
                          subtitle: Text("App Name"))
                      .animate()
                      .shimmer(
                          color: Colors.grey.shade200,
                          delay: Duration(seconds: 1),
                          duration: Duration(seconds: 2))),
              SizedBox(height: 10),
            ]),
        // floatingActionButton: FloatingActionButton(
        //         backgroundColor: AppColors.primaryColor,
        //         onPressed: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => ChatsPage()));
        //         },
        //         child: const Icon(Icons.chat, color: Colors.white)
        //             .animate(onPlay: (controller) => controller.repeat())
        //             .shimmer(
        //                 color: AppColors.orange,
        //                 duration: Duration(seconds: 2)))
        //     .animate(onPlay: (controller) => controller.repeat())
        //     .shimmer(
        //         color: Colors.white.withOpacity(0.2),
        //         duration: Duration(seconds: 2)));
      );
    });
  }
}
