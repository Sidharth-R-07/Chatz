import 'package:chatz/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../decoration.dart';
import '../screens/message_screen.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  UserTile({super.key, required this.user});

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.099),
            borderRadius: BorderRadius.circular(25)),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(currentUserId)
              .collection(user.userId!)
              .doc('last_message')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(user: user),
                  ),
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              leading: FittedBox(
                fit: BoxFit.cover,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(backgroundColor),
                      radius: 200,
                      backgroundImage: NetworkImage(user.imageUrl!),
                    ),
                    user.status == 'Offline'
                        ? const Positioned(
                            bottom: -3,
                            right: 0,
                            child: CircleAvatar(
                              radius: 72,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 60,
                              ),
                            ),
                          )
                        : const Positioned(
                            bottom: -3,
                            right: 0,
                            child: CircleAvatar(
                              radius: 72,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 60,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              title: Text(
                user.name!,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              subtitle: Row(
                children: [
                  Text(
                    snapshot.data!.data() == null
                        ? 'Say hi'
                        : snapshot.data!.data()!['sendBy'] == currentUserId
                            ? 'You  : '
                            : '${snapshot.data!.data()!['sendBy']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    snapshot.data!.data() == null
                        ? ''
                        : snapshot.data!.data()!['last_message'],
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.data() == null
                          ? ''
                          : snapshot.data!
                              .data()!['createAt']
                              .toString()
                              .substring(11, 16),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Color(logoColor),
                          fontSize: 22),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      snapshot.data!.data() == null
                          ? ''
                          : snapshot.data!
                              .data()!['createAt']
                              .toString()
                              .substring(0, 10),
                      style: const TextStyle(
                          letterSpacing: 1,
                          color: Colors.white60,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
