import 'package:dialup_mobile_app/bloc/currencyPicker/currency_picker_event.dart';
import 'package:dialup_mobile_app/bloc/currencyPicker/currency_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyPickerBloc
    extends Bloc<CurrencyPickerEvent, CurrencyPickerState> {
  CurrencyPickerBloc()
      : super(
          const CurrencyPickerState(isPicked: false, index: -1),
        ) {
    on<CurrencyPickerEvent>(
      (event, emit) => emit(
        CurrencyPickerState(isPicked: event.isPicked, index: event.index),
      ),
    );
  }
}
