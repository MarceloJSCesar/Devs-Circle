import 'package:flutter/material.dart';

class SlashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 3.0,
            ),
            Divider(),
            Text(
              'Loading ...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),
            )
          ],
        ),
      ),
    );
  }
}