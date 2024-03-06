// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CurrencyPickerState extends Equatable {
  final bool isPicked;
  final int index;
  const CurrencyPickerState({
    required this.isPicked,
    required this.index,
  });

  @override
  List<Object?> get props => [isPicked, index];
}
