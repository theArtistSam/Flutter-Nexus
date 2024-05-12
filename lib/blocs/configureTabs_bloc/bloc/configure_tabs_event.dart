part of 'configure_tabs_bloc.dart';

sealed class ConfigureTabsEvent extends Equatable {
  const ConfigureTabsEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleTabs extends ConfigureTabsEvent {
  int index;
  ToggleTabs({required this.index});
}
