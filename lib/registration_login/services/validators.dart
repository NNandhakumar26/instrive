class Validators {
  static bool isValidEmail(String? string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static bool isValidPassword(String? string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }
    return true;
  }

  static bool isValidPhoneNumber(String? string) {
    // Null or empty string is invalid
    if (string == null ||
        string.isEmpty ||
        string.length != 10 ||
        (int.tryParse(string) == null)) return false;
    return true;
  }
}
