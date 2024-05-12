part of 'navbar_bloc.dart';

sealed class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SwitchScreenEvent extends NavbarEvent {
  int index;

  SwitchScreenEvent({required this.index});

  @override
  List<Object> get props => [index];
}
