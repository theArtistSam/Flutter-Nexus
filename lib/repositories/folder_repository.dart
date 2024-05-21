import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/content_repository.dart';

class FolderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FolderModel>> getAllFolders() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E')
          .collection('folder')
          .get();

      List<FolderModel> folderList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FolderModel.fromJson(data);
      }).toList();

      print('Loading _!');
      return folderList;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<List<ContentModel>> getAllFolderContents(
      {required List<String>? contentIDs}) async {
    try {
      // Fetch all contents from the repository
      List<ContentModel> allContents =
          await ContentRepository().getAllContents();

      // Filter the contents to only include those with IDs in the provided list
      List<ContentModel> folderContents = allContents.where((content) {
        return contentIDs!.contains(content.contentId);
      }).toList();

      return folderContents;
    } catch (e) {
      print('Error getting folder contents: $e');
      return [];
    }
  }
}
