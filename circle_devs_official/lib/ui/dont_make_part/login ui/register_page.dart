import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User _currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isCorrectName = false;
  bool _isCorrectAge = false;
  bool _isCorrectEmail = false;
  bool _isCorrectPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign up to circle devs and continue',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 28),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your data below to continue to the devs circle and let the community begin!',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: textField(
                          context,
                          'name',
                          _nameController,
                          Icon(
                            _isCorrectName ? Icons.verified_user : Icons.person,
                            color: _isCorrectName ? logoGreen : Colors.white,
                          ), (onChanged) {
                        if (_nameController.text.length <= 1) {
                          setState(() {
                            _isCorrectName = false;
                          });
                        } else if (_nameController.text.isNotEmpty &&
                            _nameController.text != null) {
                          setState(() {
                            _isCorrectName = true;
                          });
                        }
                      }, (onSubmited) {}, TextInputType.name),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: textField(
                          context,
                          'age',
                          _ageController,
                          Icon(
                            _isCorrectAge ? Icons.verified_user : Icons.person,
                            color: _isCorrectAge ? logoGreen : Colors.white,
                          ), (onChanged) {
                        if (_ageController.text.length <= 1) {
                          setState(() {
                            _isCorrectAge = false;
                          });
                        } else if (_ageController.text.isNotEmpty &&
                            _ageController.text != null) {
                          setState(() {
                            _isCorrectAge = true;
                          });
                        }
                      }, (onSubmited) {}, TextInputType.number),
                    ),
                  ],
                ),
              ),
              Divider(),
              textField(
                  context,
                  'email',
                  _emailController,
                  Icon(
                    _isCorrectEmail ? Icons.verified_user : Icons.email,
                    color: _isCorrectEmail ? logoGreen : Colors.white,
                  ), (onChanged) {
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
              }, (onSubmited) {}, TextInputType.emailAddress),
              Divider(),
              textField(
                  context,
                  'password',
                  _passwordController,
                  Icon(
                    _isCorrectPassword
                        ? Icons.verified_user
                        : Icons.privacy_tip,
                    color: _isCorrectPassword ? logoGreen : Colors.white,
                  ), (onChanged) {
                if (_passwordController.text.length < 8) {
                  setState(() {
                    _isCorrectPassword = false;
                  });
                } else if (_passwordController.text.isNotEmpty &&
                    _passwordController.text != null) {
                  setState(() {
                    _isCorrectPassword = true;
                  });
                }
              }, (onSubmited) {}, TextInputType.visiblePassword),
              SizedBox(
                height: 30,
              ),
              Container(
                child: MaterialButton(
                  elevation: 0,
                  minWidth: double.infinity,
                  height: 50,
                  child: Text('Register'),
                  onPressed: () {
                    if (_isCorrectName == true &&
                        _isCorrectAge == true &&
                        _isCorrectEmail == true &&
                        _isCorrectPassword == true) {
                      _registerAccount();
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text('Error , try again'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  color: logoGreen,
                ),
              ),
              Divider(),
              Container(
                child: MaterialButton(
                  elevation: 0,
                  minWidth: double.infinity,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign up with ',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      )
                    ],
                  ),
                  onPressed: () async {
                    getUser();
                  },
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerAccount() async {
    final User user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text))
        .user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateProfile(displayName: _nameController.text);
      final user1 = firebaseAuth.currentUser;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return null;
      }));
    }
  }

  textField(
      BuildContext context,
      String hint,
      TextEditingController controller,
      Icon icon,
      Function functionOnChanges,
      Function functionOnSubmited,
      dynamic type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 60,
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        onChanged: functionOnChanges,
        onSubmitted: functionOnSubmited,
        keyboardType: type,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            icon: icon,
            border: InputBorder.none),
      ),
    );
  }

  Future<User> getUser() async {
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
    } catch (error) {
      return null;
    }
  }
}

/*

Future<FirebaseUser> getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser _user = authResult.user;
      
      return _user;
    } catch (error) {
      return null;
    }
  }


  if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final User user =
          (await firebaseAuth.signInWithCredential(credential)).user;
      setState(() {
        _currentUser = user;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return HomePage(
          user: _currentUser,
        );
      }));
      return user;
    } catch (error) {
      return null;
    }
  }

*/
