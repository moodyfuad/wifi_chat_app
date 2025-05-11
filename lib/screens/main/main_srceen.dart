import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/x_o_provider.dart';
import 'package:wifi_chat/screens/contacts/contact_screen.dart';
import 'package:wifi_chat/screens/discovery/discovery_screen.dart';
import 'package:wifi_chat/x_o_game/screens/x_o_board_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 1;
  final List<Widget> pages = [
    const ContactScreen(),
    const DiscoveryScreen(),
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider.inChatWithUserhost = '';
    var xoPrv = Provider.of<XOProvider>(context, listen: false);
    void XOProviderListener() {
      if (xoPrv.invitationAccepted) {
        try {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const XOBoardWidget(
                      title: "title",
                    )));
            xoPrv.removeListener(XOProviderListener);
          });
        } catch (_) {}
      }
    }

    xoPrv.addListener(XOProviderListener);
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: IconTheme(
        data:
            Theme.of(context).iconTheme.copyWith(color: Colors.white, size: 30),
        child: CurvedNavigationBar(
          buttonBackgroundColor: Colors.deepPurple,
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          // color: Colors.black87,
          color: Theme.of(context).colorScheme.onPrimary,
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
