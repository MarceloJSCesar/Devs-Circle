import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:circle_devs_official/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final api =
    'https://newsapi.org/v2/everything?q=technology&apiKey=c67f55f7f5554a70a6048cd61c90d3a6';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'News',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.black,
            ),
            onPressed: null,
          ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _getApi(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Column();
            default:
              if (snapshot.hasError) {
                return Column();
              } else {
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  child: _news(context, snapshot),
                );
              }
          }
        },
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        backgroundColor: Colors.black,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
          if (currentIndex == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => HomePage()));
          } else if (currentIndex == 1) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => NewsPage()));
            Navigator.pop(context);
          }
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.pages),
            title: Text('News'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.settings,
            ),
            title: Text(
              'Settings',
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _news(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: snapshot.data['articles'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => null),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        snapshot.data['articles'][index]['urlToImage']))),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            /*
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['articles'][index]['urlToImage'],
                  fit: BoxFit.none,
                ),
              */
          ),
        );
      },
    );
  }

  Future<Map> _getApi() async {
    http.Response response = await http.get(api);
    return json.decode(response.body);
  }
}
