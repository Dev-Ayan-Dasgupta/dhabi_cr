// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EmailExistsState extends Equatable {
  final bool emailExists;
  const EmailExistsState({
    required this.emailExists,
  });

  @override
  List<Object?> get props => [emailExists];
}
