import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pckImg) pickImgFn;
  UserImagePicker(this.pickImgFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _imgPicked;

  void _pickImg() async {
    final pickedImgFile =
        await ImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 150,
      );

    setState(() {
      _imgPicked = pickedImgFile;
    });

    widget.pickImgFn(pickedImgFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _imgPicked != null ? FileImage(_imgPicked) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image,color: Colors.white,),
          label: Text('Image', style: TextStyle(color: Colors.white)),
          onPressed: _pickImg,
        ),
      ],
    );
  }
}
