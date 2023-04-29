import 'package:flutter/material.dart';

import '../decoration.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  bool? isbio;
  ProfileTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isbio = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
      child:isbio ==true? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: subtitleTextStyle),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //       height: 100,
              //       width: 300,
              //       child: Text(title,overflow: TextOverflow.clip,maxLines: 3,))
                  Text(
                      title,
                      style: titleTextStyle,
                      overflow: TextOverflow.visible,
                    ),
            ],
          ): Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
            Icon(
              icon,
              color: Color(backgroundColor),
              size: 35,
            ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: subtitleTextStyle),
              const SizedBox(
                height: 10,
              ),
              Text(
                      title,
                      style: titleTextStyle,
                      overflow: TextOverflow.visible,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
