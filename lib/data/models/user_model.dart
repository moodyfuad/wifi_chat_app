import 'dart:typed_data';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/model_types.dart';

class UserModel {
  String id;
  String name;
  String host;
  int port;
  Uint8List? profileImage;

  UserModel(
      {required this.host,
      required this.port,
      required this.id,
      required this.name,
      this.profileImage});

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
      );
}
