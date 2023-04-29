import 'package:flutter/material.dart';

import '../decoration.dart';
import 'inputfield.dart';

class SignUpForm1 extends StatefulWidget {
  void Function() formIndexFn;
  void Function(String name, String email, String password, String phone)
      formDataFn;
  SignUpForm1({super.key, required this.formIndexFn, required this.formDataFn});

  @override
  State<SignUpForm1> createState() => _SignUpForm1State();
}

class _SignUpForm1State extends State<SignUpForm1> {
  final formkey = GlobalKey<FormState>();

  final userNameContrl = TextEditingController();
  final phonecontrl = TextEditingController();
  final emailcontrl = TextEditingController();
  final passwordcntrl = TextEditingController();
  final conformpasscontrl = TextEditingController();

  bool isloading = false;

  trySubmit(BuildContext ctx) {
    //   setState(() {
    //   isloading = true;
    // });
    // final authProvider=Provider.of<AuthService>(ctx,listen: false);
    // final dbProvider=Provider.of<DbFireStore>(ctx,listen: false);

    FocusScope.of(context).unfocus();
    final isValid = formkey.currentState!.validate();

    if (isValid) {
//    authProvider.registerWithEmailAndPassword(

//     phonecontrl.text,
//     userNameContrl.text.trim(),
//           emailcontrl.text.trim(), passwordcntrl.text.trim(), ctx).then((_) {

// setState(() {
//           isloading = false;
//         });

      // });

      widget.formIndexFn();
      widget.formDataFn(userNameContrl.text.trim(), emailcontrl.text.trim(),
          passwordcntrl.text.trim(), phonecontrl.text.trim());
      print(emailcontrl.text);
      print(passwordcntrl.text);
      print(phonecontrl.text);
      print(userNameContrl.text);
    } else {
      // setState(() {
      //   isloading = false;
      // });
      print('Form Not Valid !!!!!!!!!!!!!!!!!!!!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: Column(
        children: [
          MyTextFormField(
              controller: userNameContrl,
              hintTxt: 'User Name',
              imgSrc: 'Assets/images/user.png',
              keyBoardType: TextInputType.name,
              obscureText: false,
              textInputAction: TextInputAction.next,
              validatorFn: (value) {
                if (value.length < 4) {
                  return 'Please enter valid name';
                }
                return null;
              }),
          SizedBox(
            height: deviceHieght * 0.02,
          ),
          MyTextFormField(
              controller: phonecontrl,
              validatorFn: (value) {
                if (value.length == 10) {
                  return null;
                } else {
                  return 'Please enter valid phone number';
                }
              },
              imgSrc: 'Assets/images/phone.png',
              hintTxt: 'Phone',
              keyBoardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              obscureText: false),
          SizedBox(
            height: deviceHieght * 0.02,
          ),
          MyTextFormField(
              controller: emailcontrl,
              validatorFn: (value) {
                if (value.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return 'Enter a valid email!';
                }
                return null;
              },
              imgSrc: 'Assets/images/email.png',
              hintTxt: 'Email',
              keyBoardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              obscureText: false),
          SizedBox(
            height: deviceHieght * 0.02,
          ),
          MyTextFormField(
              controller: passwordcntrl,
              validatorFn: (value) {
                if (value.isEmpty) {
                  return 'Enter a valid password!';
                } else if (value.length < 6) {
                  return 'Password must be 6 character';
                }
                return null;
              },
              imgSrc: 'Assets/images/password.png',
              hintTxt: 'Password',
              keyBoardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              obscureText: false),
          SizedBox(
            height: deviceHieght * 0.02,
          ),
          MyTextFormField(
              controller: conformpasscontrl,
              validatorFn: (value) {
                if (value != passwordcntrl.text) {
                  return 'Password mismatch please enter correct password!';
                } else if (value.length < 6) {
                  return 'Enter valid password';
                }
                return null;
              },
              imgSrc: 'Assets/images/password.png',
              hintTxt: 'Conform Password',
              keyBoardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: true),
          SizedBox(
            height: deviceHieght * 0.03,
          ),
          ElevatedButton(
            onPressed: () {
              trySubmit(context);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.08,
                  vertical: deviceHieght * 0.01),
              backgroundColor: Color(logoColor),
              shape: const StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "NEXT",
                  style: TextStyle(
                      color: Color(backgroundColor),
                      letterSpacing: .5,
                      fontSize: deviceHieght * 0.03,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(backgroundColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
