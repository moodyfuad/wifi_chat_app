// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 1;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      senderName: fields[0] as String,
      content: fields[3] as String,
      dateTime: fields[4] as DateTime,
      senderHost: fields[1] as String,
      receiverHost: fields[2] as String,
      sendingAttmpts: fields[6] as int,
      messageStates: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.senderName)
      ..writeByte(1)
      ..write(obj.senderHost)
      ..writeByte(2)
      ..write(obj.receiverHost)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.messageStates)
      ..writeByte(6)
      ..write(obj.sendingAttmpts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
