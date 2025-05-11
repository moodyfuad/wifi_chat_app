import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_chat/data/constants/assets_paths.dart';
import 'package:wifi_chat/screens/login/components/login_page_title.dart';
import 'package:wifi_chat/screens/login/components/login_field_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.deepPurpleAccent,
          width: double.infinity,
          height: double.infinity,
        ),
        LottieBuilder.asset(
          AssetPaths.lottieLoginBG,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        )
        // image: DecorationImage(
        //     image: AssetImage(AssetPaths.loginBgImage),
        //     fit: BoxFit.cover,
        //     filterQuality: FilterQuality.high),

        ,
        const Column(
          children: [
            LoginPageTitle(),
            SizedBox(height: 50),
            LoginFieldContainer(),
          ],
        )
      ]),
    );
  }
}
