
import 'package:flutter/material.dart';

class MaterialColors {
  static const Color defaultButton = Color.fromRGBO(220, 220, 220, 1.0);
  static const Color primary = Color.fromRGBO(156, 38, 176, 1.0);
  static const Color label = Color.fromRGBO(254, 36, 114, 1.0);
  static const Color info = Color.fromRGBO(0, 188, 212, 1.0);
  static const Color error = Color.fromRGBO(244, 67, 54, 1.0);
  static const Color success = Color.fromRGBO(76, 175, 80, 1.0);
  static const Color warning = Color.fromRGBO(255, 152, 0, 1.0);
  static const Color muted = Color.fromRGBO(151, 151, 151, 1.0);
  static const Color input = Color.fromRGBO(220, 220, 220, 1.0);
  static const Color active = Color.fromRGBO(156, 38, 176, 1.0);
  static const Color placeholder = Color.fromRGBO(159, 165, 170, 1.0);
  static const Color switch_off = Color.fromRGBO(212, 217, 221, 1.0);
  static const Color gradientStart = Color.fromRGBO(107, 36, 170, 1.0);
  static const Color gradientEnd = Color.fromRGBO(172, 38, 136, 1.0);
  static const Color priceColor = Color.fromRGBO(234, 213, 251, 1.0);
  static const Color border = Color.fromRGBO(231, 231, 231, 1.0);
  static const Color caption = Color.fromRGBO(74, 74, 74, 1.0);
  static const Color bgColorScreen = Color.fromRGBO(238, 238, 238, 1.0);
  static const Color drawerHeader = Color.fromRGBO(75, 25, 88, 1.0);
  static const Color signStartGradient = Color.fromRGBO(108, 36, 170, 1.0);
  static const Color signEndGradient = Color.fromRGBO(21, 0, 43, 1.0);
  static const Color socialFacebook = Color.fromRGBO(59, 89, 152, 1.0);
  static const Color socialTwitter = Color.fromRGBO(91, 192, 222, 1.0);
  static const Color socialDribbble = Color.fromRGBO(234, 76, 137, 1.0);
  static const Color blueMain = Color(0xff1b2143);
  static const Color yellowMain = Color(0xfffabb3f);
}

ButtonStyle styleElevatedButton(
        {Color color = MaterialColors.defaultButton,
        double fontSizeValue = 20}) =>
    ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: fontSizeValue), primary: color);

TextStyle boldStyle({double size = 14.0, Color color = Colors.black}) {
  return TextStyle(
      fontSize: size, fontWeight: FontWeight.bold, color: Colors.black);
}

var bottonBorderBlue = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(MaterialColors.blueMain),
    shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
      side: BorderSide(color: Colors.blueAccent),
    ),
  ),
);

const buttonYellowStyle = TextStyle(color: MaterialColors.yellowMain);

getSizeScreen(BuildContext ctx) {
  double width = MediaQuery.of(ctx).size.width;
  double height = MediaQuery.of(ctx).size.height;
  return [width, height];
}

Text textCustom(String txt,
    {double size = 12, Color colorV: Colors.black, bool isBold = false}) {
  return Text(txt,
      style: TextStyle(
          fontSize: size,
          color: colorV,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal));
}
