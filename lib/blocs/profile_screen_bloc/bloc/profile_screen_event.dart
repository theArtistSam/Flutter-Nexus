part of 'profile_screen_bloc.dart';

sealed class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchUserData extends ProfileScreenEvent {}

class FetchUserPosts extends ProfileScreenEvent {}

class AddProfileImage extends ProfileScreenEvent {
  final XFile image;
  const AddProfileImage({required this.image});
}

class AddBackgroundImage extends ProfileScreenEvent {
  final XFile image;
  const AddBackgroundImage({required this.image});
}

class RemoveProfileImage extends ProfileScreenEvent {}

class RemoveBackgroundImage extends ProfileScreenEvent {}

class UpdateUserCredientials extends ProfileScreenEvent {}

class RevertChanges extends ProfileScreenEvent {
  final UserModel user;
  const RevertChanges({required this.user});
}