import 'package:dialup_mobile_app/bloc/request/request_event.dart';
import 'package:dialup_mobile_app/bloc/request/request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc()
      : super(
          const RequestState(isEarly: false, isPartial: false),
        ) {
    on<RequestEvent>(
      (event, emit) => emit(
        RequestState(isEarly: event.isEarly, isPartial: event.isPartial),
      ),
    );
  }
}
