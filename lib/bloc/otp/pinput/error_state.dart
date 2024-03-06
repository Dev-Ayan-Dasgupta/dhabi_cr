// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PinputErrorState extends Equatable {
  final bool isError;
  final bool isComplete;
  final int errorCount;
  const PinputErrorState({
    required this.isError,
    required this.isComplete,
    required this.errorCount,
  });

  @override
  List<Object?> get props => [isError, isComplete, errorCount];
}
