import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.username, this.userImg,
      {this.key});
  final String message;
  final bool isMe;
  final String username;
  final String userImg;
  final Key key;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                decoration: BoxDecoration(
                  color: isMe ? Colors.white : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.black, fontSize: 15),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      message,
                      textAlign: !isMe ? TextAlign.start : TextAlign.end,
                      style: TextStyle(
                          color: !isMe ? Colors.white : Colors.black, fontSize: 15),
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
          top: 0,
          left: !isMe ? 120 : null,
          right: !isMe? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImg),
          )
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
