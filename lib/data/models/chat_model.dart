import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

part '../hive/adapters/chat_model.g.dart';

@HiveType(typeId: 0)
class ChatModel {
  ChatModel({String? id, required this.withUser}) {
    this.id = id ?? const Uuid().v1();
  }
  @HiveField(0)
  late String id;
  @HiveField(1)
  UserModel withUser;
  @HiveField(2)
  List<MessageModel> messages = [];
}
