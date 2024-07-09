import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/post_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> getAllPosts({Query Function(Query)? queryBuilder}) {
    Query query = _firestore
        .collection('posts')
        .where("user_id", isEqualTo: "Bd4umkyLqOLnMpdOLZ0E");

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> addPosts() async {
    List<PostModel> posts = [
      PostModel(
        postId: "post_1",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "This is the first post description.",
        dateCreated: DateTime.now().toString(),
        images: ["image1.jpg", "image2.jpg"],
        totalLikes: 10,
        totalComments: 5,
        totalShares: 2,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_2", "user_3"],
        comments: [
          Comments(
              userId: "user_4",
              text: "Great post!",
              isLiked: true,
              totalLikes: 2),
        ],
      ),
      PostModel(
        postId: "post_2",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Another post with some description.",
        dateCreated: DateTime.now().toString(),
        images: ["image3.jpg"],
        totalLikes: 8,
        totalComments: 3,
        totalShares: 1,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_1", "user_3"],
        comments: [
          Comments(
              userId: "user_5",
              text: "Nice one!",
              isLiked: true,
              totalLikes: 1),
        ],
      ),
      PostModel(
        postId: "post_3",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Yet another interesting post.",
        dateCreated: DateTime.now().toString(),
        images: [],
        totalLikes: 15,
        totalComments: 7,
        totalShares: 3,
        permissions: Permissions(isPrivate: true),
        likedBy: ["user_1", "user_2", "user_4"],
        comments: [
          Comments(
              userId: "user_6",
              text: "Love this!",
              isLiked: true,
              totalLikes: 3),
        ],
      ),
      PostModel(
        postId: "post_4",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "A post with no images.",
        dateCreated: DateTime.now().toString(),
        images: [],
        totalLikes: 5,
        totalComments: 2,
        totalShares: 0,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_3"],
        comments: [],
      ),
      PostModel(
        postId: "post_5",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Check out these pictures.",
        dateCreated: DateTime.now().toString(),
        images: ["image4.jpg", "image5.jpg", "image6.jpg"],
        totalLikes: 20,
        totalComments: 10,
        totalShares: 5,
        permissions: Permissions(isPrivate: true),
        likedBy: ["user_1", "user_2", "user_3", "user_4"],
        comments: [
          Comments(
              userId: "user_2", text: "Awesome!", isLiked: true, totalLikes: 4),
        ],
      ),
      PostModel(
        postId: "post_6",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "An informative post.",
        dateCreated: DateTime.now().toString(),
        images: ["image7.jpg"],
        totalLikes: 12,
        totalComments: 4,
        totalShares: 3,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_5"],
        comments: [
          Comments(
            userId: "user_1",
            text: "Very helpful, thanks!",
            isLiked: true,
            totalLikes: 2,
          ),
        ],
      ),
      PostModel(
        postId: "post_7",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Sharing some thoughts.",
        dateCreated: DateTime.now().toString(),
        images: [],
        totalLikes: 7,
        totalComments: 3,
        totalShares: 2,
        permissions: Permissions(isPrivate: true),
        likedBy: ["user_3", "user_6"],
        comments: [
          Comments(
              userId: "user_5",
              text: "Interesting perspective.",
              isLiked: true,
              totalLikes: 1),
        ],
      ),
      PostModel(
        postId: "post_8",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "A random post.",
        dateCreated: DateTime.now().toString(),
        images: ["image8.jpg", "image9.jpg"],
        totalLikes: 9,
        totalComments: 4,
        totalShares: 1,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_1", "user_7"],
        comments: [
          Comments(
              userId: "user_3",
              text: "Cool post!",
              isLiked: true,
              totalLikes: 2),
        ],
      ),
      PostModel(
        postId: "post_9",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Some updates.",
        dateCreated: DateTime.now().toString(),
        images: ["image10.jpg"],
        totalLikes: 11,
        totalComments: 6,
        totalShares: 4,
        permissions: Permissions(isPrivate: true),
        likedBy: ["user_2", "user_8"],
        comments: [
          Comments(
              userId: "user_4",
              text: "Thanks for sharing.",
              isLiked: true,
              totalLikes: 3),
        ],
      ),
      PostModel(
        postId: "post_10",
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        description: "Final post in the list.",
        dateCreated: DateTime.now().toString(),
        images: ["image11.jpg"],
        totalLikes: 13,
        totalComments: 5,
        totalShares: 2,
        permissions: Permissions(isPrivate: false),
        likedBy: ["user_9", "user_1"],
        comments: [
          Comments(
              userId: "Bd4umkyLqOLnMpdOLZ0E6",
              text: "Great content!",
              isLiked: true,
              totalLikes: 2),
        ],
      ),
    ];

    try {
      // hard-code value for now
      final collection = _firestore.collection('posts');

      for (var post in posts) {
        DocumentReference docRef = await collection.add(post.toJson());
        await docRef.update({'post_id': docRef.id});
      }

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }
}
