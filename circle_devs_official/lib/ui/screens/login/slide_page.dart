import 'package:circle_devs_official/ui/screens/login/auth_screen.dart';
import 'package:flutter/material.dart';


class SlidePage extends StatefulWidget {
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // my key to get notify something
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // the main photo that i chose
              Image.asset(
                'assets/login/holding_phone.jpg',
                height: 180,
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                'Devs Circle',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              SizedBox(height: 20),
              Text(
                'A one-stop portal for you to connect with others developers',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 60,
              ),
              //LoginScreen
              MaterialButton(
                elevation: 0,
                height: 50,
                onPressed: () {
                  // this function will send you to login page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AuthPage()));
                },
                color: Color(0xff25bcbb),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Developed by Marcelo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
