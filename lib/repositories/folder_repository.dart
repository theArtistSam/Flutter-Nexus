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

  Stream<List<ContentModel>> getAllFolderContents({required String folderID}) {
    try {
      // Fetch all contents from the repository with the provided query
      Stream<List<ContentModel>> allContents = ContentRepository()
          .getAllContents(
              queryBuilder: (query) =>
                  query.where('folder_id', isEqualTo: folderID));

      return allContents;
    } catch (e) {
      print('Error getting folder contents: $e');
      return const Stream.empty();
    }
  }
}
