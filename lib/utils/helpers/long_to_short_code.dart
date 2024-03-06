import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/constants/dropdowns.dart';

class LongToShortCode {
  static String longToShortCode(String countryLongCode) {
    String shortCode = "";
    for (int i = 0; i < countryLongCodes.length; i++) {
      if (countryLongCode == countryLongCodes[i]) {
        shortCode = dhabiCountries[i]["shortCode"];
      }
    }
    return shortCode;
  }

  static String shortToName(String countryShortCode) {
    String countryName = "";
    for (int i = 0; i < dhabiCountries.length; i++) {
      if (countryShortCode == dhabiCountries[i]["shortCode"]) {
        countryName = dhabiCountries[i]["countryName"];
        break;
      }
    }
    return countryName;
  }
}
