// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:uuid/uuid.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/model_types.dart';

class XOPieceModel {
  late String id;
  int? boardIndex;
  String sample;
  XOPieceModel({
    String? id,
    this.boardIndex,
    required this.sample,
  }) {
    this.id = id ?? const Uuid().v1();
  }

  static const String xSample = 'X';
  static const String oSample = 'O';
  static const String noSample = '-';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      JsonKeys.id: id,
      JsonKeys.boardIndex: boardIndex,
      JsonKeys.sample: sample,
      JsonKeys.modelType: ModelTypes.xoPiece.name,
    };
  }

  factory XOPieceModel.fromMap(Map<String, dynamic> map) {
    return XOPieceModel(
      id: map[JsonKeys.id] as String,
      boardIndex: map[JsonKeys.boardIndex] != null
          ? map[JsonKeys.boardIndex] as int
          : null,
      sample: map[JsonKeys.sample] as String,
    );
  }
}
