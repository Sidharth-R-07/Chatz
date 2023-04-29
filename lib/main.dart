import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chatz/Auth/auth_service.dart';

import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:chatz/decoration.dart';
import 'package:chatz/screens/Auth_Screen/sign_in_screen.dart';
import 'package:chatz/screens/all_chats_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => DbFireStore(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Chatz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(backgroundColor),
            iconTheme: IconThemeData(color: Color(logoColor)),
            appBarTheme: AppBarTheme(
                backgroundColor: Color(backgroundColor), elevation: 0),
            fontFamily: 'roboto',
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: AnimatedSplashScreen(
            splash: SizedBox(
                height: 600,
                width: 400,
                child: Lottie.asset('Assets/lottie/chats splash.json',
                    fit: BoxFit.cover)),
            duration: 2000,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.black,
            nextScreen: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color(logoColor),
                  ));
                } else if (snapshot.hasData) {
                  return const AllChatScreen();
                } else {
                  return const SignInScreen();
                }
              },
            )),
      ),
    );
  }
}
