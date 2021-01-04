import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:circle_devs_official/ui/screens/chat/chat_screen.dart';
import 'package:circle_devs_official/ui/screens/home/news_page.dart';
import 'package:circle_devs_official/ui/screens/home/perfil_screen.dart';
import 'package:circle_devs_official/ui/screens/login/auth_screen.dart';
import 'package:circle_devs_official/widgets/home/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final bool googleSinIn;
  HomePage({this.googleSinIn});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  int currentIndex = 0;
  UserCredential credential;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3.0,
            ),
          );
        } else if (snapshot.hasError) {
          return AuthPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                'Feed',
                style: TextStyle(fontSize: 17),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.facebookMessenger,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ChatScreen()));
                  },
                )
              ],
            ),
            drawer: Drawer(
              child: P()
            ),
            backgroundColor: Colors.black,
            body: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc()
                    .snapshots(),
                builder: (ctx, homeSnapshot) {
                  if (homeSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return AuthPage();
                  } else {
                    return Column(
                      children: <Widget>[],
                    );
                  }
                },
              ),
            ),
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: currentIndex,
              showElevation: true,
              backgroundColor: Colors.black,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (index) {
                setState(() => currentIndex = index);
                if (currentIndex == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => NewsPage()
                  ));
                }
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                  activeColor: Colors.white,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.pages),
                  title: Text('News'),
                  activeColor: Colors.white,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    'Profile',
                  ),
                  activeColor: Colors.white,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  title: Text(
                    'Settings',
                  ),
                  activeColor: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<User> _getData() async {
    return FirebaseAuth.instance.currentUser;
  }
}
