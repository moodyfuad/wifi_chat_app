import 'package:uuid/uuid.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class ChatModel {
  ChatModel({String? id, required this.withUser}){
    this.id = id??const Uuid().v1();
  }
  late String id;
  UserModel withUser;
  List<MessageModel> messages = [];
}
