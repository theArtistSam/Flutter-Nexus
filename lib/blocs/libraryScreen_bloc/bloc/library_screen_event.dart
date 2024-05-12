part of 'library_screen_bloc.dart';

sealed class LibraryScreenEvent extends Equatable {
  const LibraryScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleView extends LibraryScreenEvent {
  bool isLeftSelected;
  ToggleView({required this.isLeftSelected});
}
