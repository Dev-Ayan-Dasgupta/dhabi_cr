import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_event.dart';
import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationCrsBloc
    extends Bloc<ApplicationCrsEvent, ApplicationCrsState> {
  ApplicationCrsBloc()
      : super(
          const ApplicationCrsState(
            showSelectCountry: false,
            showTinPrompt: false,
            showTinTextField: false,
            showTinDropdown: false,
          ),
        ) {
    on<ApplicationCrsEvent>(
      (event, emit) => emit(
        ApplicationCrsState(
          showSelectCountry: event.showSelectCountry,
          showTinPrompt: event.showTinPrompt,
          showTinTextField: event.showTinTextField,
          showTinDropdown: event.showTinDropdown,
        ),
      ),
    );
  }
}
