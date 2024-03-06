import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryTileBloc extends Bloc<SummaryTileEvent, SummaryTileState> {
  SummaryTileBloc()
      : super(
          const SummaryTileState(scrollIndex: 0),
        ) {
    on<SummaryTileEvent>(
      (event, emit) => emit(
        SummaryTileState(scrollIndex: event.scrollIndex),
      ),
    );
  }
}
