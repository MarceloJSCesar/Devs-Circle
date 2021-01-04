//import 'package:circle_devs_official/ui/login%20ui/register_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  bool _isCorrectEmail = false;
  bool _isCorrectPassword = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User _currentUser;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Sign in to circle devs and continue',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter your email and password below to continue to the devs circle and let the community begin!',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: 50,
                ),
                _buildTextField(
                    _emailController,
                    Icon(
                      _isCorrectEmail ? Icons.verified_user : Icons.email,
                      color: _isCorrectEmail ? logoGreen : Colors.white,
                    ),
                    'email', (onChanged) {
                  if (_emailController.text.length <= 16) {
                    setState(() {
                      _isCorrectEmail = false;
                    });
                  } else if (_emailController.text.isNotEmpty &&
                      _emailController.text != null) {
                    setState(() {
                      _isCorrectEmail = true;
                    });
                  }
                }, (onSubmmited) {}, TextInputType.emailAddress),
                SizedBox(height: 20),
                _buildTextField(
                    _passwordController,
                    Icon(
                      _isCorrectPassword
                          ? Icons.verified_user
                          : Icons.privacy_tip,
                      color: _isCorrectPassword ? logoGreen : Colors.white,
                    ),
                    'Password', (onChanged) {
                  if (_passwordController.text.length < 8) {
                    setState(() {
                      _isCorrectPassword = false;
                    });
                  } else if (_passwordController.text.isNotEmpty &&
                      _passwordController.text != null) {
                    setState(() {
                      _isCorrectPassword = true;
                      print(_passwordController.text);
                    });
                  }
                }, (onSubmmited) {}, TextInputType.visiblePassword),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Do you already have an account ?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => null //RegisterPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () async {
                    if (_isCorrectEmail == true && _isCorrectPassword == true) {
                      await signInWithEmail();
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(
                            'Error , try again',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  color: logoGreen,
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 20),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () async {
                    getUser();
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 10),
                      Text('Sign-in using Google',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> signInWithEmail() async {
    try {
      final User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return null;
        }),
      );
    } catch (error) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error to sign with email and password'),
        ),
      );
      print(error);
    }
  }

  Future<User> getUser() async {
    // this function

    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final User authResult =
          (await firebaseAuth.signInWithCredential(credential)).user;
      setState(() {
        _currentUser = authResult;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return null;
      }));
      return _currentUser;
    } // if user can't sign in , i'm going to notify you and will print the error to me
    catch (error) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error to sign with google'),
        ),
      );
      print(error);
    }
  }

  // this is a widget that calls _buildTextField to avoid to do it lots of times

  _buildTextField(TextEditingController controller, Icon icon, String hintText,
      Function functionOnChanged, Function functionOnSubmmited, dynamic type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        onChanged: functionOnChanged,
        onSubmitted: functionOnSubmmited,
        keyboardType: type,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            icon: icon,
            border: InputBorder.none),
      ),
    );
  }
}
