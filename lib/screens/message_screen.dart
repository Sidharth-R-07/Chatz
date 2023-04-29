import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/decoration.dart';
import 'package:chatz/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/build_messages.dart';

class MessageScreen extends StatefulWidget {
  final UserModel user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final messageContrl = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  bool sendLoading = false;
  bool _blockStatus = false;
  bool isLoading = false;
//----------------------bottom sheet for conform block user----------------------------------
  _openBottomSheet(ctx) {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);

    return showModalBottomSheet(
      backgroundColor: Color(backgroundColor),
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 40,
      ),
      builder: (context) => Container(
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.black.withOpacity(.001)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
          child: Column(
            children: [
              Text(
                _blockStatus == true
                    ? 'Are you sure you want\n to Unblock user?'
                    : 'Are you sure you want\n to block user?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 35,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible,
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(logoColor),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 7.0),
                        backgroundColor: Color(logoColor),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        //conform the block the user

                        setState(() {
                          isLoading = true;
                          _blockStatus = !_blockStatus;
                        });

                        debugPrint('------------>Block Status  :$_blockStatus');

                        dbProvider
                            .blockUser(
                                userId: widget.user.userId!,
                                currentUserId: currentUserId,
                                isBlocked: _blockStatus)
                            .then((_) {
                          Navigator.of(context).pop();
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          _blockStatus == true ? 'Unblock' : 'Block',
                          style: TextStyle(
                              color: Color(backgroundColor),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  //go back

                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getBlockStatus() async {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    final _isBlocked = await dbProvider.getBlockStatus(
        userId: widget.user.userId!, currentUserId: currentUserId);
    setState(() {
      _blockStatus = _isBlocked;
    });

    dbProvider.blockUser(
        userId: widget.user.userId!,
        currentUserId: currentUserId,
        isBlocked: _blockStatus);
  }

  @override
  void initState() {
    // TODO: implement initState
    _getBlockStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(backgroundColor),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.imageUrl!),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name!,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                _blockStatus == true
                    ? const Text(
                        'You blocked this User!',
                        style: TextStyle(fontSize: 10, letterSpacing: 1),
                      )
                    : Text(
                        widget.user.status == null
                            ? 'Offline'
                            : widget.user.status!,
                        style: TextStyle(
                            color: widget.user.status == 'Online'
                                ? Colors.green
                                : null,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1),
                      ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                //conformation for block the user.open bottom sheet
                _openBottomSheet(context);
              },
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    'Assets/images/block user.png',
                    color: Colors.red,
                  )),
            ),
          )
        ],
      ),
//---------------------message selction--------------------------
      body: Column(
        children: [
          Expanded(
              child: BuildMessage(
            user: widget.user,
          )),

//--------------------------message text field---------------------------------------------
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(currentUserId)
                  .collection(widget.user.userId!)
                  .doc('block_status')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.data!.data() != null) {
                  _blockStatus = snapshot.data!['isBlocked'];
                }

                if (snapshot.data == null) {
                  _blockStatus = false;
                }

                if (snapshot.data!['isBlocked'] == true) {
                  return _buildBlockMessage();
                }
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(15)),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message'),
                          controller: messageContrl,
                        ),
                      ),
                      sendLoading
                          ? Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Color(backgroundColor),
                                    strokeWidth: 2,
                                  )),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  sendLoading = true;
                                });

                                if (messageContrl.text.isEmpty ||
                                    messageContrl.text == '') {
                                  return;
                                }
                                dbProvider
                                    .sendMessage(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.user.userId!,
                                        DateTime.now().toIso8601String(),
                                        messageContrl.text)
                                    .then((_) {
                                  dbProvider.saveLastMessage(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      widget.user.userId!,
                                      DateTime.now().toIso8601String(),
                                      messageContrl.text);
                                  messageContrl.clear();
                                  setState(() {
                                    sendLoading = false;
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.send,
                                color: Color(backgroundColor),
                                size: 40,
                              ),
                            ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Padding _buildBlockMessage() {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    padding:const EdgeInsets.symmetric(vertical: 25,horizontal: 20),

                    decoration: BoxDecoration(color: Color(inputBackgroundColor),borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      'Sorry, you cannot send a message to this user,\nBecouse You blocked this user!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(logoColor),letterSpacing: 1,fontSize: 22),
                    ),
                  ),
                );
  }
}
