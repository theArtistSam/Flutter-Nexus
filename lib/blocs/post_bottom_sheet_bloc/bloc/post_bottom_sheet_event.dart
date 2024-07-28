part of 'post_bottom_sheet_bloc.dart';

sealed class PostBottomSheetEvent extends Equatable {
  const PostBottomSheetEvent();

  @override
  List<Object> get props => [];
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

class PickImage extends PostBottomSheetEvent {
  final XFile file;
  const PickImage({required this.file});
}

class AddPost extends PostBottomSheetEvent {
  final String text;
  const AddPost({required this.text});
}

class UpdatePost extends PostBottomSheetEvent {
  final String text;
  const UpdatePost({required this.text});
}

class ViewImages extends PostBottomSheetEvent {
  final bool showImages;
  const ViewImages({required this.showImages});
}

class DeleteNewImage extends PostBottomSheetEvent {
  final int index;
  const DeleteNewImage({required this.index});
}

class DeleteExistingImage extends PostBottomSheetEvent {
  final int index;
  const DeleteExistingImage({required this.index});
}
