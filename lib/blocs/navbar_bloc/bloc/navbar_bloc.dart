import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nexus/blocs/edit_bottom_sheet_bloc/bloc/edit_bottom_sheet_bloc.dart';
import 'package:nexus/screens/home/home_screen.dart';
import 'package:nexus/screens/library/library_screen.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  NavbarBloc() : super(NavbarInitial()) {
    on<SwitchScreenEvent>(switchScreenEvent);
  }

  FutureOr<void> switchScreenEvent(
      SwitchScreenEvent event, Emitter<NavbarState> emit) {
    final currentState = state as NavbarInitial;

    emit((currentState).copyWith(index: event.index));
  }
}
