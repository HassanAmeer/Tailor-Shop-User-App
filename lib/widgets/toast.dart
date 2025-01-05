import 'package:flutter/material.dart';
import '../constants/appColors.dart';

snackBarF(msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg.toString()),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(label: 'Undo', onPressed: () {})));
}

snackBarColorF(msg, context,
    {Color color = AppColors.primaryColor,
    Color borderColor = const Color.fromARGB(200, 222, 202, 230),
    String? label = "Undo",
    VoidCallback? onTap}) {
  final snackBar = SnackBar(
      margin:
          const EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0, top: 10),
      backgroundColor: color,
      content:
          Text(msg.toString(), style: const TextStyle(color: Colors.white)),
      elevation: 100,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: borderColor,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: 2.3)),
      action: onTap != null
          ? SnackBarAction(
              label: label ?? "Undo",
              textColor: Colors.yellow,
              onPressed: onTap,
            )
          : null);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
