import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class ChatModel {
  ChatModel({required this.id, required this.withUser});
  String id;
  UserModel withUser;
  List<MessageModel> messages = [];
}
