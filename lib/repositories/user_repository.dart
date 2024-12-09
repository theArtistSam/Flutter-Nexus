import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/models/premium_user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<UserModel> users = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        AccountStatus accountStatus =
            AccountStatus.fromJson(data['account_status']);
        if (accountStatus.isPremium == true) {
          return PremiumUserModel.fromJson(data);
        } else {
          return UserModel.fromJson(data);
        }
      }).toList();

      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<UserModel?> getUserById({required String id}) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(id).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        AccountStatus accountStatus =
            AccountStatus.fromJson(data['account_status']);

        if (accountStatus.isPremium == true) {
          print(data.toString());
          return PremiumUserModel.fromJson(data);
        } else {
          return UserModel.fromJson(data);
        }
      } else {
        print('User with id $id not found.');
        return null;
      }
    } catch (e) {
      print('Error fetching user with id $id: $e');
      return null;
    }
  }

  Future<void> updateUser({
    required UserModel user,
    required XFile? profileImage,
    required XFile? backgroundImage,
  }) async {
    try {
      // Initialize variables to store image URLs
      String? profileURL;
      String? backgroundURL;

      // Update the user model in Firestore first
      await _firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toJson());
      print('User with id ${user.userId} updated successfully in Firestore');

      // Upload the profile picture if provided
      if (profileImage != null) {
        final profileRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(user.userId!) // Use dynamic user ID
            .child(
                'picture.${profileImage.path.split('.').last}'); // Save as 'picture'

        await profileRef.putFile(File(profileImage.path));
        profileURL = await profileRef.getDownloadURL();

        // Update the profile picture URL in Firestore
        await _firestore.collection('users').doc(user.userId).update({
          'profile_pic': profileURL,
        });
        print('Profile picture updated for user ${user.userId}');
      }

      // Upload the background image if provided
      if (backgroundImage != null) {
        final backgroundRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(user.userId!) // Use dynamic user ID
            .child(
                'background.${backgroundImage.path.split('.').last}'); // Save as 'background'

        await backgroundRef.putFile(File(backgroundImage.path));
        backgroundURL = await backgroundRef.getDownloadURL();

        // Update the background image URL in Firestore
        await _firestore.collection('users').doc(user.userId).update({
          'background_pic': backgroundURL,
        });
        print('Background image updated for user ${user.userId}');
      }
    } catch (e) {
      print('Error updating user with id ${user.userId}: $e');
    }
  }

  Future<void> addNewUser({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create a new user model
      UserModel user = UserModel(
        userId: userId,
        email: email,
        biography: 'Add a biography',
        firstName: firstName,
        lastName: lastName,
        startDate: DateTime.now().toString(),
        accountStatus: AccountStatus(isPremium: false, isDeactivated: false),
        profilePic:
            'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/mock_data%2Fprofile-picture.png?alt=media&token=adb6095a-cbcf-4885-aa77-eb80732eadb1',
        backgroundPic:
            'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/mock_data%2Fcontent.png?alt=media&token=e4bbcb71-fa53-4f4f-8481-dde5c7a1e59b',
        guides: Guides(viewedGuides: []),
        appCustomization: AppCustomization(
          isDark: false,
          notificationSettings: NotificationSettings(
            communityNotisEnabled: false,
            appNotisEnabled: false,
          ),
        ),
      );

      // Add the user to Firestore
      await _firestore.collection('users').doc(userId).set(user.toJson());
      print('New user with id $userId added successfully to Firestore');
    } catch (e) {
      print('Error adding new user with id $userId: $e');
      // Optionally rethrow or show a Snackbar here for feedback
      // throw Exception('Failed to add user: $e');
    }
  }
}
