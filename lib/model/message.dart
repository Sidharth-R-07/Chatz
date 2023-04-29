import 'package:flutter/material.dart';

class Message with ChangeNotifier{
  final String sendeTo;
  final String sendBy;

  final String message;
  final String dateTime;

  Message({

    required this.sendeTo,
    required this.sendBy,
    required this.message,
    required this.dateTime,
  });

     Message.fromJson(Map<String, dynamic> json)
      : sendBy = json['sendBy'],
        sendeTo = json['sendeTo'],
      
        message=json['message'],
        dateTime=json['dateTime'];



}
