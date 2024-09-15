part of 'post_bottom_sheet_bloc.dart';

sealed class PostBottomSheetState extends Equatable {
  const PostBottomSheetState();

  @override
  List<Object> get props => [];
}

final class PostBottomSheetInitial extends PostBottomSheetState {
  final PostModel? post;
  final List<XFile> images;
  final bool showImages;
  const PostBottomSheetInitial({
    this.post,
    this.images = const [],
    this.showImages = false,
  });

  PostBottomSheetInitial copyWith(
      {PostModel? post, List<XFile>? images, bool? showImages}) {
    return PostBottomSheetInitial(
      post: post ?? PostModel(),
      images: images ?? this.images,
      showImages: showImages ?? this.showImages,
    );
  }

  @override
  List<Object> get props => [post ?? PostModel(), images, showImages];
}
