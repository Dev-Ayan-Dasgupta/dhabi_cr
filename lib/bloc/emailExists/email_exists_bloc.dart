import 'package:dialup_mobile_app/bloc/emailExists/email_exists_event.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailExistsBloc extends Bloc<EmailExistsEvent, EmailExistsState> {
  EmailExistsBloc() : super(const EmailExistsState(emailExists: true)) {
    on<EmailExistsEvent>((event, emit) =>
        emit(EmailExistsState(emailExists: event.emailExists)));
  }
}
