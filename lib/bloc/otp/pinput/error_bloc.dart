import 'package:dialup_mobile_app/bloc/otp/pinput/error_event.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinputErrorBloc extends Bloc<PinputErrorEvent, PinputErrorState> {
  PinputErrorBloc()
      : super(const PinputErrorState(
          isError: false,
          isComplete: false,
          errorCount: 0,
        )) {
    on<PinputErrorEvent>((event, emit) => emit(PinputErrorState(
        isError: event.isError,
        isComplete: event.isComplete,
        errorCount: event.errorCount)));
  }
}
