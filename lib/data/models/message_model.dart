// message_model.dart
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/model_types.dart';

part '../hive/adapters/message_model.g.dart';
@HiveType(typeId: 1)
class MessageModel {
  @HiveField(0)
  final String senderName;
  @HiveField(1)
  final String senderHost;
  @HiveField(2)
  final String receiverHost;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final DateTime dateTime;
  @HiveField(5)
  String messageStates = MessageStates.sending;
  @HiveField(6)
  int sendingAttmpts = 0;

  MessageModel({
    required this.senderName,
    required this.content,
    required this.dateTime,
    required this.senderHost,
    required this.receiverHost,
    this.sendingAttmpts = 0,
    this.messageStates = MessageStates.sending,
  });

  
  Map<String, dynamic> toJson() => {
        JsonKeys.sender: senderName,
        JsonKeys.content: content,
        JsonKeys.senderHost: senderHost,
        JsonKeys.receiverHost: receiverHost,
        JsonKeys.dateTime: dateTime.toString(),
        JsonKeys.messageStates: messageStates,
        JsonKeys.sendingAttmpts: sendingAttmpts,
        JsonKeys.modelType: ModelTypes.message.name, // Add type identifier
      };

  // Create from Map
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        senderName: json[JsonKeys.sender] as String,
        senderHost: json[JsonKeys.senderHost] as String,
        receiverHost: json[JsonKeys.receiverHost] as String,
        content: utf8.decode((json[JsonKeys.content] as String).codeUnits),
        dateTime: DateTime.parse(json[JsonKeys.dateTime]),
        sendingAttmpts: json[JsonKeys.sendingAttmpts] as int,
        messageStates: json[JsonKeys.messageStates] as String,
      );
}
