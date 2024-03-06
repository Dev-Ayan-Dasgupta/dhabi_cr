class InputValidator {
  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPhoneValid(String phone) {
    return RegExp(r"^(?:[+0]9)?[0-9]{11}$").hasMatch(phone);
    // ||
    //     RegExp(r"^(?:[+0]9)?[0-9]{12}$").hasMatch(phone);
  }
}
