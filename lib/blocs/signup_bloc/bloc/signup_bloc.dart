import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus/repositories/user_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<ValidateInformation>(validateInformation);
    on<CreateUser>(createUser);
    on<AddUserCredientials>(addUserCredientials);
  }

  FutureOr<void> validateInformation(
    ValidateInformation event,
    Emitter<SignupState> emit,
  ) {
    final currentState = (state as SignupInitial);
    emit(
      currentState.copyWith(
        userCreatedStatus: currentState.userCreatedStatus,
        infoStatus: ValidInfoStatus.initial,
      ),
    );
    // Extract data from the event
    final String firstName = event.firstName.trim();
    final String lastName = event.lastName.trim();
    final String email = event.email.trim();
    final String password = event.password.trim();
    final String confirmPassword = event.confirmPassword.trim();

    // Perform validation
    if (_isFirstNameValid(firstName) &&
        _isLastNameValid(lastName) &&
        _isValidEmail(email) &&
        _isPasswordValid(password, confirmPassword)) {
      emit(currentState.copyWith(infoStatus: ValidInfoStatus.valid));
    } else {
      emit(currentState.copyWith(infoStatus: ValidInfoStatus.invalid));
    }
  }

  FutureOr<void> createUser(
    CreateUser event,
    Emitter<SignupState> emit,
  ) async {
    final currentState = (state as SignupInitial);

    // Emit the initial state with "creating user" status
    emit(
      currentState.copyWith(
        userCreatedStatus: CreateUserStatus.initial,
        infoStatus: currentState.infoStatus,
      ),
    );

    try {
      // Try creating the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Fetch the userId from the created userCredential
      String userId = userCredential.user?.uid ?? ''; // Ensure user exists

      // Add user credentials to the repository
      add(AddUserCredientials(
        email: event.email,
        userId: userId,
        firstName: event.firstName,
        lastName: event.lastName,
      ));

      emit(
        currentState.copyWith(
          userCreatedStatus: CreateUserStatus.success,
          infoStatus: currentState.infoStatus,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // TODO: FIX this!
        // Email is already in use, handle it as needed
        print("Here!");
        emit(
          currentState.copyWith(
            userCreatedStatus: CreateUserStatus.alreadyExists,
            infoStatus: currentState.infoStatus,
          ),
        );
        print('Error: The email is already in use.');
      } else if (e.code == 'too-many-requests') {
        // Retry after waiting due to too many requests
        await Future.delayed(Duration(seconds: 5));
        print('Re-attempting user creation due to too-many-requests issue.');
      } else {
        // Handle other Firebase errors
        emit(
          currentState.copyWith(
            userCreatedStatus: CreateUserStatus.error,
            infoStatus: currentState.infoStatus,
          ),
        );
        print('Error creating user: ${e.message}');
        return;
      }
    }
  }

  FutureOr<void> addUserCredientials(
    AddUserCredientials event,
    Emitter<SignupState> emit,
  ) async {
    try {
      // If the user does not exist, proceed with adding the new user
      await UserRepository().addNewUser(
        userId: event.userId,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
      );
    } catch (e) {
      print(" Some error: $e");
    }
  }

  // Validate first name
  bool _isFirstNameValid(String firstName) {
    return firstName.isNotEmpty && firstName.length <= 10;
  }

  // Validate last name
  bool _isLastNameValid(String lastName) {
    return lastName.isNotEmpty && lastName.length <= 10;
  }

  // Validate email with a regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  // Validate password and confirm password
  bool _isPasswordValid(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return false;
    }
    if (password != confirmPassword) {
      return false; // Passwords must match
    }
    if (password.length < 8) {
      return false; // Minimum password length
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return false; // Must contain at least one uppercase letter
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return false; // Must contain at least one lowercase letter
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return false; // Must contain at least one number
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false; // Must contain at least one special character
    }
    return true;
  }
}
