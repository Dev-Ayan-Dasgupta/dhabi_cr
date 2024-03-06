// ignore_for_file: public_member_api_docs, sort_constructors_first
class CriteriaState {
  CriteriaState();
}

class CriteriaMin8State extends CriteriaState {
  final bool hasMin8;
  CriteriaMin8State({
    required this.hasMin8,
  });
}

class CriteriaNumericState extends CriteriaState {
  final bool hasNumeric;
  CriteriaNumericState({
    required this.hasNumeric,
  });
}

class CriteriaUpperLowerState extends CriteriaState {
  final bool hasUpperLower;
  CriteriaUpperLowerState({
    required this.hasUpperLower,
  });
}

class CriteriaSpecialState extends CriteriaState {
  final bool hasSpecial;
  CriteriaSpecialState({
    required this.hasSpecial,
  });
}
