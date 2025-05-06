import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle signupTextStyle = TextStyle(
    fontSize: 50,
    fontFamily: 'Roboto',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    letterSpacing: 20,
    shadows: [
      Shadow(
        color: Colors.black,
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
    ],
  );
}
