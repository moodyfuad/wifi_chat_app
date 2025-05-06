import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_invitation_model.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';

class ChatMenuOverlay extends StatelessWidget {
  const ChatMenuOverlay({super.key, required this.user});
  final UserModel user;

  XOInvitationModel _makeInvitationMessage(BuildContext context) {
    UserModel me = Provider.of<UserProvider>(context, listen: false).user;
    return XOInvitationModel(
      senderName: me.name,
      senderHost: me.host,
      receiverHost: user.host,
      content: 'XO invitation',
      dateTime: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20).copyWith(
          topRight: const Radius.circular(0),
          bottomRight: const Radius.circular(0),
        ),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.gamepad_rounded),
                  Text("Send invitation To Paly XO"),
                ]),
            onPressed: () async {
              //todo: sent invitation messgage

              await Provider.of<ChatProvider>(context, listen: false)
                  .sendMessage(_makeInvitationMessage(context), user);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
