import 'package:chatz/Auth/auth_service.dart';
import 'package:chatz/screens/Auth_Screen/sign_in_screen.dart';
import 'package:chatz/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../decoration.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emaicontroller = TextEditingController();
//check is email send button clicked  or not
  bool _emailSended = false;
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  _openBottomSheet(BuildContext ctx) {
    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(.001),
      context: ctx,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color(backgroundColor),
          borderRadius: BorderRadius.circular(35),
        ),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                'Verification mail send successfully!',
                style: TextStyle(
                    color: Color(logoColor),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Please check the email we sent you and click the link to rest your password. Should you not recieve this email within minutes,please check your 'Spam' folder.You must verify your email address before signing in.",
                style: TextStyle(
                    color: Color(logoColor),
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                  backgroundColor: Color(logoColor),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  "Yes,I Understood!",
                  style: TextStyle(
                      color: Color(backgroundColor),
                      letterSpacing: .5,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(backgroundColor),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(logoColor)),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(
            'Forgot password',
            style: TextStyle(
              color: Color(logoColor),
              fontSize: 24,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(25),
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Card(
              color: Color(inputBackgroundColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot your password',
                      style: TextStyle(
                          color: Color(logoColor),
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Please enter the email address you'd like your password reset information sent to.",
                      style: TextStyle(
                          color: Color(logoColor),
                          fontSize: 25,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Form(
                      key: formkey,
                      child: MyTextFormField(
                          controller: emaicontroller,
                          validatorFn: (value) {
                            if (value.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email!';
                            }
                            return null;
                          },
                          imgSrc: 'Assets/images/email.png',
                          hintTxt: 'email',
                          keyBoardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          obscureText: false),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: _emailSended
                          ? Text(
                              'Email sent sucessfully   go to login',
                              style: TextStyle(
                                  color: Color(logoColor), fontSize: 15),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                final validated =
                                    formkey.currentState!.validate();

                                if (validated) {
                                  await authProvider
                                      .forgotPassword(
                                          emaicontroller.text.trim())
                                      .then((_) {
                                    _openBottomSheet(context);
                                    setState(() {
                                      _emailSended = true;
                                    });
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 15.0),
                                backgroundColor: Color(logoColor),
                                shape: const StadiumBorder(),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(backgroundColor),
                                      ),
                                    )
                                  : Text(
                                      "Request reset link",
                                      style: TextStyle(
                                          color: Color(backgroundColor),
                                          letterSpacing: .5,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
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
