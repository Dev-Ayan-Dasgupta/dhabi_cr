import 'package:dialup_mobile_app/bloc/criteria/criteria_event.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CriteriaBloc extends Bloc<CriteriaEvent, CriteriaState> {
  CriteriaBloc() : super(CriteriaState()) {
    on<CriteriaMin8Event>(
        (event, emit) => emit(CriteriaMin8State(hasMin8: event.hasMin8)));
    on<CriteriaNumericEvent>((event, emit) =>
        emit(CriteriaNumericState(hasNumeric: event.hasNumeric)));
    on<CriteriaUpperLowerEvent>((event, emit) =>
        emit(CriteriaUpperLowerState(hasUpperLower: event.hasUpperLower)));
    on<CriteriaSpecialEvent>((event, emit) =>
        emit(CriteriaSpecialState(hasSpecial: event.hasSpecial)));
  }
}
