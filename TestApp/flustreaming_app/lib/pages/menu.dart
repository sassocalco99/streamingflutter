import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MenuPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new MenuPageState();
}

class MenuPageState extends State<MenuPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu'),
        leading: new Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          FlatButton(
            onPressed: (){},
            child: Text('Even'),
          ),
          FlatButton(
            onPressed: (){},
            child: Text('Odds'),
          )
        ],
      ),
    );
  }

}

Route MenuRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MenuPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}