import 'package:chatz/decoration.dart';
import 'package:chatz/model/user_model.dart';
import 'package:chatz/widgets/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class SearchUserList extends StatefulWidget {
  final String searchText;
  const SearchUserList({super.key, required this.searchText});

  @override
  State<SearchUserList> createState() => _SearchUserListState();
}

class _SearchUserListState extends State<SearchUserList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.discreteCircle(
                  color: Color(logoColor), size: 60),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Searching...',
                style: TextStyle(color: Color(logoColor)),
              )
            ],
          );
        }

        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'No user found!',
                style: TextStyle(color: Color(logoColor)),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final user =
                      UserModel.fromJson(snapshot.data!.docs[index].data());

                  if (user.name!
                      .toLowerCase()
                      .startsWith(widget.searchText.toLowerCase())) {
                    return UserTile(user: user);
                  }

                  return const SizedBox();
                });
          },
        );
      },
    );
  }
}
