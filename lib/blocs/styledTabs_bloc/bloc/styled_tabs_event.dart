part of 'styled_tabs_bloc.dart';

sealed class StyledTabsEvent extends Equatable {
  const StyledTabsEvent();

  @override
  List<Object> get props => [];
}

class ToggleTabs extends StyledTabsEvent {}
