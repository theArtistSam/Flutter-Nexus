part of 'folder_screen_bloc.dart';

sealed class FolderScreenState extends Equatable {
  const FolderScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class FolderScreenInitial extends FolderScreenState {
  Stream<List<ContentModel>> folderContents;
  ContentStatus status;
  FolderModel folder;

  FolderScreenInitial({
    this.folderContents = const Stream.empty(),
    this.status = ContentStatus.loading,
    required this.folder,
  });

  FolderScreenInitial copyWith({
    Stream<List<ContentModel>>? folderContents,
    ContentStatus? status,
    FolderModel? folder,
  }) {
    return FolderScreenInitial(
      folderContents: folderContents ?? this.folderContents,
      status: status ?? this.status,
      folder: folder ?? this.folder,
    );
  }

  @override
  List<Object> get props => [folderContents, status, folder];
}
