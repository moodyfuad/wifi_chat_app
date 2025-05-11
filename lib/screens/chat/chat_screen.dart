import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/screens/chat/components/chat_components.dart';
import 'package:wifi_chat/screens/chat/components/message_widget.dart';
import 'package:wifi_chat/screens/chat/components/show_delete_dialog.dart';
import 'package:wifi_chat/screens/chat/components/show_resend_dialog.dart';
import 'package:wifi_chat/screens/chat/components/x_o_invitation_widget.dart';
import 'package:wifi_chat/x_o_game/models/x_o_invitation_model.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.user});
  final UserModel user;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isMyMessage(MessageModel message) {
    return user.host != message.senderHost;
  }

  Future<void> _sendMessage(BuildContext context, {int tryingLimit = 4}) async {
    var prv = getChatProv(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_messageController.text.isEmpty) return;
      final message = _createMessage(context);
      await prv.sendMessage(message, user, resendingLimit: tryingLimit);
      _messageController.clear();
      // updateScrollPosition();
    });
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

  getChatProv(BuildContext context) {
    return Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider.inChatWithUserhost = user.host;
    return Scaffold(
      appBar: ChatCompomenets.getChatPageAppBar(context, user),
      body: Column(
        children: [
          Expanded(
            child: Consumer2<ChatProvider, DiscoveryProvider>(
              builder: (context, chatPrv, discoveryPrv, child) {
                return FutureBuilder(
                    future: chatPrv.getUserMessages(user),
                    initialData: const <MessageModel>[],
                    builder: (context, snapshot) {
                      updateScrollPosition();
                      return !snapshot.hasData
                          ? Container()
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                List<MessageModel> messages =
                                    snapshot.data ?? [];
                                final message = messages[index];
                                switch (message) {
                                  case XOInvitationModel invitation:
                                    return XOInvitationWidget(
                                        invitation: invitation,
                                        isMyMessage: _isMyMessage(message));

                                  default:
                                    return GestureDetector(
                                      onTap: () async {
                                        if (message.messageStates ==
                                            MessageStates.failed) {
                                          message.sendingAttmpts = 0;
                                          showResendDialog(context, message,
                                              () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              await chatPrv.sendMessage(
                                                  message, user);
                                            });
                                          });
                                        }
                                      },
                                      child: GestureDetector(
                                        onLongPress: () async {
                                          showDeleteDialog(context, message,
                                              () async {
                                            await chatPrv.deleteMessage(
                                                user.host, message);
                                          });
                                        },
                                        child: MessageWidget(
                                            message: message,
                                            isMe: _isMyMessage(message)),
                                      ),
                                    );
                                }
                              },
                            );
                    });
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
                    onSubmitted: (_) async => await _sendMessage(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await _sendMessage(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
