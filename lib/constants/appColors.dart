import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryColor = MaterialColor(
    _indigoPrimaryValue,
    <int, Color>{
      100: Color(0xFF8C9EFF),
      200: Color(_indigoPrimaryValue),
      400: Color(0xFF3D5AFE),
      700: Color(0xFF304FFE),
    },
  );
  static const int _indigoPrimaryValue = 0xFF536DFE;
  ////////////////// // others Colros ///////////////////////
  ////
  static const Color orange = Color.fromARGB(255, 255, 87, 34);
  static const Color indigo = Color(0xFF536DFE);
  static Color green = Colors.green.shade700;
  static const Color lightGreen = Color.fromARGB(255, 179, 214, 169);
  static const Color lightBlue = Color.fromARGB(255, 208, 207, 255);
  static const Color lightOrange = Color.fromARGB(255, 255, 226, 216);

  ////
}
