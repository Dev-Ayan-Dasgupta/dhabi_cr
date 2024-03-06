// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RequestState extends Equatable {
  final bool isEarly;
  final bool isPartial;
  const RequestState({
    required this.isEarly,
    required this.isPartial,
  });

  @override
  List<Object?> get props => [isEarly, isPartial];
}
