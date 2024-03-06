import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonFocussedBloc
    extends Bloc<ButtonFocussedEvent, ButtonFocussedState> {
  ButtonFocussedBloc()
      : super(const ButtonFocussedState(
          isFocussed: false,
          toggles: 0,
        )) {
    on<ButtonFocussedEvent>(
      (event, emit) => emit(
        ButtonFocussedState(
          isFocussed: event.isFocussed,
          toggles: event.toggles,
        ),
      ),
    );
  }
}
