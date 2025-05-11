import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/hive/helpers/chat_box_helper.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/screens/chat/chat_screen.dart';
import 'package:wifi_chat/screens/discovery/components/chat_card.dart';
import 'package:wifi_chat/screens/main/components/main_app_bar.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatProvider.inChatWithUserhost = '';
    return Scaffold(
      appBar: getMainAppBar(title: 'Chats', context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer2<ChatProvider, DiscoveryProvider>(
              builder: (context, chatPrv, discoveryPrv, child) =>
                  ListView.builder(
                // itemCount: chatPrv.chats.length,
                itemCount: ChatBoxHelper.getAllChats().length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final chat = ChatBoxHelper.getAllChats()[index];
                  final user = chat.withUser;
                  final bool online =
                      discoveryPrv.users.any((u) => u.host == user.host);
                  // final lastMessage = chatPrv.chats[index].messages.lastOrNull;
                  final lastMessage = chat.messages.lastOrNull;
                  return Dismissible(
                    key: Key(user.host),
                    onDismissed: (direction) {
                      ChatBoxHelper.deleteChat(user.host);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(children: [
                        const Icon(
                          Icons.delete,
                          size: 30,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Delete Chat With Messages',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ]),
                    ),
                    child: GestureDetector(
                      onTap: () async =>
                          await _navigateToChatPage(context, chatPrv, user),
                      child: getChatCart(
                          context: context,
                          user: user,
                          online: online,
                          lastMessage: lastMessage),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToChatPage(
      BuildContext context, ChatProvider chatPrv, UserModel user) async {
    chatPrv.startChat(user);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatScreen(user: user),
    ));
  }
}
