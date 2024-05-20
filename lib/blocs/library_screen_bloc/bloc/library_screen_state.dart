part of 'library_screen_bloc.dart';

sealed class LibraryScreenState extends Equatable {
  const LibraryScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LibraryScreenInitial extends LibraryScreenState {
  bool isLeftSelected;
  List<ContentModel> contents;
  ContentStatus status;
  LibraryScreenInitial(
      {this.isLeftSelected = true,
      this.contents = const <ContentModel>[],
      this.status = ContentStatus.loading});

  LibraryScreenInitial copyWith(
      {bool? isLeftSelected,
      List<ContentModel>? contents,
      ContentStatus? status}) {
    return LibraryScreenInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected,
        contents: contents ?? this.contents,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [isLeftSelected, contents, status];
}
