import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wifi_chat/screens/contacts/contact_page.dart';
import 'package:wifi_chat/screens/discovery/discovery_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 1;
  final List<Widget> pages = [
    const ContactPage(),
    const DiscoveryPage(),
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: IconTheme(
        data:
            Theme.of(context).iconTheme.copyWith(color: Colors.white, size: 30),
        child: CurvedNavigationBar(
          buttonBackgroundColor: Colors.deepPurple,
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          color: Colors.black87,
          height: 50,
          onTap: (value) => setState(() {
            index = value;
          }),
          index: index,
          items: const [
            Icon(Icons.chat),
            Icon(Icons.wifi),
          ],
        ),
      ),
    );
  }
}
