import 'package:dialup_mobile_app/bloc/createPassword/create_password_event.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePasswordBloc
    extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  CreatePasswordBloc()
      : super(
          const CreatePasswordState(allTrue: false),
        ) {
    on<CreatePasswordEvent>(
      (event, emit) => emit(
        CreatePasswordState(allTrue: event.allTrue),
      ),
    );
  }
}
