import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_event.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollDirectionBloc
    extends Bloc<ScrollDirectionEvent, ScrollDirectionState> {
  ScrollDirectionBloc()
      : super(
          const ScrollDirectionState(scrollDown: true),
        ) {
    on<ScrollDirectionEvent>(
      (event, emit) => emit(
        ScrollDirectionState(scrollDown: event.scrollDown),
      ),
    );
  }
}
