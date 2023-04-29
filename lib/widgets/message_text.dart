import 'package:chatz/decoration.dart';
import 'package:flutter/material.dart';

class MessageText extends StatelessWidget {
  final String message;
  final bool isMe;
  final String createAt;

  const MessageText(
      {super.key,
      required this.message,
      required this.isMe,
      required this.createAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: message.length < 25 ? null : 350,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isMe
                    ? Colors.grey.shade300
                    : Color(logoColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                          color: isMe
                              ? Theme.of(context).primaryColor
                              : Color(backgroundColor),
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      createAt.substring(11, 16),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    )
                  ],
                ),
              ),
            ),
            Text(
              '${createAt.substring(0, 10)} ',
              style: const TextStyle(fontSize: 10,color: Colors.grey),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            )
          ],
        ),
      ],
    );
  }
}
