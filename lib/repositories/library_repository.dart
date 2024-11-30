import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/utils/constants.dart';

class LibraryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ContentModel>> searchContent({
    required String userId,
    required String searchQuery,
  }) {
    // Reference to the user's content collection
    CollectionReference contentRef =
        _firestore.collection('users').doc(userId).collection('content');

    // Prepare a lower case search query for case-insensitive comparison
    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    // Stream that gets the snapshot of the content collection
    Stream<List<ContentModel>> contentStream = contentRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  ContentModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );

    // Stream that filters the content based on the search query
    return contentStream.map((contentList) {
      return contentList.where((content) {
        final titleMatch =
            content.title?.toLowerCase().contains(lowerCaseSearchQuery) ??
                false;
        final typeMatch =
            content.type?.toLowerCase().contains(lowerCaseSearchQuery) ?? false;
        final tagsMatch = content.tags?.any(
                (tag) => tag.toLowerCase().contains(lowerCaseSearchQuery)) ??
            false;
        final dateMatch = content.dateUpdated != null &&
            DateTimeConversion.dateMatches(
                content.dateUpdated!, lowerCaseSearchQuery);

        return titleMatch || typeMatch || tagsMatch || dateMatch;
      }).toList();
    });
  }

  Stream<List<FolderModel>> searchFolder({
    required String userId,
    required String searchQuery,
  }) {
    // Reference to the user's content collection
    CollectionReference contentRef =
        _firestore.collection('users').doc(userId).collection('folder');

    // Prepare a lower case search query for case-insensitive comparison
    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    // Stream that gets the snapshot of the content collection
    Stream<List<FolderModel>> contentStream = contentRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  FolderModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );

    // Stream that filters the content based on the search query
    return contentStream.map((contentList) {
      return contentList.where((content) {
        final titleMatch =
            content.title?.toLowerCase().contains(lowerCaseSearchQuery) ??
                false;
        final dateMatch = content.dateUpdated != null &&
            DateTimeConversion.dateMatches(
                content.dateUpdated!, lowerCaseSearchQuery);
        // Return true if either title or dateUpdated matches the query
        return titleMatch || dateMatch;
      }).toList();
    });
  }
}
