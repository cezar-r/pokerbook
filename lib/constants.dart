import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {

  static Text text(String text, {Color? color = Colors.redAccent, double? fontSize = 14, fontWeight = FontWeight.normal}) {
      return Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        )
      );
  }

  static DateFormat dateFormat = DateFormat('MMMM dd yyyy H:mm');

  static AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Constants.text("PokerBook", fontSize: 25, fontWeight: FontWeight.bold),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }


}