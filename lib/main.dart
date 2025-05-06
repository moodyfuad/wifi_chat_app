import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_chat/Services/notification_services.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/providers/x_o_provider.dart';
import 'package:wifi_chat/screens/login/login_screen.dart';
import 'package:wifi_chat/screens/shared/Theme/custom_theme.dart';

void _isolateMain(RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getBool('isDebug'));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
  await NotificationService().initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      ChangeNotifierProvider<DiscoveryProvider>(
          create: (context) => DiscoveryProvider()),
      ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
      ChangeNotifierProvider<XOProvider>(create: (context) => XOProvider()),
    ],
    builder: (context, child) => const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
        title: 'WiFi Chat',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
      ),
    );
  }
}
