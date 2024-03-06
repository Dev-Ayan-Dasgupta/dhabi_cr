// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class CriteriaEvent {}

class CriteriaMin8Event extends CriteriaEvent {
  final bool hasMin8;
  CriteriaMin8Event({
    required this.hasMin8,
  });
}

class CriteriaNumericEvent extends CriteriaEvent {
  final bool hasNumeric;
  CriteriaNumericEvent({
    required this.hasNumeric,
  });
}

class CriteriaUpperLowerEvent extends CriteriaEvent {
  final bool hasUpperLower;
  CriteriaUpperLowerEvent({
    required this.hasUpperLower,
  });
}

class CriteriaSpecialEvent extends CriteriaEvent {
  final bool hasSpecial;
  CriteriaSpecialEvent({
    required this.hasSpecial,
  });
}
