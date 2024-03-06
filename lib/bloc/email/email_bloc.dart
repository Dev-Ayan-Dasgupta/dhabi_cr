import 'package:dialup_mobile_app/bloc/email/email_events.dart';
import 'package:dialup_mobile_app/bloc/email/email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailValidationBloc
    extends Bloc<EmailValidationEvent, EmailValidationState> {
  EmailValidationBloc() : super(const EmailValidationState(isValid: false)) {
    on<EmailValidatedEvent>(
        (event, emit) => emit(EmailValidationState(isValid: event.isValid)));
    on<EmailInvalidatedEvent>(
        (event, emit) => emit(EmailValidationState(isValid: event.isValid)));
  }
}
