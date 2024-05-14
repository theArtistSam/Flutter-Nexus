part of 'styled_tabs_bloc.dart';

sealed class StyledTabsState extends Equatable {
  const StyledTabsState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class StyledTabsInitial extends StyledTabsState {
  bool isLeftSelected;

  StyledTabsInitial({this.isLeftSelected = true});

  StyledTabsInitial copyWith({bool? isLeftSelected}) {
    return StyledTabsInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected);
  }

  @override
  List<Object> get props => [isLeftSelected];
}
