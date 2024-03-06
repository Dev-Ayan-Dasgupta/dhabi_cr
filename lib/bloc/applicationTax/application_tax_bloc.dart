import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_event.dart';
import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationTaxBloc
    extends Bloc<ApplicationTaxEvent, ApplicationTaxState> {
  ApplicationTaxBloc()
      : super(
          ApplicationTaxState(
            isUSCitizen: false,
            isUSResident: false,
            isPPonly: true,
            isTINvalid: false,
            isCRS: false,
            hasTIN: false,
          ),
        ) {
    on<ApplicationTaxEvent>(
      (event, emit) => emit(
        ApplicationTaxState(
          isUSCitizen: event.isUSCitizen,
          isUSResident: event.isUSResident,
          isPPonly: event.isPPonly,
          isTINvalid: event.isTINvalid,
          isCRS: event.isCRS,
          hasTIN: event.hasTIN,
        ),
      ),
    );
  }
}
