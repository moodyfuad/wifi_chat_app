enum XOInvitationStates {
  pending,
  accepted,
  finished,
  denied;

  static XOInvitationStates fromString(String s) => switch (s) {
        'pending' => pending,
        'accepted' => accepted,
        'denied' => denied,
        'finished' => finished,
        _ => denied,
      };
}
