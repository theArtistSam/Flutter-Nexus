import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/blocs/folder_bottom_sheet_bloc/bloc/folder_bottom_sheet_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/content_repository.dart';

class FolderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FolderModel>> getAllFolders({
    Query Function(Query)? queryBuilder,
  }) {
    Query query = _firestore
        .collection('users')
        .doc('Bd4umkyLqOLnMpdOLZ0E')
        .collection('folder');
    // * use this for the profile section or smth like that

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FolderModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<ContentModel>> getAllFolderContents({required String folderID}) {
    try {
      // Fetch all contents from the repository with the provided query
      Stream<List<ContentModel>> allContents =
          ContentRepository().getAllContents(
        queryBuilder: (query) => query.where('folder_id', isEqualTo: folderID),
      );

      return allContents;
    } catch (e) {
      print('Error getting folder contents: $e');
      return const Stream.empty();
    }
  }

  Future<void> addFolder({
    required String userId,
    required FolderModel folder,
  }) async {
    try {
      // Define the collection reference
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folder');

      // Add the folder to the database and get the DocumentReference
      DocumentReference docRef = await collection.add(folder.toJson());

      // Update the folder's "folder-id" to the document reference ID
      await docRef.update({'folder_id': docRef.id});

      print('Added the folder with ID: ${docRef.id}');
    } catch (e) {
      print("Some error occurred $e");
    }
  }

  Future<void> deleteFolder(
      {required String userId, required String folderId}) async {
    try {
      // Define the document reference
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folder')
          .doc(folderId);

      // Delete the folder from the database
      await docRef.delete();

      print('Deleted the folder');
    } catch (e) {
      print("Some error occurred while deleting the folder: $e");
    }
  }

  Future<void> updateFolder({
    required String userId,
    required FolderModel folder,
  }) async {
    try {
      // Define the document reference using the folderId from the folder model
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folder')
          .doc(folder.folderId);

      // Update the folder with the new data
      await docRef.update(folder.toJson());

      print('Folder updated successfully');
    } catch (e) {
      print("Some error occurred while updating the folder: $e");
    }
  }

  Future<FolderModel> getFolderById({
    required String userId,
    required String folderId,
  }) async {
    try {
      // Define the document reference
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folder')
          .doc(folderId);

      // Fetch the document snapshot
      final docSnapshot = await docRef.get();

      // Check if the document exists
      final folderData = docSnapshot.data();
      return FolderModel.fromJson(folderData!..['folderId'] = folderId);
    } catch (e) {
      throw ('Error fetching folder: $e');
    }
  }
}
