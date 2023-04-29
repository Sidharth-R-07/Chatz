import 'package:chatz/Auth/auth_service.dart';

import 'package:flutter/material.dart';

import '../../decoration.dart';
import '../../widgets/inputfield.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool isLoading = false;

  void submit(String email, String password, BuildContext ctx) {
    final auth = AuthService();
    setState(() {
      isLoading = true;
    });

    auth
        .loginWithEmailAndPassword(email, password, ctx)
        .then((value) => setState(() {
              isLoading = false;
            }))
        .catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
                      child: Center(
                        child: Image.asset(
                          'Assets/images/chatz _logo.png',
                          fit: BoxFit.cover,
                          height: deviceHieght * .20,
                          color: Color(logoColor),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'ChatZ',
                        style: TextStyle(
                            color: Color(logoColor),
                            fontWeight: FontWeight.w700,
                            fontSize: deviceHieght*0.06,
                            letterSpacing: 5),
                      ),
                    ),
                    SizedBox(
                      height: deviceHieght * 0.02,
                    ),
                     Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHieght*0.05,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5),
                    ),
                    SizedBox(
                      height: deviceHieght * 0.02,
                    ),
                     Text(
                      'Please sign in to continue.',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: deviceHieght*0.03,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.5),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MyTextFormField(
                      controller: emailController,
                      hintTxt: 'Email',
                      imgSrc: 'Assets/images/email.png',
                      keyBoardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validatorFn: (value) {
                        if (value.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextFormField(
                        controller: passwordController,
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
                        textInputAction: TextInputAction.done,
                        obscureText: true),
              
              //----------------------------------Login button------------------------------------------
                    SizedBox(
                      height: deviceHieght * 0.02,
                    ),
                    Center(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(logoColor),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                final isValid = formkey.currentState!.validate();
              
                                if (isValid) {
                                  submit(emailController.text.trim(),
                                      passwordController.text.trim(), context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 5.0),
                                backgroundColor: Color(logoColor),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Color(backgroundColor),
                                    letterSpacing: .5,
                                    fontSize: deviceHieght*0.03,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
              
              //--------------------- forgot password section ---------------------------------------
                    SizedBox(height: deviceHieght * 0.01),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          debugPrint('forgot password clicked');
              
                          //Navigate to forgot password screen
              
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color(logoColor),
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHieght * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.grey, letterSpacing: 1, fontSize: deviceHieght*0.02),
                        ),
                        TextButton(
                          style: const ButtonStyle(
                              splashFactory: NoSplash.splashFactory),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                          child: Text(
                            "  Sign up",
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
        ),
      ),
    );
  }
}
