import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/constants/assets_paths.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/screens/chat/chat_screen.dart';
import 'package:wifi_chat/screens/discovery/components/chat_card.dart';
import 'package:wifi_chat/screens/main/components/main_app_bar.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatProvider.inChatWithUserhost = '';
    return Scaffold(
      appBar: getMainAppBar(title: 'Discover People', context: context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<DiscoveryProvider>(
              builder: (context, value, child) => value.users.isEmpty ||
                      value.users.length == 1 &&
                          value.users.first.host ==
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .host
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(AssetPaths.lottie_wifi_eye),
                        ),
                        Text(
                          value.isDiscoveryOn
                              ? 'Searching For People...'
                              : 'Switch To Online To Descover People!',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.deepPurple,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: value.users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = value.users[index];
                        return GestureDetector(
                            onTap: () => _navigateToChatPage(context, user),
                            child: getChatCart(
                                context: context, user: user, online: true));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatPage(BuildContext context, UserModel user) {
    Provider.of<ChatProvider>(context, listen: false).startChat(user);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatScreen(user: user),
    ));
  }
}
