import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final void Function() onTapFn;
  const BuildButton(
      {super.key,
      required this.title,
      required this.bgColor,
      required this.onTapFn,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTapFn,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
          backgroundColor: bgColor,
          shape: const StadiumBorder(),
        ),
        child: Text(
         title,
          style: TextStyle(
              color: textColor,
              letterSpacing: .5,
              fontSize: 30,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
