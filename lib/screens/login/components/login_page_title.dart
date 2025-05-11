import 'package:flutter/material.dart';

class LoginPageTitle extends StatelessWidget {
  const LoginPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: FittedBox(
        child: Center(
          child: Text(
            "WIFI CHAT",
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 20,
              shadows: [
                Shadow(
                  color: Colors.pink,
                  offset: Offset(1, 1),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
