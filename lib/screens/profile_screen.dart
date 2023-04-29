import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(backgroundColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(logoColor)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(logoColor),
            fontSize: 24,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: FutureBuilder(
          future: dbProvider.getCurrentUserData(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(backgroundColor),
                ),
              );
            }

            final currentUser = snapshot.data; //get current user data
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Color(logoColor),
                      radius: 130,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(currentUser!.imageUrl!),
                        radius: 125,
                        backgroundColor: Color(backgroundColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileTile(
                    icon: Icons.person_2_outlined,
                    subtitle: 'user name',
                    title: currentUser.name!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                    icon: Icons.email_outlined,
                    subtitle: 'email',
                    title: currentUser.email!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                    icon: Icons.man_2_outlined,
                    subtitle: 'gender',
                    title: currentUser.gender!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                    icon: Icons.date_range,
                    subtitle: 'date of birth',
                    title: currentUser.dateOfBirth!.substring(0, 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                      isbio: true,
                      icon: Icons.email_outlined,
                      subtitle: 'bio',
                      title: currentUser.bioText!),
               
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
