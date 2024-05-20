import 'package:flutter/material.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/user_repository.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<UserModel>> _usersFuture;
  late Future<List<ContentModel>> _contentsFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserRepository().getAllUsers();
    _contentsFuture = ContentRepository().getAllContents();
    // ContentRepository().addContents();
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
