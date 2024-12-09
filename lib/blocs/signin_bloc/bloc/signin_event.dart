part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class AddUserCredientials extends SigninEvent {
  final String userId;

  const AddUserCredientials({required this.userId});
}

class ValidateSignin extends SigninEvent {
  final String email;
  final String password;

  const ValidateSignin({required this.email, required this.password});
}

class UpdateLocalPreferences extends SigninEvent {}
