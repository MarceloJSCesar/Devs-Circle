import 'dart:io';
import 'package:circle_devs_official/ui/screens/home/home_screen.dart';
import 'package:circle_devs_official/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User currentUser;
  bool _signWithGoogle = true;
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  void submmitedAuthForm(
    String name,
    String email,
    String password,
    File image,
    bool _isLogin,
    ctx,
  ) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
        _signWithGoogle = false;
      });
      if (_isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_authResult.user.uid + '.jpg');

        await ref.putFile(image).whenComplete(() {});

        final url = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(_authResult.user.uid)
            .set({
          'username': name,
          'email': email,
          'image_url': url,
          'time': Timestamp.now(),
          'signInWithGoogle': _signWithGoogle
        });
      }
    } on PlatformException catch (error) {
      var _message = 'An error accured , please check your credential';

      if (error.message != null) {
        _message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          content: Text(_message),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: AuthForm(submmitedAuthForm, _isLoading));
  }
}
