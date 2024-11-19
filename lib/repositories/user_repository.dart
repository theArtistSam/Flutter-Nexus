import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/models/premium_user_model.dart';
import 'package:nexus/repositories/community_repository.dart';

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

  // Future<void> addPremiumUser() async {
  //   Card card = Card(
  //     name: 'John Doe',
  //     cardNumber: '1234567890123456',
  //     cvv: '123',
  //     expiryDate: '12/25',
  //     isActivated: true,
  //   );

  //   PremiumUserModel premiumUser = PremiumUserModel(
  //     userId: 'user123',
  //     email: 'john.doe@example.com',
  //     password: 'securepassword',
  //     firstName: 'John',
  //     lastName: 'Doe',
  //     accountStatus: AccountStatus(isPremium: true, isDeactivated: false),
  //     profilePic: 'path/to/profilePic.jpg',
  //     backgroundPic: 'path/to/backgroundPic.jpg',
  //     biography: 'A short biography',
  //     community:
  //         Community(posts: ['post1', 'post2'], savedPosts: ['savedPost1']),
  //     guides: Guides(viewedGuides: ['guide1', 'guide2']),
  //     appCustomization: AppCustomization(
  //       isDark: true,
  //       notificationSettings: NotificationSettings(
  //         communityNotisEnabled: true,
  //         appNotisEnabled: false,
  //       ),
  //     ),
  //     billingInfos: [card],
  //     subscriptionPlan: 'Premium',
  //     startDate: '2024-01-01',
  //     lastPaymentDate: '2024-01-01',
  //   );
  //   try {
  //     await _firestore.collection('users').add(premiumUser.toJson());
  //     print('Premium user added successfully');
  //   } catch (e) {
  //     print('Error adding premium user: $e');
  //   }
  // }
}
