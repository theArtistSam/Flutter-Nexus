part of 'folder_screen_bloc.dart';

sealed class FolderScreenState extends Equatable {
  const FolderScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class FolderScreenInitial extends FolderScreenState {
  List<ContentModel> folderContents;
  ContentStatus status;
  FolderScreenInitial(
      {this.folderContents = const <ContentModel>[],
      this.status = ContentStatus.loading});

  FolderScreenInitial copyWith(
      {List<ContentModel>? folderContents, ContentStatus? status}) {
    return FolderScreenInitial(
        folderContents: folderContents ?? this.folderContents,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [folderContents, status];
}
