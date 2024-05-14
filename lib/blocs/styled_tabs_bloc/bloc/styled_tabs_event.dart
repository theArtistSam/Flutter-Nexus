part of 'styled_tabs_bloc.dart';

sealed class StyledTabsEvent extends Equatable {
  const StyledTabsEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleTabs extends StyledTabsEvent {
  bool isLeftSelected;
  ToggleTabs({required this.isLeftSelected});
}
