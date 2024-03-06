import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_event.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiSelectBloc extends Bloc<MultiSelectEvent, MultiSelectState> {
  MultiSelectBloc()
      : super(
          const MultiSelectState(isSelected: false),
        ) {
    on<MultiSelectEvent>(
      (event, emit) => emit(
        MultiSelectState(isSelected: event.isSelected),
      ),
    );
  }
}
