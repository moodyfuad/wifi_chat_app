enum InvitationState {
  pending,
  accepted,
  denied;

  static InvitationState fromString(String s) => switch (s) {
        'pending' => pending,
        'accepted' => accepted,
        'denied' => denied,
        _ => denied,
      };
      
}
