import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/local_storage_repository.dart';
import 'package:nexus/repositories/user_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitial()) {
    on<AddUserCredientials>(addUserCredientials);
    on<ValidateSignin>(validateSignin);
  }

  FutureOr<void> addUserCredientials(
    AddUserCredientials event,
    Emitter<SigninState> emit,
  ) async {
    try {
      // Check if the user already exists in the Firestore collection
      final UserModel? userDoc =
          await UserRepository().getUserById(id: event.userId);

      if (userDoc != null) {
        print(
            "User already exists. Updating user credentials and local storage.");

        // Fetch AppCustomization or other necessary fields from Firestore
        final AppCustomization? appCustomization = userDoc.appCustomization;

        if (appCustomization != null) {
          // Check if notificationSettings is not null before accessing its properties
          final notificationSettings = appCustomization.notificationSettings;
          if (notificationSettings != null) {
            LocalStorageRepository().addData(
              userId: event.userId,
              appNotis: notificationSettings.communityNotisEnabled ?? false,
              communityNotis: notificationSettings.appNotisEnabled ?? false,
              isDark: appCustomization.isDark ?? false,
            );
          } else {
            print("No notification settings found for the user.");
          }
        } else {
          print("No app customization found for the user.");
        }

        return; // Exit early if user already exists
      }
    } catch (e) {
      print("Error creating or updating user: $e");
      emit(
        (state as SigninInitial).copyWith(infoStatus: ValidInfoStatus.invalid),
      );
    }
  }

  // Method to validate the signin credentials and handle logic accordingly
  FutureOr<void> validateSignin(
    ValidateSignin event,
    Emitter<SigninState> emit,
  ) async {
    // Signout any existing user
    await _signout();
    emit(
        (state as SigninInitial).copyWith(infoStatus: ValidInfoStatus.initial));

    final String email = event.email.trim();
    final String password = event.password.trim();
    try {
      // Sign in the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access the user info (e.g., UID)
      User? user = userCredential.user;
      if (user != null) {
        print("Logged in as ${user.email}, UID: ${user.uid}");

        String userId = user.uid;
        print("User ID: $userId");

        // Once the user is validated, just update the local storage credientials!
        add(AddUserCredientials(userId: userId));

        // Emit valid state if login is successful
        emit((state as SigninInitial)
            .copyWith(infoStatus: ValidInfoStatus.valid));
      }
    } catch (e) {
      // Emit invalid state if there was an error logging in
      emit((state as SigninInitial)
          .copyWith(infoStatus: ValidInfoStatus.invalid));

      print("Failed to login: $e");
    }
  }

  Future<void> _signout() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Revoke all refresh tokens for the currently logged-in user
        await currentUser.getIdTokenResult(true);
        await FirebaseAuth.instance.signOut();

        print("All users logged out successfully.");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error logging out all users: $e");
    }
  }
}
