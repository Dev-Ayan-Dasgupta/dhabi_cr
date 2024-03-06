class DaysToMonths {
  static String daysToMonths(int days) {
    String result = "";
    int months = 0;
    int dys = 0;
    int years = 0;
    if (days <= 31) {
      result = "$days day(s)";
    } else if (days <= 365 && days > 31) {
      months = days ~/ 30;
      dys = days % 30;
      result = "$months month(s) and $dys day(s)";
    } else {
      years = days ~/ 365;
      months = (days % 365) ~/ 30;
      dys = (days % 365) % 30;
      result = "$years year(s), $months month(s) and $dys day(s)";
    }
    return result;
  }
}
