import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'styled_tabs_event.dart';
part 'styled_tabs_state.dart';

class StyledTabsBloc extends Bloc<StyledTabsEvent, StyledTabsState> {
  StyledTabsBloc() : super(StyledTabsInitial()) {
    on<ToggleTabs>(toggleTabs);
  }

  FutureOr<void> toggleTabs(ToggleTabs event, Emitter<StyledTabsState> emit) {
    final currentState = (state as StyledTabsInitial);
    emit((currentState).copyWith(isLeftSelected: !currentState.isLeftSelected));
  }
}
