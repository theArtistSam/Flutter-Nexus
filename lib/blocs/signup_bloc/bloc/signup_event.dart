part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class ValidateInformation extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  const ValidateInformation({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class CreateUser extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const CreateUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class AddUserCredientials extends SignupEvent {
  final String email;
  final String userId;
  final String firstName;
  final String lastName;

  const AddUserCredientials({
    required this.email,
    required this.userId,
    required this.firstName,
    required this.lastName,
  });
}
