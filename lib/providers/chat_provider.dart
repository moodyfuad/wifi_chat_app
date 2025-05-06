import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wifi_chat/Services/client_socket_services.dart';
import 'package:wifi_chat/Services/notification_services.dart';
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/models/chat_model.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class ChatProvider extends ChangeNotifier {
  final List<ClientSocketServices> clients = [];
  final ServerSocketServices _server = ServerSocketServices();
  String get myHost => _server.host ?? "No Host Yet";
  List<ChatModel> chats = [];

  List<MessageModel> getUserMessages(UserModel user) {
    int chatIndex = _getChatIndex(user.host);
    if (chatIndex == -1) {
      print('[+] No Message With User ${user.name}');
      return [];
    } else {
      List<MessageModel> messages = chats[chatIndex].messages;
      for (MessageModel message in messages.where((msg) =>
          msg.senderHost != _server.host &&
          msg.messageStates != MessageStates.read)) {
        _updateMessageStatusToRead(message, user);
      }
      return messages;
    }
  }

  void startMessagingServer() {
    _server.startServer(
        onObjectReceived: _onObjectReceived,
        onNewClientConnected: _onClientConnected,
        onClientDisconnected: _onClientDisconnected);
  }

  void stopMessageingServer() {
    try {
      _server.stop();
      //* Added
      for (var client in clients) {
        client.disconnect();
        clients.remove(client);
      }
    } catch (_) {}
  }

  Future<void> startChat(UserModel withUser,
      {void Function()? onFailed}) async {
    int clientIndex = _getClientIindex(withUser.host);
    int chatIndex = _getChatIndex(withUser.host);
    //^ the user is new
    if (clientIndex == -1) {
      final client =
          ClientSocketServices(host: withUser.host, name: withUser.name);
      bool success = false;
      await client.connect(
        onConnectionFailed: _onConnectionFailed,
        onConnectionSuccess: (_) {
          clients.add(client);
          if (chatIndex == -1) chats.add(_createChat(withUser));
          success = true;
        },
      );
      if (!success) onFailed?.call();
    }
  }

  Future<void> sendMessage(MessageModel message, UserModel toUser,
      {int resendingLimit = 4}) async {
    _addMyMessageToChats(message);
    final tryingLimit =
        resendingLimit > 0 && resendingLimit < 8 ? resendingLimit : 4;
    //^ the trying attmpts acceeds the limit
    if (message.sendingAttmpts >= tryingLimit &&
        message.senderHost == _server.host) {
      message.messageStates = MessageStates.failed;
      _addMyMessageToChats(message);
      return;
    }
    if (message.senderHost != _server.host) message.sendingAttmpts = 0;

    //^ increase the number of sending attmpts
    message.sendingAttmpts++;
    final int clientIndex = _getClientIindex(toUser.host);
    //^ the client is new
    if (clientIndex == -1) {
      await startChat(toUser);
      await sendMessage(message, toUser);
    }
    //^ the client already exist
    else {
      clients[clientIndex].sendMessage(message);
    }
  }

  void _addMyMessageToChats(MessageModel message) {
    int chatIndex = _getChatIndex(message.receiverHost);
    int messageIndex = _getMessageIndex(chatIndex, message.dateTime);
    if (chatIndex == -1) {
      print("[+] chat not found _addMyMessageToChats");
      return;
    }
    //^ new message
    if (messageIndex == -1) {
      chats[chatIndex].messages.add(message);
    }
    //^ update existed message
    else {
      chats[chatIndex].messages[messageIndex] = message;
    }

    try {
      notifyListeners();
    } catch (_) {}
  }

  void _onClientConnected(Socket client) async {
    final int clientIndex = _getClientIindex(client.remoteAddress.address);
    //^ new client
    if (clientIndex == -1) {
      final newClient =
          ClientSocketServices(host: client.remoteAddress.address, name: '');
      await newClient.connect(
        onConnectionFailed: _onConnectionFailed,
        onConnectionSuccess: (client) {
          clients.add(newClient);
        },
      );
    }
  }

  void _onClientDisconnected(Socket socket) {
    //todo: checl the socket address
    int clientIndex = _getClientIindex(socket.remoteAddress.address);
    if (clientIndex == -1) return;
    try {
      clients.removeAt(clientIndex).disconnect();
    } catch (e) {
      print('[+] (ChatProvider) Error disconnecting :$e');
    }
  }

  void _onObjectReceived(dynamic object) {
    switch (object) {
      case MessageModel message:
        _onMessageReceived(message);
        break;
      default:
    }
  }

  MessageModel? receivedMsg;
  void _onMessageReceived(MessageModel message) {
    //^ this is my updated message
    if (message.senderHost == _server.host) {
      print(
          '[+] my server host:${_server.host}| message sender :${message.senderName}');
      _updateMyMessageStatus(message);
      //^ not my message
    } else {
      int chatIndex = _getChatIndex(message.senderHost);

      NotificationService()
          .showNotification(title: message.senderName, body: message.content);
      //^ if its new user
      if (chatIndex == -1) {
        print("[+] chat not found onMessageReceived");
        final user = UserModel(
            host: message.senderHost,
            port: ServerSocketServices.port,
            id: const Uuid().v1(),
            name: message.senderName);
        var chat = _createChat(user);
        chat.messages.add(message);
        chats.add(chat);
        startChat(user);
        _updateMessageStatusToDelivered(message, chat.withUser);
        //^ if the user already exist
      } else {
        if (chats[chatIndex].withUser.name != message.senderName) {
          chats[chatIndex].withUser.name = message.senderName;
        }
        chats[chatIndex].messages.add(message);
        _updateMessageStatusToDelivered(message, chats[chatIndex].withUser);
      }
    }
    notifyListeners();
  }

  void _updateMyMessageStatus(MessageModel message) {
    int chatIndex = _getChatIndex(message.receiverHost);
    for (MessageModel myMsg in chats[chatIndex].messages) {
      if (myMsg.messageStates != MessageStates.read &&
          myMsg.messageStates != message.messageStates) {
        myMsg.messageStates = message.messageStates;
      }
      if (myMsg.dateTime == message.dateTime) {
        myMsg.messageStates = message.messageStates;
        break;
      }
    }
  }

  //  onMessageReceived?.call(message);
  void _updateMessageStatusToRead(MessageModel message, UserModel user) {
    if (message.messageStates == MessageStates.read) {
      return;
    } else {
      message.messageStates = MessageStates.read;
      sendMessage(message, user);
    }
  }

  void _updateMessageStatusToDelivered(MessageModel message, UserModel user) {
    if (message.messageStates == MessageStates.read ||
        message.messageStates == MessageStates.delivered) {
      return;
    } else {
      message.messageStates = MessageStates.delivered;
      sendMessage(message, user);
    }
  }

  void _onConnectionFailed(error, Socket? client) {
    final int clientInext = _getClientIindex(client?.address.address ?? '');

    if (clientInext == -1) return;
    try {
      clients.removeAt(clientInext).disconnect();
    } catch (e) {
      print('[+] (chat_provider): Error :$e');
    }
  }

  int _getClientIindex(String host) {
    return clients.indexWhere((client) => client.host == host);
  }

  int _getMessageIndex(int chatIndex, DateTime messageDateTime) {
    if (chatIndex == -1) return -1;
    return chats[chatIndex]
        .messages
        .lastIndexWhere((msg) => msg.dateTime == messageDateTime);
  }

  int _getChatIndex(String withUserHost) {
    return chats.indexWhere((chat) => chat.withUser.host == withUserHost);
  }
}

UserModel _createUser(ClientSocketServices client) {
  String id = _getNewId_TEST_();

  return UserModel(
      host: client.host, port: client.port, id: id, name: client.name);
}

ChatModel _createChat(UserModel user) {
  String id = _getNewId_TEST_();
  return ChatModel(id: id, withUser: user);
}

String _getNewId_TEST_() => Random().nextInt(1000).toString();
