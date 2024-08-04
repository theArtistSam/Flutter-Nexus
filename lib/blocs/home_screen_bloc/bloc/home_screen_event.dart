part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: camel_case_types
class FetchContent extends HomeScreenEvent {}

class FetchGuides extends HomeScreenEvent {}
