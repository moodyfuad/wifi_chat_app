import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/screens/chat/components/chat_components.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isMe,
  });
  MessageStates get states => message.messageStates;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.purple : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: isMe ? const Radius.circular(10) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(10),
              ),
            ),
            child: _getMessageContentWidget(isMe)));
  }

  Widget _getMessageContentWidget(bool isMyMessage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: isMyMessage ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              message.content,
              softWrap: true,
              style: TextStyle(
                color: isMyMessage ? Colors.white : Colors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Row(
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            isMyMessage ? ChatCompomenets.getMessageStateWidget(states) : Container(),
            Text(
              intl.DateFormat('h:mm a').format(message.dateTime),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        )
      ],
    );
  }

}
