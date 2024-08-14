part of 'content_screen_bloc.dart';

sealed class ContentScreenState extends Equatable {
  const ContentScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class ContentScreenInitial extends ContentScreenState {
  // Maintain the state of the tabs
  final bool isLeftSelected;
  //  Maintain the state of the original vs AI text OR Check the model
  final bool isOriginal;
  // NOT required: Create a separate events to handle likes and dislikes
  final bool isLiked;

  final ContentModel content;
  final List<FolderModel> folders;
  final XFile? image;

  const ContentScreenInitial({
    this.isLeftSelected = true,
    this.isOriginal = false,
    this.isLiked = false,
    required this.content,
    this.folders = const <FolderModel>[],
    this.image,
  });

  ContentScreenInitial copyWith({
    bool? isLeftSelected,
    bool? isOriginal,
    bool? isLiked,
    ContentModel? content,
    List<FolderModel>? folders,
    XFile? image,
  }) {
    return ContentScreenInitial(
      isLeftSelected: isLeftSelected ?? this.isLeftSelected,
      isOriginal: isOriginal ?? this.isOriginal,
      isLiked: isLiked ?? this.isLiked,
      content: content ?? this.content,
      folders: folders ?? this.folders,
      image: image,
    );
  }

  @override
  List<Object> get props => [
        isLeftSelected,
        isOriginal,
        isLiked,
        content,
        folders,
        image ?? '',
      ];
}
