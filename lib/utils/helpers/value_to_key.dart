import 'package:dialup_mobile_app/presentation/screens/common/index.dart';

class ValueToKey {
  static String mapPurposeCodeValueToKey(String purposeCodeValue) {
    for (var purposeCode in purposeCodes) {
      if (purposeCode["purposeCodeValue"] == purposeCodeValue) {
        return purposeCode["purposeCodeKey"];
      }
    }
    return "";
  }

  static List<String> chargeCodesValues(List<String> inputs) {
    List<String> res = [];
    for (var input in inputs) {
      res.add(input.split('-').first);
    }
    return res;
  }

  static String generateChargeCodeKey(String value, List<String> inputs) {
    String res = "";

    for (var input in inputs) {
      if (input.contains(value)) {
        res = input.split('-').last;
        break;
      }
    }

    return res;
  }
}
