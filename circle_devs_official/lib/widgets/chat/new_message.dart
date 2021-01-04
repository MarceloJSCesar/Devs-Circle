import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userGoogle = GoogleSignIn().currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImg': userData['image_url']
    });
    setState(() {
      _controller.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration.collapsed(
                  hintText: 'send a message ...',
                  hintStyle: TextStyle(color: Colors.white)),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            color: _controller.text.length <= 0  ? Colors.blue : Colors.grey,
            icon: Icon(Icons.send,
                color: _controller.text.length <= 0  ? Colors.grey : Colors.blue),
            onPressed: _controller.text.length > 0 ?_sendMessage : null,
          ),
        ],
      ),
    );
  }
}
