import 'package:circle_devs_official/ui/screens/login/auth_screen.dart';
import 'package:circle_devs_official/widgets/chat/messages.dart';
import 'package:circle_devs_official/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fm = FirebaseMessaging();
    fm.requestNotificationPermissions();
    fm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg1) {
        print(msg1);
        return;
      },
      onResume: (msg2) {
        print(msg2);
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'FlutterChat',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, 
                MaterialPageRoute(
                  builder: (_) => AuthPage()
                ),
                );
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
          child: Column(
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      )),
    );
  }
}
