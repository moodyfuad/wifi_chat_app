import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/screens/chat/chat_page.dart';
import 'package:wifi_chat/screens/discovery/components/chat_card.dart';
import 'package:wifi_chat/screens/discovery/components/discovery_app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDiscoveryAppBar(title: 'Chats', context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer2<ChatProvider, DiscoveryProvider>(
              builder: (context, chatPrv, discoveryPrv, child) =>
                  ListView.builder(
                itemCount: chatPrv.chats.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = chatPrv.chats[index].withUser;
                  final bool online =
                      discoveryPrv.users.any((u) => u.host == user.host);
                  final lastMessage = chatPrv.chats[index].messages.lastOrNull;
                  return GestureDetector(
                    onTap: () => _navigateToChatPage(context, chatPrv, user),
                    child: getChatCart(
                        user: user, online: online, lastMessage: lastMessage),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatPage(
      BuildContext context, ChatProvider chatPrv, UserModel user) {
    chatPrv.startChat(user);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatPage(user: user),
    ));
  }
}
