import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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
    on<AddProfileImage>(addProfileImage);
    on<AddBackgroundImage>(addBackgroundImage);
    on<RemoveProfileImage>(removeProfileImage);
    on<RemoveBackgroundImage>(removeBackgroundImage);
    on<UpdateUserCredientials>(updateUserCredientials);
    on<RevertChanges>(revertChanges);

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

  FutureOr<void> addProfileImage(
    AddProfileImage event,
    Emitter<ProfileScreenState> emit,
  ) {
    final currentState = state as ProfileScreenInitial;
    emit(currentState.copyWith(
      profileImage: event.image,
      user: currentState.user,
    ));
  }

  FutureOr<void> addBackgroundImage(
    AddBackgroundImage event,
    Emitter<ProfileScreenState> emit,
  ) {
    final currentState = state as ProfileScreenInitial;
    emit(currentState.copyWith(
      backgroundImage: event.image,
      user: currentState.user,
    ));
  }

  FutureOr<void> removeProfileImage(
    RemoveProfileImage event,
    Emitter<ProfileScreenState> emit,
  ) {
    final currentState = state as ProfileScreenInitial;
    emit(currentState.copyWith(user: currentState.user));
  }

  FutureOr<void> removeBackgroundImage(
    RemoveBackgroundImage event,
    Emitter<ProfileScreenState> emit,
  ) {
    final currentState = state as ProfileScreenInitial;
    emit(currentState.copyWith(user: currentState.user));
  }

  FutureOr<void> updateUserCredientials(
    UpdateUserCredientials event,
    Emitter<ProfileScreenState> emit,
  ) async {
    final currentState = state as ProfileScreenInitial;

    try {
      await UserRepository().updateUser(
        user: currentState.user!,
        profileImage: currentState.profileImage,
        backgroundImage: currentState.backgroundImage,
      );
// Update the state
      add(FetchUserData());
    } catch (e) {
      print("Some Error has gotten occured!");
    }
  }

  FutureOr<void> revertChanges(
      RevertChanges event, Emitter<ProfileScreenState> emit) {
    final currentState = state as ProfileScreenInitial;
    emit(currentState.copyWith(user: event.user));
  }
}
