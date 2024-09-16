part of 'post_bottom_sheet_bloc.dart';

sealed class PostBottomSheetEvent extends Equatable {
  const PostBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class SetExistingImages extends PostBottomSheetEvent {
  final List<String> images;
  const SetExistingImages({required this.images});
}

class FetchPost extends PostBottomSheetEvent {
  final PostModel? post;
  const FetchPost({required this.post});
}

class AllowComments extends PostBottomSheetEvent {
  final bool allowComments;
  const AllowComments({required this.allowComments});
}

class AllowLikes extends PostBottomSheetEvent {
  final bool allowLikes;
  const AllowLikes({required this.allowLikes});
}

class AllowShares extends PostBottomSheetEvent {
  final bool allowShares;
  const AllowShares({required this.allowShares});
}

class ChangeVisibility extends PostBottomSheetEvent {
  final bool visibility;
  const ChangeVisibility({required this.visibility});
}

class AddImage extends PostBottomSheetEvent {
  final XFile file;
  const AddImage({required this.file});
}

class AddPost extends PostBottomSheetEvent {
  final String text;
  const AddPost({required this.text});
}

class UpdatePost extends PostBottomSheetEvent {
  final String text;
  const UpdatePost({required this.text});
}

class RemoveImage extends PostBottomSheetEvent {
  final int index;
  const RemoveImage({required this.index});
}
