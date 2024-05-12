part of 'library_screen_bloc.dart';

sealed class LibraryScreenState extends Equatable {
  const LibraryScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LibraryScreenInitial extends LibraryScreenState {
  bool isLeftSelected;
  LibraryScreenInitial({this.isLeftSelected = true});

  LibraryScreenInitial copyWith({bool? isLeftSelected}) {
    return LibraryScreenInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected);
  }

  @override
  List<Object> get props => [isLeftSelected];
}
