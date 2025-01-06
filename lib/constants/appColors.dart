import 'package:flutter/material.dart';

class AppColors {
  // static const MaterialColor primaryColor = MaterialColor(
  //   _deepOrangePrimaryValue,
  //   <int, Color>{
  //     50: Color(0xFFFBE9E7),
  //     100: Color(0xFFFFCCBC),
  //     200: Color(0xFFFFAB91),
  //     300: Color(0xFFFF8A65),
  //     400: Color(0xFFFF7043),
  //     500: Color(_deepOrangePrimaryValue),
  //     600: Color(0xFFF4511E),
  //     700: Color(0xFFE64A19),
  //     800: Color(0xFFD84315),
  //     900: Color(0xFFBF360C),
  //   },
  // );
  // static const int _deepOrangePrimaryValue = 0xFFFF5722;

///////////// color 1

  static const MaterialColor primaryColor = MaterialColor(
    _cyanPrimaryValue,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(_cyanPrimaryValue),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );
  static const int _cyanPrimaryValue = 0xFF00BCD4;

///////////// color 2
  // static const MaterialColor primaryColor = MaterialColor(
  //   _indigoPrimaryValue,
  //   <int, Color>{
  //     100: Color(0xFF8C9EFF),
  //     200: Color(_indigoPrimaryValue),
  //     400: Color(0xFF3D5AFE),
  //     700: Color(0xFF304FFE),
  //     900: Color(0xFF0F29BF),
  //   },
  // );
  // static const int _indigoPrimaryValue = 0xFF536DFE;
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
