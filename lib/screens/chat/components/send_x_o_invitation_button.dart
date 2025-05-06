import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/x_o_game/models/x_o_invitation_model.dart';

class SendXOInvitationButton extends StatelessWidget {
  const SendXOInvitationButton({super.key, required this.user});
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
      child: ElevatedButton(
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.gamepad_rounded),
              Text("Send invitation To Paly XO"),
            ]),
        onPressed: () async {
          await Provider.of<ChatProvider>(context, listen: false)
              .sendMessage(_makeInvitationMessage(context), user);
          Navigator.pop(context);
        },
      ),
    );
  }
}
