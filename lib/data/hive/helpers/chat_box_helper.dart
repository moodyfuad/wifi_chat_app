import 'package:wifi_chat/data/hive/hive_boxes.dart';
import 'package:wifi_chat/data/models/chat_model.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class ChatBoxHelper {
  static Future<ChatModel> createChat(UserModel user) async {
    var myChat = chatsBox.get(user.host);
    if (myChat == null) {
      await chatsBox.put(user.host, ChatModel(withUser: user));
      return chatsBox.get(user.host)!;
    } else {
      return myChat;
    }
  }

  static Future<void> updateUser(UserModel user,
      {bool createIfNotFount = false}) async {
    var myChat = chatsBox.get(user.host);
    if (myChat == null && createIfNotFount) {
      myChat = await createChat(user);
      myChat.withUser = user;
      await chatsBox.put(user.host, myChat);
    } else if (myChat != null) {
      myChat.withUser = user;
      await chatsBox.put(user.host, myChat);
    }
  }

  static List<ChatModel> getAllChats() {
    return chatsBox.values.toList();
  }

  static Future<List<MessageModel>> getUserMessages(UserModel user) async {
    var chat = chatsBox.get(user.host);
    if (chat == null) {
      print('[+] Hive: no chat found with user ');
      chat = await createChat(user);
    }
    return chat.messages;
  }

  static Future<void> deleteChatMessage(
      String host, MessageModel message) async {
    var chat = chatsBox.get(host);
    if (chat == null) {
      print('[+] Hive: no chat found with user ');
      return;
    }
    chat.messages.removeWhere((msg) => msg.dateTime == message.dateTime);
    await chatsBox.put(host, chat);
  }

  static Future<void> deleteChat(String host) async {
    var chat = chatsBox.get(host);
    if (chat == null) {
      print('[+] Hive: no chat found with user ');
      return;
    }

    await chatsBox.delete(host);
  }

  static Future<List<MessageModel>> getUserMessagesByHost(String host) async {
    var chat = chatsBox.get(host);
    if (chat == null) {
      print('[+] Hive: no chat found with user ');
      return [];
    }
    return chat.messages;
  }

  static Future<void> updateMessages(
      String host, List<MessageModel> messages) async {
    var chat = chatsBox.get(host);
    if (chat == null) {
      print('[+] Hive: no chat found with user ');
      return;
    }
    chat.messages = messages;
    await chatsBox.put(host, chat);
  }

  static Future<void> addChatMessage(
      UserModel user, MessageModel message) async {
    var chat = chatsBox.get(user.host);
    if (chat == null) {
      chat = await createChat(user);
    }
    //
    else {
      int messageIndex =
          chat.messages.indexWhere((msg) => msg.dateTime == message.dateTime);
      if (messageIndex == -1) {
        chat.messages.add(message);
        await chatsBox.put(user.host, chat);
      } else {
        chat.messages[messageIndex] = message;
        await chatsBox.put(user.host, chat);
      }
    }
  }

  static Future<void> addChatMessagebySenderHost(
      String host, MessageModel message) async {
    var chat = chatsBox.get(host);
    if (chat == null) {
      return;
    }
    //
    else {
      int messageIndex =
          chat.messages.indexWhere((msg) => msg.dateTime == message.dateTime);
      if (messageIndex == -1) {
        chat.messages.add(message);
        await chatsBox.put(host, chat);
      } else {
        chat.messages[messageIndex] = message;
        await chatsBox.put(host, chat);
      }
    }
  }
}
