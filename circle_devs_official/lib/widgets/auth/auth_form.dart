import 'dart:io';
import 'package:circle_devs_official/ui/screens/home/home_screen.dart';
import 'package:circle_devs_official/ui/screens/login/create_pass.dart';
import 'package:circle_devs_official/widgets/pickers/user_img_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submmitedFt, this.isLoading);
  final bool isLoading;
  final void Function(
    String name,
    String email,
    String password,
    File image,
    bool _isLogin,
    BuildContext ctx,
  ) submmitedFt;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  var _signWithGoogle = false;
  var _isGoogleLoading = false;
  var _userGooglepass = '';

  var _isLoading = false;
  var _isLogin = true;
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';

  File _userImgFile;

  void _pickImg(File img) {
    _userImgFile = img;
  }

  void _trySubmmited() {
    final _isValidated = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImgFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('can\'t sign up without upload a image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (_isValidated) {
      _formKey.currentState.save();
      widget.submmitedFt(
        _userName.trim(),
        _userEmail.trim(),
        _userPassword.trim(),
        _userImgFile,
        _isLogin,
        context,
      );
      print('name: $_userName, email: $_userEmail, password: $_userPassword');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage()
        ),
      );
    }
  }

  bool _isCorrectName = false;
  bool _isCorrectEmail = false;
  bool _isCorrectPassword = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: Colors.transparent,
          child: Container(
            height: !_isLogin ? 656 : 446,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  if (!_isLogin) UserImagePicker(_pickImg),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      key: ValueKey('email'),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      onEditingComplete: _trySubmmited,
                      validator: (value) {
                        if (value.isEmpty ||
                            !value.contains('@') && value.length < 10) {
                          return 'please enter a valid email adress';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'email',
                          icon: Icon(
                            _isCorrectEmail ? Icons.verified_user : Icons.email,
                            color: _isCorrectEmail
                                ? Colors.green[300]
                                : Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                  ),
                  Divider(),
                  if (!_isLogin)
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        key: ValueKey('name'),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.name,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        onEditingComplete: _trySubmmited,
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'name must be at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'name',
                            icon: Icon(
                              _isCorrectName
                                  ? Icons.verified_user
                                  : Icons.person,
                              color: _isCorrectName
                                  ? Colors.green[300]
                                  : Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      obscureText: true,
                      key: ValueKey('passowrd'),
                      style: TextStyle(color: Colors.white),
                      onEditingComplete: _trySubmmited,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 7) {
                          return 'the passowrd be at least 8 characteres';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'password',
                          icon: Icon(
                            _isCorrectPassword
                                ? Icons.verified_user
                                : Icons.privacy_tip,
                            color: _isCorrectPassword
                                ? Colors.green[300]
                                : Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                        child: Text(
                          _isLogin ? 'Sign in' : 'Sign up',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: _trySubmmited),
                  if (!widget.isLoading)
                    RaisedButton.icon(
                        label: Text(!_isLogin
                            ? 'Sign up with google'
                            : 'Sign in with google'),
                        icon: Icon(FontAwesomeIcons.google),
                        onPressed: () {
                          if (_userImgFile != null || !_isLogin == true) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => Pass()));
                          } else if (_isLoading) {
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3.0,
                            );
                          } else if (_isLoading == false) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => Pass()));
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Theme.of(context).errorColor,
                                  content: Text(
                                    'can\'t sign up with no image',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            );
                          }
                        }),
                  FlatButton(
                    child: Text(
                      _isLogin
                          ? 'Create a account ?'
                          : 'I already have an account !',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        print(_isLogin);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
