import 'package:dialup_mobile_app/bloc/tabBar/tabbar_event.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabbarBloc extends Bloc<TabbarEvent, TabbarState> {
  TabbarBloc()
      : super(
          const TabbarState(index: 0),
        ) {
    on<TabbarEvent>(
      (event, emit) => emit(
        TabbarState(index: event.index),
      ),
    );
  }
}
