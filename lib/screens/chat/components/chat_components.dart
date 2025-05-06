import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/screens/chat/components/send_x_o_invitation_button.dart';

class ChatCompomenets {
  static showMenuDialog(BuildContext context, UserModel user) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.all(10),
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actions: [
          SendXOInvitationButton(
            user: user,
          )
        ],
      ),
    );
  }

  static Widget _getReadIcon() {
    return const Stack(children: [
      Positioned(
        right: 5,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
      Icon(Icons.check, color: Colors.green),
    ]);
  }

  static Widget getMessageStateWidget(MessageStates state) {
    return switch (state) {
      MessageStates.sending => const Icon(Icons.watch_later_outlined),
      MessageStates.sent => const Icon(
          Icons.check,
          color: Colors.grey,
        ),
      MessageStates.delivered => const Icon(
          Icons.check,
          color: Colors.blue,
        ),
      MessageStates.failed => const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      MessageStates.read => _getReadIcon(),
    };
  }

  static bool _isOnline(DiscoveryProvider prv, UserModel user) =>
      prv.users.any((inUser) => inUser.host == user.host);

  static AppBar getChatPageAppBar(BuildContext context, UserModel user) {
    return AppBar(
      leading: IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            ChatCompomenets.showMenuDialog(context, user);
          },
          child: const Icon(
            Icons.menu_rounded,
            size: 35,
          ),
        ),
      ],
      leadingWidth: 40,
      toolbarHeight: 60,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: user.host,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: user.profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 40,
                      )
                    : Image.memory(
                        user.profileImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                user.name.toUpperCase(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(width: 10),
              Consumer<DiscoveryProvider>(
                  builder: (context, discoveryPrv, child) {
                final bool online = _isOnline(discoveryPrv, user);
                return Text(
                  online ? 'online' : 'offline',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: online ? Colors.green : Colors.red,
                      ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
