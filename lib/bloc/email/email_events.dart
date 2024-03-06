// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class EmailValidationEvent {}

class EmailValidatedEvent extends EmailValidationEvent {
  final bool isValid;
  EmailValidatedEvent({
    required this.isValid,
  });
}

class EmailInvalidatedEvent extends EmailValidationEvent {
  final bool isValid;
  EmailInvalidatedEvent({
    required this.isValid,
  });
}
