import 'package:hive/hive.dart';

class LocalStorageRepository {
  final box = Hive.box('preferences');

  void addData({
    required String userId,
    required bool appNotis,
    required bool communityNotis,
    required bool isDark,
  }) {
    // Update or add the user data with userId as the key
    box.add({
      'user_id': userId,
      'is_dark': isDark,
      'app_notis_enabled': appNotis,
      'community_notis_enabled': communityNotis,
    });
  }

  void clearBox() {
    box.clear();
  }

  /// Method to print all data in the box
  void printAllData() {
    if (box.isEmpty) {
      print('The box is empty.');
    } else {
      box.toMap().forEach((key, value) {
        print('Key: $key, Value: $value');
      });
    }
  }

  /// Method to get the user_id from the stored data
  String? getUserId() {
    if (box.isEmpty) {
      print('The box is empty.');
      return null;
    } else {
      var firstEntry = box.getAt(0);
      if (firstEntry != null && firstEntry['user_id'] != null) {
        return firstEntry['user_id'];
      }
      return null;
    }
  }
}
