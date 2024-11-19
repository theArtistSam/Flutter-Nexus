import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/community_repository.dart';
import 'package:nexus/repositories/user_repository.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final String userId;
  ProfileScreenBloc({required this.userId})
      : super(ProfileScreenInitial(userId: userId)) {
    on<FetchUserData>(fetchUserData);
    on<FetchUserPosts>(fetchUserPosts);

    add(FetchUserPosts());
    add(FetchUserData());
  }

  FutureOr<void> fetchUserData(
    FetchUserData event,
    Emitter<ProfileScreenState> emit,
  ) async {
    try {
      final currentState = state as ProfileScreenInitial;
      final user = await UserRepository().getUserById(id: userId);
      emit(currentState.copyWith(user: user, posts: currentState.posts));
    } catch (e) {
      // TODO: Manage Error States
      print("Some Shit Occured!$e");
    }
  }

  FutureOr<void> fetchUserPosts(
    FetchUserPosts event,
    Emitter<ProfileScreenState> emit,
  ) {
    try {
      final currentState = state as ProfileScreenInitial;
      final Stream<List<PostModel>> posts = CommunityRepository().getAllPosts(
        queryBuilder: (query) => query.where('user_id', isEqualTo: userId),
      );
      emit(currentState.copyWith(posts: posts, user: currentState.user));
    } catch (e) {
      // Handle Error States
      print("Error fetching user posts: $e");
    }
  }
}
