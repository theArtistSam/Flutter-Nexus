part of 'folder_screen_bloc.dart';

sealed class FolderScreenEvent extends Equatable {
  const FolderScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LoadContent extends FolderScreenEvent {
  String folderID;
  LoadContent({required this.folderID});
}
