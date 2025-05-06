class LoginValidator {
  static String? nameValidator(String? name) {
    if (name == null || name.isEmpty || name.length < 2) {
      return "Name Is Required";
    } else if (name.length > 15) {
      return "Name Is Can be more that 15 chars";
    }

    return null;
  }
}