import 'package:chatz/Auth/auth_service.dart';
import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/decoration.dart';
import 'package:chatz/model/user_model.dart';
import 'package:chatz/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'drawer_tile.dart';

class MyyDrawer extends StatefulWidget {
  const MyyDrawer({
    super.key,
  });

  @override
  State<MyyDrawer> createState() => _MyyDrawerState();
}

class _MyyDrawerState extends State<MyyDrawer> {
  _getCurrentUser() async {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    dbProvider.getCurrentUserData(FirebaseAuth.instance.currentUser!.uid);

    UserModel currentUser = await dbProvider
        .getCurrentUserData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    dbProvider.getCurrentUserData(FirebaseAuth.instance.currentUser!.uid);
    _getCurrentUser();

    return FutureBuilder(
      future:
          dbProvider.getCurrentUserData(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            child: Center(
              child: CircularProgressIndicator(
                color: Color(backgroundColor),
              ),
            ),
          );
        }

        return Drawer(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: DrawerHeader(
                  duration: const Duration(seconds: 2),
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ClipRRect(
                        child: Image.network(snapshot.data!.imageUrl!,
                        scale: .50,
                            width: double.infinity, height: double.infinity, fit: BoxFit.fill),
                      ),
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.black38.withOpacity(0.50),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.name!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data!.email!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MyDrawertile(
                  title: 'Profile',
                  icon: Icons.account_circle_outlined,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  ProfileScreen(),
                    ));
                  }),
              MyDrawertile(
                title: 'Sign Out',
                icon: Icons.exit_to_app,
                onTap: () {
                  authProvider.signOut(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
