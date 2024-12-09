part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {
  final ValidInfoStatus infoStatus;
  final CreateUserStatus userCreatedStatus;

  const SignupInitial({
    this.infoStatus = ValidInfoStatus.initial,
    this.userCreatedStatus = CreateUserStatus.initial,
  });

  SignupInitial copyWith({
    ValidInfoStatus? infoStatus,
    CreateUserStatus? userCreatedStatus,
  }) {
    return SignupInitial(
      infoStatus: infoStatus ?? this.infoStatus,
      userCreatedStatus: userCreatedStatus ?? this.userCreatedStatus,
    );
  }

  @override
  List<Object> get props => [infoStatus, userCreatedStatus];
}
