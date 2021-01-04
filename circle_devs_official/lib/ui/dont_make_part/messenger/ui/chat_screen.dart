import 'dart:io';

import 'package:circle_devs_official/ui/screens/login/slide_page.dart';
//import 'package:circle_devs_official/ui/messenger/models/chat_messager.dart';
//import 'package:circle_devs_official/ui/messenger/models/text_composer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = widget.user;
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        centerTitle: true,
        title: Text(
          'Chat App',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        leading: ListTile(
          title: ClipOval(child: Image.network(widget.user.photoURL)),
        ),
        actions: <Widget>[
          if (_currentUser != null)
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sign out correctly',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                );
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => null //LoginPage(),
                        ));
              },
            ),
        ],
      ),
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('folder')
                      .orderBy('Time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 4.0,
                            ),
                            Divider(),
                            Text(
                              'Loading ...',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            )
                          ],
                        );
                      default:
                        List<DocumentSnapshot> document =
                            snapshot.data.documents.reversed.toList();
                        return ListView.builder(
                            reverse: true,
                            itemCount: document.length,
                            itemBuilder: (context, index) {
                              return null; //ChatMessager(document[index].data(), _currentUser, true);
                            });
                    }
                  })),
          _isLoading ? LinearProgressIndicator() : Container(),
          //TextComposer(_sendMessage),
        ],
      ),
    );
  }

  // Catching the user , using google sign through firebase authentication

  // function that send message incluing img and msg to firebase

  void _sendMessage({String text, File imgFile}) async {
    Map<String, dynamic> data = {
      'uid': _currentUser.uid,
      'senderName': _currentUser.displayName,
      'senderPhotoUrl': _currentUser.photoURL,
      'Time': Timestamp.now()
    };

    if (_currentUser == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('were not possible to sign in . Please try again'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (imgFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(_currentUser.uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      TaskSnapshot snapshotTask = await uploadTask;
      String url = await snapshotTask.ref.getDownloadURL();
      data['images'] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if (text != null) data['message'] = text;

    FirebaseFirestore.instance.collection('folder').add(data);
  }

  void _removeMsg() {
    FirebaseFirestore.instance.collection('folder').doc().delete();
  }
}

/* 

document[index].data['images'] != null ? ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image(
                                  image: NetworkImage(_currentUser.photoUrl),
                                ),
                              ),
                            ),
                            title: Image.network(document[index].data['images']),
                            subtitle: Text(_currentUser.displayName,style: TextStyle(
                              fontSize: 13
                            )),
                          ) : // 
                          ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image(
                                  image: NetworkImage(_currentUser.photoUrl),
                                ),
                              ),
                            ),
                            title: Text(_currentUser.displayName,style: TextStyle(
                              fontSize: 13
                            ),),
                            subtitle: Text(document[index].data['message']),
                          ); //

*/
