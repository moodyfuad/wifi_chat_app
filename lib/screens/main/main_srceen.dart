import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/mini_games/x_o/Pages/x_o_game_main_page.dart';
import 'package:wifi_chat/mini_games/x_o/widgets/x_o_board_widget.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/x_o_provider.dart';
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
    ChatProvider.inChatIndex = null;
    var xoPrv = Provider.of<XOProvider>(context, listen: false);
    xoPrv.addListener(
      () {
        if (xoPrv.invitationAccepted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => XOBoardWidget(
                    title: "title",
                  )));
        }
      },
    );
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
