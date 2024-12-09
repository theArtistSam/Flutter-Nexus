part of 'community_bloc.dart';

sealed class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object> get props => [];
}

final class CommunityInitial extends CommunityState {
  final Stream<List<PostModel>> posts;
  final Stream<List<GuideModel>> guides;

  const CommunityInitial({
    this.posts = const Stream.empty(),
    this.guides = const Stream.empty(),
  });

  CommunityInitial copyWith({
    Stream<List<PostModel>>? posts,
    Stream<List<GuideModel>>? guides,
    String? userName,
    String? profilePicture,
  }) {
    return CommunityInitial(
      posts: posts ?? this.posts,
      guides: guides ?? this.guides,
    );
  }

  @override
  List<Object> get props => [
        posts,
        guides,
      ];
}
