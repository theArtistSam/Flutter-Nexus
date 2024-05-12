import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  NavbarBloc() : super(NavbarInitial()) {
    on<SwitchScreenEvent>(switchScreenEvent);
  }

  FutureOr<void> switchScreenEvent(
      SwitchScreenEvent event, Emitter<NavbarState> emit) {
    emit((state as NavbarInitial).copyWith(index: event.index));
  }
}
