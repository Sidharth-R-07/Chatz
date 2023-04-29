import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:chatz/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class DbFireStore with ChangeNotifier {
  Future addUserInfo({required UserModel user, required File imageFile}) async {
//first upload image to cloud storage.then save the link to firestore

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users_dp')
        .child('${user.userId}.jpg');
    final result = await storageRef.putFile(imageFile).whenComplete(
        () => print('file upload to firebase storage succefully'));

    final imageUrl = await result.ref.getDownloadURL();

    print('Url:$imageUrl');
    await FirebaseFirestore.instance.collection('users').doc(user.userId).set({
      'userName': user.name,
      'Phone': user.phone,
      'email': user.email,
      'createAt': user.createAt,
      'userId': user.userId,
      'imageUrl': imageUrl,
      'dateOfBirth': user.dateOfBirth,
      'bioText': user.bioText,
      'gender': user.gender
    });
    print('user data saved to the firestore');
  }

//fetch current user data
  Future<UserModel> getCurrentUserData(String currentUserId) async {
    // Get the current user's ID

    // Build a reference to the user's document in the users collection
    final DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    // Retrieve the user's data from Firestore
    final userData = await userDocRef.get();
    final _user = userData.data();

    if (_user == null) {
      print('-------------Error');
    }
    final userObj = UserModel.fromJson(_user!);
    print(userObj.email);
    print(userObj.name);
    print(userObj.imageUrl);
    print(userObj.userId);

    return userObj;
  }

  Future<List<UserModel>> getAllUsers() async {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final allUserSnap = await collectionRef.get();
    final usersList = allUserSnap.docs.map<UserModel>((user) {
      return UserModel.fromJson(user.data());
    }).toList();
    print(usersList);

    return usersList;
  }

  Future sendMessage(
      String sendBy, String sendTo, String createAt, String message) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(sendBy)
        .collection(sendTo)
        .doc('message')
        .collection('message');
    final collectionUser = FirebaseFirestore.instance
        .collection('chats')
        .doc(sendTo)
        .collection(sendBy)
        .doc('message')
        .collection('message');

    await collectionUser.add({
      'sendBy': sendBy,
      "sendTo": sendTo,
      "createAt": createAt,
      'message': message
    });
    await collectionRef.add({
      'sendBy': sendBy,
      "sendTo": sendTo,
      "createAt": createAt,
      'message': message
    });

    print('Message sent successfully');
  }

  Future saveLastMessage(
      String sendBy, String sendTo, String createAt, String message) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(sendBy)
        .collection(sendTo)
        .doc('last_message');
    final collectionUser = FirebaseFirestore.instance
        .collection('chats')
        .doc(sendTo)
        .collection(sendBy)
        .doc('last_message');
    final getLastMessageSender = await collectionUser.get();
    final getLastMessageReciever = await collectionRef.get();

    if (getLastMessageSender.data() == null ||
        getLastMessageReciever.data() == null) {
      await collectionRef.set({
        'last_message': message,
        'createAt': createAt,
        'sendBy': sendBy,
        'sendTo': sendTo
      });
      await collectionUser.set({
        'last_message': message,
        'createAt': createAt,
        'sendBy': sendBy,
        'sendTo': sendTo
      });
      debugPrint('LAst message saved');
    }
    await collectionRef.update({
      'last_message': message,
      'createAt': createAt,
      'sendBy': sendBy,
      'sendTo': sendTo
    });
    await collectionUser.update({
      'last_message': message,
      'createAt': createAt,
      'sendBy': sendBy,
      'sendTo': sendTo
    });
  }

  //update online offline status in firestore

  updateStatus({required String status, required String currentUserId}) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);
      await userRef.update({'status': status});
      debugPrint('==========================>status updated :$status');
    } catch (err) {
      debugPrint('------------------error.found in updating status');
      print(err);
    }
  }

  Future blockUser(
      {required String userId,
      required String currentUserId,
      required bool isBlocked}) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('chats')
          .doc(currentUserId)
          .collection(userId)
          .doc('block_status');

      final data = await ref.get();

      if (data.data() == null) {
        await ref.set({'isBlocked': isBlocked, 'DateAndTime': DateTime.now()});
      }
      await ref.update({'isBlocked': isBlocked, 'DateAndTime': DateTime.now()});
      debugPrint('Block status Updated  :$isBlocked');
    } catch (err) {
      debugPrint('------------------->Error: $err');
    }
  }

  Future<bool> getBlockStatus(
      {required String userId, required String currentUserId}) async {
    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(currentUserId)
        .collection(userId)
        .doc('block_status');

    final snapshot = await ref.get();

    return snapshot.data() == null ? false : snapshot.data()!['isBlocked'];
  }


  Future<bool> checkUsernameExist(String username) async {
  bool exists = false;
  await FirebaseFirestore.instance
    .collection('users')
    .where('userName', isEqualTo: username)
    .get()
    .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        exists = true;
      }
    });
  return exists;
}




     

  
}
