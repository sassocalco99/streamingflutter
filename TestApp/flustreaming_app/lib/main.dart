import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'pages/menu.dart';
import 'pages/photo.dart';
import 'pages/user.dart';
import 'package:flustreamingapp/pages/search.dart';
import 'package:flustreamingapp/pages/login.dart';

// TODO auto-login
// TODO Internal Player


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming App',
      home: new LoginPage(),
      routes: {
        "/login": (_) => new LoginPage(),
        "/homepage": (_) => new HomePage(),
        "/menu": (_) => new MenuPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  int filterId = 0;
  List<Photo> photos;

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      String route = '/homepage';
      if(_selectedIndex == 1) Navigator.of(context).push(new SearchPageRoute(photos));
      _selectedIndex = 0;
    });

  }

  _displayAndWaitAnswer(BuildContext context) async{
    filterId = await Navigator.of(context).push(MenuRoute()) as int;
  }

  @override
  Widget build(BuildContext context){

    return new Scaffold(
      appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
              _displayAndWaitAnswer(context);
            },
          ),
          centerTitle: true,
          title: Text('Streaming App', style: TextStyle(fontSize: 30)),
          actions: <Widget>[IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(new UserPageRoute());
            },
          )]
      ),
      body: FutureBuilder<List<Photo>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            var hasData = snapshot.hasData;

            if(hasData) photos = snapshot.data;
            return (hasData) ?
            new PhotosList(photos: snapshot.data, filterId: filterId) :
            Center(child: CircularProgressIndicator());

          }
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search')
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
