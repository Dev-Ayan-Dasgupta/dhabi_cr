// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SummaryTileState extends Equatable {
  final int scrollIndex;
  const SummaryTileState({
    required this.scrollIndex,
  });

  @override
  List<Object?> get props => [scrollIndex];
}
