import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_tile.dart';

class UsersList extends StatelessWidget {
  UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    dbProvider.getAllUsers();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        //search user

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return SizedBox();
        }

        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final user =
                  UserModel.fromJson(snapshot.data!.docs[index].data());

              if (user.userId == currentUserId) {
                return const SizedBox();
              }
              return UserTile(user: user);
            });
      },
    );
  }
}
