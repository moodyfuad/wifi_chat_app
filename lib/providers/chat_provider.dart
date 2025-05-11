import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wifi_chat/Services/client_socket_services.dart';
import 'package:wifi_chat/Services/notification_services.dart';
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/hive/helpers/chat_box_helper.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/model_types.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/x_o_game/models/x_o_invitation_model.dart';

class ChatProvider extends ChangeNotifier {
  final List<ClientSocketServices> clients = [];
  final ServerSocketServices _server = ServerSocketServices();
  String get myHost => _server.host ?? "No Host Yet";
  static String inChatWithUserhost = '';

  Future<List<MessageModel>> getUserMessages(UserModel user) async {
    final messages = await ChatBoxHelper.getUserMessages(user);

    for (MessageModel message in messages.where((msg) =>
        msg.senderHost != _server.host &&
        msg.messageStates != MessageStates.read)) {
      await _updateMessageStatusToRead(message, user);
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return messages;
  }

  Future<void> deleteMessage(String host, MessageModel message) async {
    await ChatBoxHelper.deleteChatMessage(host, message);
    notifyListeners();
  }

  Future<void> startMessagingServer() async {
    try {
      await _server.startServer(
          onObjectReceived: _onObjectReceived,
          onNewClientConnected: _onClientConnected,
          onClientDisconnected: _onClientDisconnected);
    } catch (e) {
      print('[+] Chat Prov (startMessagingServer) Error: $e');
    }
  }

  void stopMessageingServer() {
    try {
      _server.stop();
      //* Added
      for (var client in clients) {
        try {
          clients.remove(client);
          client.disconnect();
        } catch (e) {
          clients.remove(client);
          print('[+] Error stopMessageingServer: $e');
        }
      }
    } catch (_) {}
  }

  Future<void> startChat(
    UserModel withUser, {
    void Function()? onFailed,
  }) async {
    try {
      int clientIndex = _getClientIindex(withUser.host);
      //^ the user is new
      if (clientIndex == -1) {
        final client =
            ClientSocketServices(host: withUser.host, name: withUser.name);
        bool success = false;
        await client.connect(
          onConnectionFailed: _onConnectionFailed,
          onConnectionSuccess: (_) async {
            clients.add(client);
            await ChatBoxHelper.createChat(withUser);
            success = true;
          },
        );
        if (!success) {
          onFailed?.call();
          return;
        }
      }
    } catch (e) {
      print('[+] error in chat provider : $e');
    }
  }

  Future<void> sendMessage(
    MessageModel message,
    UserModel toUser, {
    int resendingLimit = 4,
  }) async {
    //todo: add my message using hive
    try {
      if (message.senderHost == _server.host) {
        await ChatBoxHelper.addChatMessage(toUser, message);
        notifyListeners();
      }
      final tryingLimit =
          resendingLimit > 0 && resendingLimit < 8 ? resendingLimit : 4;
      //^ the trying attmpts acceeds the limit
      if (message.sendingAttmpts >= tryingLimit &&
          message.senderHost == _server.host &&
          message.receiverHost != _server.host) {
        message.messageStates = MessageStates.failed;
        await ChatBoxHelper.addChatMessage(toUser, message);
        return;
      } else if (message.sendingAttmpts >= tryingLimit &&
          message.senderHost == _server.host &&
          message.receiverHost == _server.host) {
        message.messageStates = MessageStates.failed;
        await ChatBoxHelper.addChatMessage(toUser, message);
        return;
      } else if (message.senderHost != _server.host &&
          message.receiverHost != _server.host) {
        return;
      } else if (message.sendingAttmpts >= tryingLimit &&
          message.senderHost != _server.host) {
        // message.sendingAttmpts = 0;
        message.messageStates = MessageStates.delivered;
        await ChatBoxHelper.addChatMessage(toUser, message);
        return;
      }

      //^ increase the number of sending attmpts
      message.sendingAttmpts++;
      final int clientIndex = _getClientIindex(toUser.host);
      //^ the client is new
      if (clientIndex == -1) {
        await startChat(toUser);
        await sendMessage(message, toUser);
        print(
            '[+] From sendMessage() : sending Attmpts = [${message.sendingAttmpts}]');
      }
      //^ the client already exist
      else {
        clients[clientIndex].sendMapped(
          message.toJson(),
          onError: (error) {
            if (error.message == "Socket has been closed") {
              clients.removeAt(clientIndex).disconnect().onError((_, __) {
                clients.removeAt(clientIndex);
              }).then((_) async {
                await sendMessage(message, toUser);
              });
            } else {}
          },
        );
      }
      await Future.delayed(const Duration(milliseconds: 100));
      notifyListeners();
    } catch (e) {
      print('[+] error from chat provider send the message');
    }
  }

  void _onClientConnected(Socket client) async {
    if (clients.any((c) => c.host == client.remoteAddress.address)) {
      clients.removeWhere((c) => c.host == client.remoteAddress.address);
    }
    //^ new client
    if (client.address.address == _server.host) {
      return;
    }
    final newClient =
        ClientSocketServices(host: client.remoteAddress.address, name: '');
    await newClient.connect(
        onConnectionFailed: _onConnectionFailed,
        onConnectionSuccess: (_) => clients.add(newClient));
  }

  void _onClientDisconnected(Socket socket) {
    try {
      int clientIndex = _getClientIindex(socket.remoteAddress.address);
      if (clientIndex == -1) return;
      // clients.removeAt(clientIndex).disconnect();
      clients.removeAt(clientIndex).disconnect();
    } catch (e) {
      print('[+] (ChatProvider) Error disconnecting :$e');
    }
  }

  void _onObjectReceived(dynamic object) async {
    if (object[JsonKeys.modelType] == ModelTypes.xoInvitation.name) {
      await _onMessageReceived(XOInvitationModel.fromJson(object));
    } else if (object[JsonKeys.modelType] == ModelTypes.message.name) {
      await _onMessageReceived(MessageModel.fromJson(object));
    }
    notifyListeners();
  }

  MessageModel? receivedMsg;
  Future<void> _onMessageReceived(MessageModel message) async {
    //^ this is my updated message
    if (message.senderHost == _server.host) {
      print(
          '[+] my server host:${_server.host}| message sender :${message.senderName}');
      _updateMyMessageStatus(message);
      //^ not my message
    } else {
      _showNotification(message);
      //^ if its new user
      print("[+] chat not found onMessageReceived");
      final user = UserModel(
          host: message.senderHost,
          port: ServerSocketServices.port,
          id: const Uuid().v1(),
          name: message.senderName,
          discoveredDateTime: DateTime.now());

      var chat = await ChatBoxHelper.createChat(user);
      await startChat(user);

      //^ if the user already exist
      if (chat.withUser.name != message.senderName) {
        user.name = message.senderName;
        ChatBoxHelper.updateUser(user);
      }
      await _updateMessageStatusToDelivered(message, user);
      print('[**] send delivered 2');
      await ChatBoxHelper.addChatMessage(user, message);
      print('[**] message added 2');
    }
  }

  void _showNotification(MessageModel message) {
    if (message.senderHost != inChatWithUserhost) {
      NotificationService()
          .showNotification(title: message.senderName, body: message.content);
    }
  }

  Future<void> _updateMyMessageStatus(MessageModel message) async {
    var messages =
        await ChatBoxHelper.getUserMessagesByHost(message.receiverHost);
    for (MessageModel myMsg in messages) {
      if (myMsg.messageStates != MessageStates.read &&
          myMsg.messageStates != message.messageStates) {
        myMsg.messageStates = message.messageStates;
      }
      if (myMsg.dateTime == message.dateTime) {
        myMsg.messageStates = message.messageStates;
        if (message is XOInvitationModel && myMsg is XOInvitationModel) {
          myMsg = message;
        }
        break;
      }
    }
    await ChatBoxHelper.updateMessages(message.receiverHost, messages);
  }

  Future<void> _updateMessageStatusToRead(
      MessageModel message, UserModel user) async {
    if (message.messageStates == MessageStates.delivered) {
      message.messageStates = MessageStates.read;
      await sendMessage(message, user);
    } else {
      return;
    }
  }

  Future<void> _updateMessageStatusToDelivered(
      MessageModel message, UserModel user) async {
    if ((message.messageStates == MessageStates.sending ||
            message.messageStates == MessageStates.sent) &&
        message.senderHost != _server.host) {
      message.messageStates = MessageStates.delivered;
      await sendMessage(message, user);
    } else {
      return;
    }
  }

  void _onConnectionFailed(error, Socket? client) {
    try {
      final int clientIndex = _getClientIindex(client?.address.address ?? '');
      if (clientIndex == -1) return;
      // clients.removeAt(clientIndex).disconnect();
      clients.removeAt(clientIndex);
    } catch (e) {
      print('[+] (chat_provider): Error :$e');
    }
  }

  int _getClientIindex(String host) {
    return clients.indexWhere((client) => client.host == host);
  }
}
