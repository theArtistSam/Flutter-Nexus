part of 'content_screen_bloc.dart';

sealed class ContentScreenState extends Equatable {
  const ContentScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class ContentScreenInitial extends ContentScreenState {
  bool isLeftSelected; // Maintain the state of the tabs
  bool
      isOriginal; //  Maintain the state of the original vs AI text OR Check the model
  bool
      isLiked; // NOT required: Create a separate events to handle likes and dislikes

  ContentModel? content;
  List<FolderModel> folders;
  ContentScreenInitial(
      {this.isLeftSelected = true,
      this.isOriginal = false,
      this.isLiked = false,
      this.content,
      this.folders = const <FolderModel>[]});

  ContentScreenInitial copyWith(
      {bool? isLeftSelected,
      bool? isOriginal,
      bool? isLiked,
      ContentModel? content,
      List<FolderModel>? folders}) {
    return ContentScreenInitial(
      isLeftSelected: isLeftSelected ?? this.isLeftSelected,
      isOriginal: isOriginal ?? this.isOriginal,
      isLiked: isLiked ?? this.isLiked,
      content: content ?? ContentModel(),
      folders: folders ?? this.folders,
    );
  }

  @override
  List<Object> get props =>
      [isLeftSelected, isOriginal, isLiked, content ?? ContentModel(), folders];
}
