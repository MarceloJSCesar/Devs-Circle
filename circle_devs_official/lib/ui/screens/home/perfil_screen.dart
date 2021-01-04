import 'package:circle_devs_official/ui/screens/login/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class P extends StatefulWidget {
  @override
  _PState createState() => _PState();
}

class _PState extends State<P> {
  final f = FirebaseFirestore.instance.collection('users').doc();
  final userAuth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (ctx, snpashot) {
          if (!snpashot.hasData ||
              snpashot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 3.0,
              ),
            );
          } else if (snpashot.hasData) {
            final doc = snpashot.data.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (ctx, index) {
                if (index == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 3.0,
                    ),
                  );
                } else if (index != null) {
                  return Column(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        currentAccountPicture: doc[index]['image_url'] != null
                            ? GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    doc[index]['image_url'] != null
                                        ? doc[index]['image_url']
                                        : CircleAvatar(),
                                  ),
                                ),
                              )
                            : CircleAvatar(),
                        accountEmail: doc[index]['email'] != null
                            ? Text(doc[index]['email'])
                            : Text('errorEmail'),
                        accountName: doc[index]['username'] != null
                            ? Text(doc[index]['username'])
                            : Text('errorName'),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      ListTile(
                        title: Text(
                          'Light Mode',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          'Privacy',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.privacy_tip,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          'Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          'Acessibilities',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          'Support',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.support,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          'About',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.card_membership,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: RaisedButton(
                          child: Text('Sign out'),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => AuthPage()),
                            );
                          },
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  );
                } else {
                  return Text('error');
                }
              },
            );
          } else {
            return Text('error');
          }
        },
      ),
    );
  }

  Future getResponse() async {
    return userAuth;
  }
}
