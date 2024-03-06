// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OTPTimerState extends Equatable {
  final int seconds;
  const OTPTimerState({
    required this.seconds,
  });

  @override
  List<Object?> get props => [seconds];
}
