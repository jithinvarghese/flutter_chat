import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Flutter Chat',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              backgroundColor: Colors.pink,
              accentColor: Colors.deepOrange,
              accentColorBrightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.deepOrangeAccent,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return ChatScreen();
                      }
                      return AuthScreen();
                    }),
          );
        });
  }
}
