import 'package:dialup_mobile_app/bloc/otp/timer/timer_event.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPTimerBloc extends Bloc<OTPTimerEvent, OTPTimerState> {
  OTPTimerBloc() : super(const OTPTimerState(seconds: 30)) {
    on<OTPTimerEvent>(
        (event, emit) => emit(OTPTimerState(seconds: event.seconds)));
  }
}
