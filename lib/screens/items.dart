import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailor_admin/provider/auth.dart';
import "package:cached_network_image/cached_network_image.dart";
import '../constants/appColors.dart';
import '../widgets/dotloader.dart';
import 'addItems.dart';
import 'editItem.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    AuthVm p = Provider.of<AuthVm>(context, listen: false);
    await p.getItmesF();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(title: Text("All Itmes"), actions: [
            OutlinedButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.black),
                      )),
                      backgroundColor: WidgetStateProperty.all(
                          AppColors.primaryColor.shade100),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItemPage()));
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      "Add Item",
                      style: GoogleFonts.agbalumo(color: Colors.white),
                    ))
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                    color: Colors.amber.withOpacity(0.3),
                    duration: const Duration(seconds: 2))
          ]),
          body: p.isLoading
              ? DotLoader(color: AppColors.primaryColor)
              : p.itemsList.isEmpty
                  ? Center(child: Text("Empty"))
                  : ListView.separated(
                      itemCount: p.itemsList.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        var data = p.itemsList[index];
                        return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditItemPage(data: data)));
                            },
                            leading: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 37,
                                height: 37,
                                imageUrl: data.image.toString().isEmpty
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq3t9dFOmI3lGU6fDJmGn3cagEbJwaqiOi9YKw1lyGxGZ_T1QLEx7-hlt5DpVd-vDEBb8&usqp=CAU"
                                    : data.image,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person,
                                        color: AppColors.primaryColor),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator.adaptive(
                                        strokeWidth: 2)),
                            title: Text(data.title),
                            trailing: IconButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Delete"),
                                            content: Text(
                                                "Are you sure you want to delete?"),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No")),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('items')
                                                        .doc(data.id)
                                                        .delete();
                                                    p.getItmesF();
                                                  },
                                                  child: Text("Yes"))
                                            ],
                                          ));
                                },
                                icon: Icon(Icons.delete)),
                            subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Price: ${data.price}"),
                                  Text("Size: ${data.size}")
                                ]));
                      }));
    });
  }
}
