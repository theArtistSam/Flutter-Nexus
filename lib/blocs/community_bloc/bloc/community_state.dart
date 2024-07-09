part of 'community_bloc.dart';

sealed class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object> get props => [];
}

final class CommunityInitial extends CommunityState {
  final Stream<List<PostModel>> posts;

  const CommunityInitial({this.posts = const Stream.empty()});

  CommunityInitial copyWith({Stream<List<PostModel>>? posts}) {
    return CommunityInitial(posts: posts ?? this.posts);
  }

  @override
  List<Object> get props => [posts];
}
