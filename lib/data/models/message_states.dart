
enum MessageStates {
  sending,
  sent,
  delivered,
  failed,
  read;

  // MessageStates fromStrings(MessageStates state) => MessageStates.fromString(state);
  

  static MessageStates fromString(String s) => switch (s) {
        'sending' => sending,
        'sent' => sent,
        'delivered' => delivered,
        'read' => read,
        'failed' => failed,
        _ => sending
      };
}
