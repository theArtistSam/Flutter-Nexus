part of 'library_screen_bloc.dart';

sealed class LibraryScreenState extends Equatable {
  const LibraryScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LibraryScreenInitial extends LibraryScreenState {
  bool isLeftSelected;
  Stream<List<ContentModel>> contents;
  Stream<List<FolderModel>> folders;

  LibraryStatus status;
  LibraryScreenInitial({
    this.isLeftSelected = true,
    this.contents = const Stream.empty(),
    this.status = LibraryStatus.loading,
    this.folders = const Stream.empty(),
  });

  LibraryScreenInitial copyWith({
    bool? isLeftSelected,
    Stream<List<ContentModel>>? contents,
    LibraryStatus? status,
      Stream<List<FolderModel>>? folders,

  }) {
    return LibraryScreenInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected,
        contents: contents ?? this.contents,
        status: status ?? this.status,
        folders: folders ?? this.folders);
  }

  @override
  List<Object> get props => [isLeftSelected, contents, status, folders];
}
