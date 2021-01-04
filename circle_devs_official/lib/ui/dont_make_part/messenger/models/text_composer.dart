import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this._sendMessage);

  final Function({String text, File imgFile}) _sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _msgController = TextEditingController();
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () async {
              final File imgFile =
                await ImagePicker.pickImage(source: ImageSource.camera);
              if (imgFile == null) {
                return;
              } else {
                widget._sendMessage(imgFile: imgFile);
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _msgController,
              onChanged: (value) {
                setState(() {
                  _isActive = value.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                if (text != null && text.isNotEmpty) {
                  widget._sendMessage(text: text);
                  clearMsg();
                } else {
                  return null;
                }
              },
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _isActive
                  ? () {
                      widget._sendMessage(text: _msgController.text);
                      print(_msgController.text);
                      clearMsg();
                    }
                  : null),
        ],
      ),
    );
  }

  void clearMsg() {
    setState(() {
      _msgController.clear();
      _isActive = false;
    });
  }
}
