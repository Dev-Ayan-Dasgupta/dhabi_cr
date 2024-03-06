import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowButtonBloc extends Bloc<ShowButtonEvent, ShowButtonState> {
  ShowButtonBloc()
      : super(
          const ShowButtonState(show: false),
        ) {
    on<ShowButtonEvent>(
      (event, emit) => emit(
        ShowButtonState(show: event.show),
      ),
    );
  }
}
