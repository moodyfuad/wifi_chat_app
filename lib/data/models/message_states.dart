
import 'package:hive_flutter/adapters.dart';
@HiveType(typeId: 2)
class MessageStates {
  static const String sending = 'sending';
  static const String sent = 'sent';
  static const String delivered = 'delivered';
  static const String failed = 'failed';
  static const String read = 'read';

  // MessageStates fromStrings(MessageStates state) => MessageStates.fromString(state);
  

  // static MessageStates fromString(String s) => switch (s) {
  //       'sending' => sending,
  //       'sent' => sent,
  //       'delivered' => delivered,
  //       'read' => read,
  //       'failed' => failed,
  //       _ => sending
  //     };
}
