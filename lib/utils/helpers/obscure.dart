class ObscureHelper {
  static String obscureEmail(String email) {
    String obscuredEmail = "";
    int atIndex = email.indexOf("@");
    if (atIndex > 7) {
      for (int i = 0; i < atIndex - 2; i++) {
        if (i < 3) {
          obscuredEmail = obscuredEmail + email[i];
        } else {
          obscuredEmail = "$obscuredEmail*";
        }
      }
      for (int i = atIndex - 2; i < email.length; i++) {
        obscuredEmail = obscuredEmail + email[i];
      }
    } else if (atIndex <= 7 && atIndex > 5) {
      for (int i = 0; i < atIndex - 1; i++) {
        if (i < 2) {
          obscuredEmail = obscuredEmail + email[i];
        } else {
          obscuredEmail = "$obscuredEmail*";
        }
      }
      for (int i = atIndex - 1; i < email.length; i++) {
        obscuredEmail = obscuredEmail + email[i];
      }
    } else if (atIndex <= 5 && atIndex > 1) {
      for (int i = 0; i < atIndex; i++) {
        if (i < 1) {
          obscuredEmail = obscuredEmail + email[i];
        } else {
          obscuredEmail = "$obscuredEmail*";
        }
      }
      for (int i = atIndex; i < email.length; i++) {
        obscuredEmail = obscuredEmail + email[i];
      }
    } else {
      for (int i = 0; i < atIndex; i++) {
        obscuredEmail = "$obscuredEmail*";
      }
      for (int i = atIndex; i < email.length; i++) {
        obscuredEmail = obscuredEmail + email[i];
      }
    }

    return obscuredEmail;
  }

  static String obscurePhone(String phoneNumber) {
    String obscuredPhoneNumber = "";
    for (int i = 0; i < phoneNumber.length - 2; i++) {
      if (i < 5) {
        obscuredPhoneNumber = obscuredPhoneNumber + phoneNumber[i];
      } else {
        obscuredPhoneNumber = "$obscuredPhoneNumber*";
      }
    }
    for (int i = phoneNumber.length - 2; i < phoneNumber.length; i++) {
      obscuredPhoneNumber = obscuredPhoneNumber + phoneNumber[i];
    }
    return obscuredPhoneNumber;
  }

  static String obscureName(String name) {
    String obscuredName = "";
    for (int i = 0; i < name.length - 2; i++) {
      if (i < 2) {
        obscuredName = obscuredName + name[i];
      } else {
        obscuredName = "$obscuredName*";
      }
    }
    for (int i = name.length - 2; i < name.length; i++) {
      obscuredName = obscuredName + name[i];
    }
    return obscuredName;
  }
}
