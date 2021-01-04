import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessager extends StatelessWidget {
  ChatMessager(this.data, this.currentUser, this.mine);

  final Map<String, dynamic> data;
  final User currentUser;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          !mine
              ? Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl']),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: data['images'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 250,
                              child: Image.network(
                                data['images'],
                              ),
                            ),
                            Text(data['senderName'],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: mine
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['senderName'],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                              textAlign: mine ? TextAlign.start : TextAlign.end,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              data['message'],
                              textAlign: mine ? TextAlign.end : TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          mine
              ? Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl']),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
