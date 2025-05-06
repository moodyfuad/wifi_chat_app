import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:provider/provider.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_invitation_model.dart';
import 'package:wifi_chat/providers/x_o_provider.dart';
import 'package:wifi_chat/screens/chat/components/chat_components.dart';

class XOInvitationWidget extends StatelessWidget {
  const XOInvitationWidget(
      {super.key, required this.invitation, required this.isMyMessage});

  final XOInvitationModel invitation;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          boxShadow: List.filled(
              4, const BoxShadow(color: Colors.purple, blurRadius: 3)),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        width: size.width * 0.6,
        height: size.width * 0.6 * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    invitation.content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  invitation.state.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                if (isMyMessage) return;
                Provider.of<XOProvider>(context, listen: false)
                    .startGame(invitation: invitation);
              },
              label: const Text(
                "Play",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.deepPurple,
                ),
              ),
              icon: Icon(
                Icons.gamepad,
                color: isMyMessage ? Colors.blueGrey : Colors.deepPurple,
              ),
            ),
            Row(
              crossAxisAlignment:
                  isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.end,
              mainAxisAlignment:
                  isMyMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                isMyMessage
                    ? ChatCompomenets.getMessageStateWidget(
                        invitation.messageStates)
                    : Container(),
                Text(
                  textAlign: isMyMessage ? TextAlign.left : TextAlign.right,
                  Intl.DateFormat('h:mm a').format(invitation.dateTime),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
