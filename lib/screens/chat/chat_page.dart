import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_invitation_model.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/screens/chat/components/chat_components.dart';
import 'package:wifi_chat/screens/chat/components/message_widget.dart';
import 'package:wifi_chat/screens/chat/components/x_o_invitation_widget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.user});
  final UserModel user;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isMyMessage(MessageModel message) {
    return user.host != message.senderHost;
  }

  Future<void> _sendMessage(ChatProvider prv, BuildContext context,
      {int tryingLimit = 4}) async {
    if (_messageController.text.isEmpty) return;
    final message = _createMessage(context);
    await prv.sendMessage(message, user, resendingLimit: tryingLimit);
    _messageController.clear();
    updateScrollPosition();
  }

  MessageModel _createMessage(BuildContext context) {
    UserModel me = Provider.of<UserProvider>(context, listen: false).user;
    return MessageModel(
      senderName: me.name,
      senderHost: me.host,
      receiverHost: user.host,
      content: _messageController.text,
      dateTime: DateTime.now(),
    );
  }

  void updateScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, DiscoveryProvider>(
      builder: (context, chatPrv, discoveryPrv, child) {
        updateScrollPosition();
        ChatProvider.inChatIndex = chatPrv.getChatIndex(user.host);
        return Scaffold(
          appBar: ChatCompomenets.getChatPageAppBar(context, user),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatPrv.getUserMessages(user).length,
                  itemBuilder: (context, index) {
                    List<MessageModel> messages = chatPrv.getUserMessages(user);
                    final message = messages[index];
                    switch (message) {
                      case XOInvitationModel invitation:
                        return XOInvitationWidget(
                            invitation: invitation,
                            isMyMessage: _isMyMessage(message));

                      default:
                        return GestureDetector(
                          onTap: () {
                            if (message.messageStates == MessageStates.failed) {
                              message.sendingAttmpts = 0;
                              _showResendDialog(context, message,
                                  () => chatPrv.sendMessage(message, user));
                            }
                          },
                          child: MessageWidget(
                              message: message, isMe: _isMyMessage(message)),
                        );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your message',
                        ),
                        onSubmitted: (_) => _sendMessage(chatPrv, context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        _sendMessage(chatPrv, context);
                        // updateScrollPosition();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResendDialog(
      BuildContext context, MessageModel message, void Function() onResend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Resend Message',
          style: TextStyle(fontSize: 18),
        ),
        content: const Text(
          'Do you want to resend this message?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(
              'Resend',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              onResend(); // Your resend implementation
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ).then((shouldResend) {
      if (shouldResend == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Resending message...',
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }
}
