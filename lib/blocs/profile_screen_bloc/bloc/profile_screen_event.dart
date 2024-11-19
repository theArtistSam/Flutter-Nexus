part of 'profile_screen_bloc.dart';

sealed class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchUserData extends ProfileScreenEvent {}

class FetchUserPosts extends ProfileScreenEvent {}
