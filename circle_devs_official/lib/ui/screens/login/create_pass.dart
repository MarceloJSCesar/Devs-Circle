import 'package:circle_devs_official/ui/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Pass extends StatefulWidget {
  @override
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  final _key = GlobalKey<FormState>();
  dynamic password;
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  User currentUser;
  bool _isLoading = false;

  void trySignInGoogle() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_right_alt,
              color: Colors.black,
            ),
            onPressed: null,
          )),
      backgroundColor: Colors.black,
      body: Form(
        key: _key,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create your password',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    onSaved: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please create your password';
                      } else if (value.length < 8) {
                        return 'password must have at least 8 characteres';
                      }
                    },
                    onFieldSubmitted: (value) {
                      if (_key.currentState.validate() &&
                          _controller.text.length > 7) {
                        signInWithGoogle(password, _isLoading);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomePage()),
                        );
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'password',
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton(
                  color: Colors.grey[300],
                  child: Text('Confirm'),
                  onPressed: () {
                    if (_key.currentState.validate() &&
                        _controller.text.length > 7) {
                      signInWithGoogle(password, _isLoading);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(dynamic password, bool _isLogin) async {
    UserCredential user;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user.uid)
        .set({
      'userId': user.user.uid,
      'username': user.user.displayName,
      'email': user.user.email,
      'time': Timestamp.now(),
      'image_url': user.user.photoURL
    });

    try {
      final GoogleSignInAccount signInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );
      final User authResult =
          (await _auth.signInWithCredential(credential)).user;

      if (authResult != null) {
        setState(() {
          currentUser = authResult;
        });
      }

      if (_isLogin) {
        user = await _auth.signInWithEmailAndPassword(
            email: authResult.email, password: password);
      } else {
        user = await _auth.createUserWithEmailAndPassword(
            email: authResult.email, password: password);
      }

     // return userData;
    } catch (error) {
      setState(() {
        _isLoading = true;
      });
      print(error);
    }
  }
}
