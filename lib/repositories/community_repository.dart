import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/guide_model.dart';
import 'package:nexus/models/post_model.dart';
import 'package:uuid/uuid.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> getAllPosts({Query Function(Query)? queryBuilder}) {
    Query query = _firestore.collection('posts');
    // * use this for the profile section or smth like that

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

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Update the document, adding the userId to the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayUnion([userId]),
        'total_likes': FieldValue.increment(1),
      });

      print("Post liked successfully");
    } catch (e) {
      print("Failed to like post: $e");
    }
  }

  Future<void> dislikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Update the document, removing the userId from the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayRemove([userId]),
        'total_likes': FieldValue.increment(-1),
      });

      print("Post disliked successfully");
    } catch (e) {
      print("Failed to dislike post: $e");
    }
  }

  Future<void> savePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Update the document, adding the userId to the saved_by array
      await postRef.update({
        'saved_by': FieldValue.arrayUnion([userId]),
      });

      print("Post saved successfully");
    } catch (e) {
      print("Failed to like post: $e");
    }
  }

  Future<void> unsavePost({
    required String postId,
    required String userId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Update the document, removing the userId from the saved_by array
      await postRef.update({
        'saved_by': FieldValue.arrayRemove([userId]),
      });

      print("Post unsaved successfully");
    } catch (e) {
      print("Failed to dislike post: $e");
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      // Define the collection reference for the post
      final DocumentReference postDocRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Define the collection reference for the comments sub-collection
      final CollectionReference commentsCollectionRef = FirebaseFirestore
          .instance
          .collection('posts')
          .doc(postId)
          .collection('comments');

      // Delete all documents in the comments sub-collection
      final QuerySnapshot commentsSnapshot = await commentsCollectionRef.get();
      for (DocumentSnapshot doc in commentsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Reference to the storage location
      final storageRef =
          FirebaseStorage.instance.ref().child('posts').child(postId);

      try {
        // List all files in the storage folder
        final ListResult listResult = await storageRef.listAll();

        // Delete each file in the folder if the folder exists
        for (Reference fileRef in listResult.items) {
          await fileRef.delete();
        }
      } catch (e) {
        // If listing fails, it means the folder does not exist
        print("FOLDER DOES NOT EXIST: $e");
      }

      // Finally, delete the Firestore document
      await postDocRef.delete();

      print("POST DELETED SUCCESSFULLY");
    } catch (e) {
      print("CANNOT DELETE POST $e");
    }
  }

  Future<void> addPost({
    required PostModel post,
    required List<dynamic> images,
  }) async {
    try {
      // Hard-code value for now
      final collection = FirebaseFirestore.instance.collection('posts');

      // Add the post document
      DocumentReference docRef = await collection.add(post.toJson());
      await docRef.update({
        'post_id': docRef.id,
        'user_id': 'Bd4umkyLqOLnMpdOLZ0E',
      });

      if (images.isNotEmpty) {
        // Reference to the storage location
        final storageRef =
            FirebaseStorage.instance.ref().child('posts').child(docRef.id);

        // List to hold the download URLs of the uploaded images
        List<String> imageUrls = [];

        // Upload each image and get the download URL
        for (int i = 0; i < images.length; i++) {
          String filename = const Uuid().v1();
          final imageRef = storageRef.child("$filename.jpg");
          await imageRef.putFile(File(images[i].path));
          String downloadUrl = await imageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
        }

        // Update the "images" attribute in the Firebase document
        await docRef.update({'images': imageUrls});
      }

      print('Post added successfully');
    } catch (e) {
      print("CANNOT ADD POST $e");
    }
  }

  Future<void> updatePost({
    required PostModel post,
    required List<dynamic> images,
  }) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('posts').doc(post.postId);

      // Get existing post document
      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic>? docData =
          docSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> existingImages = docData?['images'] ?? [];

      // Reference to the storage location
      final storageRef =
          FirebaseStorage.instance.ref().child('posts').child(docRef.id);

      // List to hold the download URLs of the uploaded images
      List<String> imageUrls = [];
      Set<String> currentImageUrls = {}; // To keep track of images in storage

      // Upload each image and get the download URL
      for (var image in images) {
        if (image is XFile) {
          // Upload the image if it's of type XFile
          String filename = const Uuid().v1();
          final imageRef = storageRef.child("$filename.jpg");
          await imageRef.putFile(File(image.path));
          String downloadUrl = await imageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
          currentImageUrls.add(downloadUrl);
        } else if (image is String) {
          // If image is of type String, it's already uploaded
          imageUrls.add(image);
          currentImageUrls.add(image);
        }
      }

      // Update other attributes (description, permissions, etc.)
      await docRef.update(post.toJson());

      // Update the "images" attribute in the Firebase document
      await docRef.update({'images': FieldValue.arrayUnion(imageUrls)});

      // Clean up old images
      List<String> existingImageUrls = List<String>.from(existingImages);
      for (String url in existingImageUrls) {
        if (!currentImageUrls.contains(url)) {
          // Remove the image URL from Firestore
          await docRef.update({
            'images': FieldValue.arrayRemove([url])
          });

          // Delete the image from Firebase Storage
          try {
            final listResult = await storageRef.listAll();
            for (final item in listResult.items) {
              if (await item.getDownloadURL() == url) {
                await item.delete();
              }
            }
          } catch (e) {
            print("Failed to delete image from storage: $e");
          }
        }
      }

      print('Post updated successfully');
    } catch (e) {
      print("CANNOT UPDATE POST $e");
    }
  }

  // *GUIDES*
  Stream<List<GuideModel>> getAllGuides({Query Function(Query)? queryBuilder}) {
    Query query = _firestore.collection('guides');

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GuideModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> likeGuide({
    required String guideId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('guides').doc(guideId);

      // Update the document, adding the userId to the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayUnion(['Bd4umkyLqOLnMpdOLZ0E']),
        'total_likes': FieldValue.increment(1),
      });

      print("Guide liked successfully");
    } catch (e) {
      print("Failed to like guide: $e");
    }
  }

  Future<void> dislikeGuide({
    required String guideId,
  }) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('guides').doc(guideId);

      // Update the document, removing the userId from the liked_by array
      await postRef.update({
        'liked_by': FieldValue.arrayRemove(["Bd4umkyLqOLnMpdOLZ0E"]),
        'total_likes': FieldValue.increment(-1),
      });

      print("Guide disliked successfully");
    } catch (e) {
      print("Failed to dislike guide: $e");
    }
  }

  Future<List<String>> getLikedBy({required String guideId}) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('guides')
          .doc(guideId)
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> likedBy =
            documentSnapshot.get('liked_by') as List<dynamic>;
        return likedBy.map((item) => item as String).toList();
      } else {
        print('Document does not exist');
        return [];
      }
    } catch (e) {
      print('Error getting liked_by: $e');
      return [];
    }
  }
}
