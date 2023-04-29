import 'package:chatz/decoration.dart';
import 'package:chatz/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_text.dart';

class BuildMessage extends StatelessWidget {
  final UserModel user;
  const BuildMessage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    

    print('11111');
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(currentUserId)
            .collection(user.userId!)
            .doc('message')
            .collection('message')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}');
          }

          if ( 
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(backgroundColor),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Card(
                  color: Color(logoColor),
                  child: SizedBox(
                      height: deviceHieght*0.55,
                      width:deviceWidth*0.90,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Oops, No Message Here Yet!',
                              style: TextStyle(
                                color: Color(backgroundColor),
                                fontSize: deviceHieght*0.03,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                             SizedBox(
                              height: deviceHieght*0.01,
                            ),
                            SizedBox(
                              height: deviceHieght*0.30,
                              width: deviceWidth*0.50,
                              child: Image.asset(
                                'Assets/images/no message.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: deviceHieght*0.02,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Say,Hi',
                                  style: TextStyle(
                                    color: Color(backgroundColor),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                 SizedBox(
                              height: deviceHieght*0.02,
                            ),
                                SizedBox(
                                    width:deviceWidth*0.08,
                                    height: deviceHieght*0.08,
                                    child:
                                        Image.asset('Assets/images/hiiiii.png'))
                              ],
                            ),
                          ],
                        ),
                      ))),
            );
          }

          return ListView(
              reverse: true,
              children: snapshot.data!.docs.map(
                (document) {
                  return MessageText(
                    message: document['message'],
                    isMe: document['sendBy'] == currentUserId,
                    createAt: document['createAt'],
                  );
                },
              ).toList());
        });
  }
}
