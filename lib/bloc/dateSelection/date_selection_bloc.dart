import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_event.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateSelectionBloc extends Bloc<DateSelectionEvent, DateSelectionState> {
  DateSelectionBloc()
      : super(
          const DateSelectionState(isDateSelected: false),
        ) {
    on<DateSelectionEvent>(
      (event, emit) => emit(
        DateSelectionState(isDateSelected: event.isDateSelected),
      ),
    );
  }
}
