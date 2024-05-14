part of 'configure_tabs_bloc.dart';

sealed class ConfigureTabsState extends Equatable {
  const ConfigureTabsState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class ConfigureTabsInitial extends ConfigureTabsState {
  int index;
  ConfigureTabsInitial({this.index = 1});

  ConfigureTabsInitial copyWith({int? index}) {
    return ConfigureTabsInitial(index: index ?? this.index);
  }

  @override
  List<Object> get props => [index];
}
