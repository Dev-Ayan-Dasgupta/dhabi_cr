import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchPasswordBloc extends Bloc<MatchPasswordEvent, MatchPasswordState> {
  MatchPasswordBloc()
      : super(
          const MatchPasswordState(
            isMatch: true,
            count: 0,
          ),
        ) {
    on<MatchPasswordEvent>(
      (event, emit) => emit(
        MatchPasswordState(
          isMatch: event.isMatch,
          count: event.count,
        ),
      ),
    );
  }
}
