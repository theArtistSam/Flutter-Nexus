import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexus/models/comment_model.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/post_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getAllComments(
      {Query Function(Query)? queryBuilder, required String documentId}) {
    Query query =
        _firestore.collection('posts').doc(documentId).collection('comments');

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> likeComment({
    required String commentId,
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);

      // Update the document, adding the userId to the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayUnion([userId]),
        'total_likes': FieldValue.increment(1),
      });

      print("Comment liked successfully");
    } catch (e) {
      print("Failed to like comment: $e");
    }
  }

  Future<void> dislikeComment({
    required String commentId,
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);

      // Update the document, removing the userId from the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayRemove([userId]),
        'total_likes': FieldValue.increment(-1),
      });

      print("Comment disliked successfully");
    } catch (e) {
      print("Failed to dislike comment: $e");
    }
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      // hard-code value for now
      final collection =
          _firestore.collection('posts').doc(postId).collection('comments');

      CommentModel comment = CommentModel(
        userId: userId,
        commentId: '',
        text: text,
        likedBy: [],
        totalLikes: 0,
        dateCreated: DateTime.now().toString(),
      );
      DocumentReference docRef = await collection.add(comment.toJson());
      await docRef.update({'comment_id': docRef.id});

      // Get a reference to the post document
      final postCollection = _firestore.collection('posts').doc(postId);

      // Increment the total_comments field by 1
      await postCollection.update({
        'total_comments': FieldValue.increment(1),
      });

      print('Comment added successfully');
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<void> addCommments() async {
    List<CommentModel> comments = [
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_1",
        text: "Great post!",
        likedBy: [],
        totalLikes: 10,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_2",
        text: "Nice work!",
        likedBy: [],
        totalLikes: 5,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_3",
        text: "Very informative.",
        likedBy: [],
        totalLikes: 8,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_4",
        text: "Loved it!",
        likedBy: [],
        totalLikes: 15,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_5",
        text: "Amazing read.",
        likedBy: [],
        totalLikes: 20,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_6",
        text: "Very well explained.",
        likedBy: [],
        totalLikes: 7,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_7",
        text: "Thanks for sharing.",
        likedBy: [],
        totalLikes: 12,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_8",
        text: "Helpful post.",
        likedBy: [],
        totalLikes: 9,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_9",
        text: "Great insights!",
        likedBy: [],
        totalLikes: 14,
        dateCreated: DateTime.now().toString(),
      ),
      CommentModel(
        userId: "Bd4umkyLqOLnMpdOLZ0E",
        commentId: "comment_10",
        text: "Wonderful article.",
        likedBy: [],
        totalLikes: 11,
        dateCreated: DateTime.now().toString(),
      )
    ];
    try {
      // hard-code value for now
      final collection = _firestore
          .collection('posts')
          .doc("3Ah79Owug9qnURGISsYf")
          .collection('comments');

      for (var comment in comments) {
        DocumentReference docRef = await collection.add(comment.toJson());
        await docRef.update({'comment_id': docRef.id});
      }

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }
}
