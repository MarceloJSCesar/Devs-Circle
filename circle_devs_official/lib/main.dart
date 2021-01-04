import 'package:circle_devs_official/ui/screens/login/slide_page.dart';
import 'package:circle_devs_official/ui/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/screens/login/auth_screen.dart';
import 'ui/screens/login/slash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SlashPage();
            }
            if (userSnapshot.hasData) {
              return HomePage();
            }
            if (userSnapshot.connectionState == ConnectionState.none) {
              return AuthPage();
            }
            return SlidePage();
          }),
    );
  }
}
