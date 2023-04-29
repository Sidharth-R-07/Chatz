import 'package:flutter/material.dart';

import '../../decoration.dart';
import '../../widgets/signup_form1.dart';
import '../../widgets/signup_form2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  int currentInx = 1;

  String _email = '';
  String _password = '';
  String _phone = '';
  String _name='';
//get  data from form one function and send to form one
  void getFormData(String name,String email, String password, String phone) {
    _email = email;
    _password = password;
    _phone = phone;
    _name=name;

    print('data geted  Email:$_email');
    print('data geted  passwrd:$_password');
    print('data geted  pphone:$_phone');
  }

  _gotoForm2() {
    setState(() {
      currentInx = 2;
    });

    print('index 11111 $currentInx');
  }

  @override
  Widget build(BuildContext context) {
    
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(backgroundColor),
        appBar: AppBar(
          leading: Padding(
            padding:  EdgeInsets.symmetric(horizontal: deviceWidth*0.01),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(logoColor),
                size: deviceHieght*0.05,
              ),
              onPressed: () {
                //back to login screeen
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 10,
              right: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: deviceHieght*0.02,
                ),
                 Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize:deviceHieght*0.07,
                      letterSpacing: 1),
                ),
                 Text(
                  'Please fill the input blow here',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                      fontSize:deviceHieght*0.03,
                      letterSpacing: 4.1),
                ),
                 SizedBox(
                  height: deviceHieght*0.03,
                ),
                currentInx == 2
                    ? SignUpForm2(
                      name: _name,
                        email: _email,
                        password: _password,
                        phone: _phone,
                      )
                    : SignUpForm1(
                        formIndexFn: _gotoForm2,
                        formDataFn: getFormData,
                      ),
                SizedBox(
                  height: deviceHieght*0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Colors.grey, letterSpacing: 1, fontSize: deviceHieght*0.02),
                    ),
                    GestureDetector(
                      onTap: () {
                        //buttun click go to login screen
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "  Sign in",
                        style: TextStyle(
                            color: Color(logoColor),
                            letterSpacing: 1,
                            fontSize: deviceHieght*0.03,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
