import 'package:flutter/material.dart';

import '../../decoration.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
   final Function(String val) validatorFn;
  final String imgSrc;
  final String hintTxt;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  const MyTextFormField(
      {super.key,
      required this.controller,
      required this.validatorFn,
      required this.imgSrc,
      required this.hintTxt, required this.keyBoardType, required this.textInputAction, required this.obscureText,});

  @override
  Widget build(BuildContext context) {
    
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return TextFormField(
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofocus: true,
      controller: controller,
      validator: (val)=>validatorFn(val!),
      
      keyboardType: keyBoardType,
      style:  TextStyle(fontSize: deviceHieght*0.03, color: Colors.white),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(width: 2, color: Color(logoColor)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: hintTxt,
          hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
          prefixIcon: Padding(
            padding:  EdgeInsets.all(deviceHieght*0.02),
            child: Image.asset(
              imgSrc,
              width: 8,
              height: 8,
              color: Colors.grey,
            ),
          ),
          fillColor: Color(inputBackgroundColor),
          filled: true),
    );
  }
}
