// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/message_states.dart';
import 'package:wifi_chat/data/models/model_types.dart';
import 'package:wifi_chat/x_o_game/enums/x_o_invitation_states.dart';

class XOInvitationModel extends MessageModel {
  XOInvitationModel(
      {required super.senderName,
      required super.content,
      required super.dateTime,
      required super.senderHost,
      required super.receiverHost,
      super.messageStates,
      super.sendingAttmpts,
      this.state = XOInvitationStates.pending});

  XOInvitationStates state = XOInvitationStates.pending;

  @override
  Map<String, dynamic> toJson() => {
        JsonKeys.sender: senderName,
        JsonKeys.content: content,
        JsonKeys.senderHost: senderHost,
        JsonKeys.receiverHost: receiverHost,
        JsonKeys.dateTime: dateTime.toString(),
        JsonKeys.messageStates: messageStates.name,
        JsonKeys.sendingAttmpts: sendingAttmpts,
        JsonKeys.invitationState: state.name,
        JsonKeys.modelType: ModelTypes.xoInvitation.name, // Add type identifier
      };

  // Create from Map

  factory XOInvitationModel.fromJson(Map<String, dynamic> json) {
    return XOInvitationModel(
        senderName: json[JsonKeys.sender] as String,
        senderHost: json[JsonKeys.senderHost] as String,
        receiverHost: json[JsonKeys.receiverHost] as String,
        content: utf8.decode((json[JsonKeys.content] as String).codeUnits),
        dateTime: DateTime.parse(json[JsonKeys.dateTime]),
        sendingAttmpts: json[JsonKeys.sendingAttmpts] as int,
        messageStates: MessageStates.fromString(json[JsonKeys.messageStates]),
        state: XOInvitationStates.fromString(json[JsonKeys.invitationState]));
  }
}
