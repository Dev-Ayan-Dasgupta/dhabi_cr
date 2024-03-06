import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownSelectedBloc
    extends Bloc<DropdownSelectedEvent, DropdownSelectedState> {
  DropdownSelectedBloc()
      : super(
          const DropdownSelectedState(
            isDropdownSelected: false,
            toggles: 0,
          ),
        ) {
    on<DropdownSelectedEvent>(
      (event, emit) => emit(
        DropdownSelectedState(
          isDropdownSelected: event.isDropdownSelected,
          toggles: event.toggles,
        ),
      ),
    );
  }
}
