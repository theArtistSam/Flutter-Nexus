// ignore_for_file: must_be_immutable

part of 'content_screen_bloc.dart';

sealed class ContentScreenEvent extends Equatable {
  const ContentScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchFolders extends ContentScreenEvent {}

class ToggleTranslateSummarizeView extends ContentScreenEvent {
  bool isLeftSelected;
  ToggleTranslateSummarizeView({required this.isLeftSelected});
}

class ToggleContainerView extends ContentScreenEvent {
  bool isOriginal;
  ToggleContainerView({required this.isOriginal});
}

class AddTag extends ContentScreenEvent {
  String tag;
  AddTag({
    required this.tag,
  });
}

class RemoveTag extends ContentScreenEvent {
  final String tag;
  const RemoveTag({required this.tag});
}

class AddThumbnail extends ContentScreenEvent {
  XFile file;
  AddThumbnail({required this.file});
}

class RemoveThumbnail extends ContentScreenEvent {}

class DeleteContent extends ContentScreenEvent {}

class ChangeFolder extends ContentScreenEvent {
  final String? folderId;
  const ChangeFolder({this.folderId});
}

class RevertChanges extends ContentScreenEvent {
  final ContentModel content;
  const RevertChanges({required this.content});
}

class UpdateContent extends ContentScreenEvent {}

class FetchContent extends ContentScreenEvent {}

class LikeContent extends ContentScreenEvent {
  final bool value;
  const LikeContent({required this.value});
}

class DislikeContent extends ContentScreenEvent {
  final bool value;
  const DislikeContent({required this.value});
}

class UpdateUpVoteStatus extends ContentScreenEvent {
  final bool likeStatus;
  final bool dislikeStatus;
  const UpdateUpVoteStatus({
    required this.likeStatus,
    required this.dislikeStatus,
  });
}

class UpdateDownVoteStatus extends ContentScreenEvent {
  final bool likeStatus;
  final bool dislikeStatus;
  const UpdateDownVoteStatus({
    required this.likeStatus,
    required this.dislikeStatus,
  });
}

class UpdateSummarizationConfig extends ContentScreenEvent {
  final SummarizationConfig config;
  const UpdateSummarizationConfig({required this.config});
}

class GenerateSummary extends ContentScreenEvent {}

class GenerateTranslation extends ContentScreenEvent {}
