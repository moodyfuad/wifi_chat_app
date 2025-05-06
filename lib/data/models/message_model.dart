// message_model.dart
import 'dart:convert';

import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/model_types.dart';

class MessageModel {
  final String senderName;
  final String senderHost;
  final String receiverHost;
  final String content;
  final DateTime dateTime;
  MessageStates messageStates = MessageStates.sending;
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
        JsonKeys.messageStates: messageStates.name,
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
        messageStates: MessageStates.fromString(json[JsonKeys.messageStates]),
      );
}
