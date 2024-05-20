import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/content_model.dart';

class ContentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ContentModel>> getAllContents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E')
          .collection('content')
          .get();

      List<ContentModel> contentList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContentModel.fromJson(data);
      }).toList();
      return contentList;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }
  // Future<void> addContents() async {
  //   List<ContentModel> contents = [
  //     ContentModel(
  //       contentId: 'content1',
  //       extractedText: 'Text 1',
  //       dateUpdated: '2024-05-01',
  //       translation: Translation(
  //           text: 'Translated Text 1',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       summarization: Translation(
  //           text: 'Summarized Text 1',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       type: 'Type 1',
  //       title: 'Title 1',
  //       folderId: 'folder1',
  //       thumbnail: 'thumbnail1.jpg',
  //       link: 'http://link1.com',
  //       tags: ['tag1', 'tag2'],
  //     ),
  //     ContentModel(
  //       contentId: 'content2',
  //       extractedText: 'Text 2',
  //       dateUpdated: '2024-05-02',
  //       translation: Translation(
  //           text: 'Translated Text 2',
  //           status: Status(isLiked: false, isDisliked: true)),
  //       summarization: Translation(
  //           text: 'Summarized Text 2',
  //           status: Status(isLiked: false, isDisliked: true)),
  //       type: 'Type 2',
  //       title: 'Title 2',
  //       folderId: 'folder2',
  //       thumbnail: 'thumbnail2.jpg',
  //       link: 'http://link2.com',
  //       tags: ['tag3', 'tag4'],
  //     ),
  //     ContentModel(
  //       contentId: 'content3',
  //       extractedText: 'Text 3',
  //       dateUpdated: '2024-05-03',
  //       translation: Translation(
  //           text: 'Translated Text 3',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       summarization: Translation(
  //           text: 'Summarized Text 3',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       type: 'Type 3',
  //       title: 'Title 3',
  //       folderId: 'folder3',
  //       thumbnail: 'thumbnail3.jpg',
  //       link: 'http://link3.com',
  //       tags: ['tag5', 'tag6'],
  //     ),
  //     ContentModel(
  //       contentId: 'content4',
  //       extractedText: 'Text 4',
  //       dateUpdated: '2024-05-04',
  //       translation: Translation(
  //           text: 'Translated Text 4',
  //           status: Status(isLiked: false, isDisliked: true)),
  //       summarization: Translation(
  //           text: 'Summarized Text 4',
  //           status: Status(isLiked: false, isDisliked: true)),
  //       type: 'Type 4',
  //       title: 'Title 4',
  //       folderId: 'folder4',
  //       thumbnail: 'thumbnail4.jpg',
  //       link: 'http://link4.com',
  //       tags: ['tag7', 'tag8'],
  //     ),
  //     ContentModel(
  //       contentId: 'content5',
  //       extractedText: 'Text 5',
  //       dateUpdated: '2024-05-05',
  //       translation: Translation(
  //           text: 'Translated Text 5',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       summarization: Translation(
  //           text: 'Summarized Text 5',
  //           status: Status(isLiked: true, isDisliked: false)),
  //       type: 'Type 5',
  //       title: 'Title 5',
  //       folderId: 'folder5',
  //       thumbnail: 'thumbnail5.jpg',
  //       link: 'http://link5.com',
  //       tags: ['tag9', 'tag10'],
  //     ),
  //   ];
  //   try {
  //     // hard-code value for now
  //     final collection = _firestore
  //         .collection('users')
  //         .doc('Bd4umkyLqOLnMpdOLZ0E')
  //         .collection('content');

  //     for (var content in contents) {
  //       DocumentReference docRef = await collection.add(content.toJson());
  //       await docRef.update({'content_id': docRef.id});
  //     }

  //     print('Added successfully');
  //   } catch (e) {
  //     print('Error getting users: $e');
  //   }
  // }
}
