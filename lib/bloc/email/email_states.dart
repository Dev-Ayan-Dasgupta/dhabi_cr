import 'package:equatable/equatable.dart';

class EmailValidationState extends Equatable {
  final bool isValid;
  const EmailValidationState({
    required this.isValid,
  });

  @override
  List<Object?> get props => [isValid];
}
