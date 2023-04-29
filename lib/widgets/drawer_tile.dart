import 'package:chatz/decoration.dart';
import 'package:flutter/material.dart';

class MyDrawertile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  const MyDrawertile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap:onTap ,
          title: Text(
            title,
            style: TextStyle(
                color: Color(backgroundColor),
                fontSize: 30,
                fontWeight: FontWeight.w600),
          ),
          leading:Icon(icon),
        
        ),
        Divider(color: Color(backgroundColor),thickness: .2),
      ],
    );
  }
}
