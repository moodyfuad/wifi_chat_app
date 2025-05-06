enum InvitationState {
  pending,
  accepted,
  finished,
  denied;

  static InvitationState fromString(String s) => switch (s) {
        'pending' => pending,
        'accepted' => accepted,
        'denied' => denied,
        'finished' => finished,
        _ => denied,
      };
      
}
