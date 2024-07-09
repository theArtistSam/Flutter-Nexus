import 'package:flutter/material.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/community_repository.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/user_repository.dart';

class DatabaseStub extends StatefulWidget {
  @override
  _DatabaseStubState createState() => _DatabaseStubState();
}

class _DatabaseStubState extends State<DatabaseStub> {
  late Future<List<UserModel>> _usersFuture;
  late Future<List<ContentModel>> _contentsFuture;

  @override
  void initState() {
    super.initState();
    // _usersFuture = UserRepository().getAllUsers();
    // _contentsFuture = ContentRepository().getAllContents();
    // ContentRepository().addContents();
    CommunityRepository().addPosts();
    // CommunityRepository().getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder<List<ContentModel>>(
        future: _contentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            List<ContentModel> contents = snapshot.data!;
            return ListView.builder(
              itemCount: contents.length,
              itemBuilder: (context, index) {
                ContentModel content = contents[index];
                return ListTile(
                  title: Text('${content.title}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
