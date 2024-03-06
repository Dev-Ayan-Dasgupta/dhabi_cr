import 'package:dialup_mobile_app/bloc/errorMessage/error_message_event.dart';
import 'package:dialup_mobile_app/bloc/errorMessage/error_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorMessageBloc extends Bloc<ErrorMessageEvent, ErrorMessageState> {
  ErrorMessageBloc()
      : super(
          const ErrorMessageState(hasError: false),
        ) {
    on<ErrorMessageEvent>(
      (event, emit) => emit(
        ErrorMessageState(hasError: event.hasError),
      ),
    );
  }
}
