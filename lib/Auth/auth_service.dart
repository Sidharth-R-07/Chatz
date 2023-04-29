import 'dart:io';

import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/model/user_model.dart';
import 'package:chatz/screens/Auth_Screen/sign_in_screen.dart';
import 'package:chatz/screens/all_chats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthService with ChangeNotifier {
  final auth = FirebaseAuth.instance;

  Future registerWithEmailAndPassword(
      UserModel user, String password, File imageFile, BuildContext ctx) async {
    final dbProvider = Provider.of<DbFireStore>(ctx, listen: false);
    try {
      final userCredential = await auth
          .createUserWithEmailAndPassword(
              email: user.email!, password: password)
          .then(
        (_) {
          dbProvider
              .addUserInfo(
                  user: UserModel(
                      name: user.name,
                      email: user.email,
                      phone: user.phone,
                      imageUrl: user.imageUrl,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      bioText: user.bioText,
                      dateOfBirth: user.dateOfBirth,
                      createAt: user.createAt,
                      gender: user.gender),
                  imageFile: imageFile)
              .then(
            (_) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllChatScreen(),
                ),
              );
            },
          );
        },
      );

      print('Register user successfull');
    } on PlatformException catch (err) {
      var errorMessage = 'An error occured please try again !';

      if (err != null) {
        errorMessage = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          action: SnackBarAction(
              label: 'Ok', onPressed: () {}, textColor: Colors.white),
        ),
      );

      print(e);
    }
  }

  Future loginWithEmailAndPassword(
      String email, String password, BuildContext ctx) async {
    try {
      final userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                builder: (context) => const AllChatScreen(),
              )));

      print("Login Successfully");
      print(userCredential.user!.email);
    } on PlatformException catch (err) {
      var errorMessage = 'An error occured please try again !';

      if (err != null) {
        errorMessage = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          action: SnackBarAction(
              label: 'Ok', onPressed: () {}, textColor: Colors.white),
        ),
      );

      print(e);
    }
  }

  Future forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut(BuildContext ctx) async {
    final dbProvider = Provider.of<DbFireStore>(ctx, listen: false);
    try {
      await auth.signOut().then((_) {
        Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (route) => false);

        dbProvider.updateStatus(
            status: 'Offline', currentUserId: auth.currentUser!.uid);
      });
      print('User signed out Successfully');
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          duration: const Duration(seconds: 3),
        ),
      );
      print(e.toString());
    } catch (error) {
      print(error);
    }
  }
}
