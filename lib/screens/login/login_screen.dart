import 'package:flutter/material.dart';
import 'package:wifi_chat/data/constants/assets_paths.dart';
import 'package:wifi_chat/screens/login/components/login_page_title.dart';
import 'package:wifi_chat/screens/login/components/login_field_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPaths.loginBgImage),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high),
          ),
          child: Column(
            children: [
              const LoginPageTitle(),
              const SizedBox(height: 50),
              LoginFieldContainer(),
            ],
          )),
    );
  }
}
