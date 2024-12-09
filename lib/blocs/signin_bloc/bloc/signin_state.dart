part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

final class SigninInitial extends SigninState {
  final ValidInfoStatus infoStatus;
  final CreateUserStatus createUserStatus;

  const SigninInitial({
    this.infoStatus = ValidInfoStatus.initial,
    this.createUserStatus = CreateUserStatus.initial,
  });

  SigninInitial copyWith({
    ValidInfoStatus? infoStatus,
    CreateUserStatus? createUserStatus,
  }) {
    return SigninInitial(
      infoStatus: infoStatus ?? this.infoStatus,
      createUserStatus: createUserStatus ?? this.createUserStatus,
    );
  }

  @override
  List<Object> get props => [infoStatus, createUserStatus];
}
