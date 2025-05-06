import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/screens/chat/chat_page.dart';
import 'package:wifi_chat/screens/discovery/components/chat_card.dart';
import 'package:wifi_chat/screens/discovery/components/discovery_app_bar.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatProvider.inChatIndex = null;
    return Scaffold(
      appBar: getDiscoveryAppBar(title: 'Discover People', context: context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<DiscoveryProvider>(
              builder: (context, value, child) => ListView.builder(
                itemCount: value.users.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = value.users[index];
                  return GestureDetector(
                      onTap: () => _navigateToChatPage(context, value, user),
                      child: getChatCart(user: user, online: true));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatPage(
      BuildContext context, DiscoveryProvider prv, UserModel user) {
    Provider.of<ChatProvider>(context, listen: false).startChat(user);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatPage(user: user),
    ));
  }
}
