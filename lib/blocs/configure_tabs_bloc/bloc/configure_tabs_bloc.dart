import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'configure_tabs_event.dart';
part 'configure_tabs_state.dart';

class ConfigureTabsBloc extends Bloc<ConfigureTabsEvent, ConfigureTabsState> {
  ConfigureTabsBloc() : super(ConfigureTabsInitial()) {
    on<ToggleTabs>(toggleTabs);
  }

  FutureOr<void> toggleTabs(
      ToggleTabs event, Emitter<ConfigureTabsState> emit) {
    final currentState = (state as ConfigureTabsInitial);
    emit(currentState.copyWith(index: event.index));
  }
}
