import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/model_types.dart';

part '../hive/adapters/user_model.g.dart';
@HiveType(typeId: 3)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String host;
  @HiveField(3)
  int port;
  @HiveField(4)
  Uint8List? profileImage;

  DateTime? discoveredDateTime;

  UserModel(
      {required this.host,
      required this.port,
      required this.id,
      required this.name,
      this.profileImage,
      this.discoveredDateTime});

  Map<String, dynamic> toJson() => {
        JsonKeys.id: id,
        JsonKeys.name: name,
        JsonKeys.host: host,
        JsonKeys.modelType: ModelTypes.user, // Add type identifier
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json[JsonKeys.id] as String,
        name: json[JsonKeys.name] as String,
        host: json[JsonKeys.host] as String,
        port: json[JsonKeys.port] as int,
         discoveredDateTime: json[JsonKeys.dateTime] as DateTime,
      );
}
