import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new MenuPageState();
}

class MenuPageState extends State<MenuPage>{

  @override
  Widget build(BuildContext context){
    int filterId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu', style: TextStyle(fontSize: 30),),
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
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Container(height: 20),
          Center(
            child: Text("Select filter", style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),),
          ),
          Divider(height: 30,),
          FlatButton(
              child: Text(
                "Even",
                style: TextStyle(
                  fontSize: 20.0,
                ),),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),

              splashColor: Colors.blueAccent,
              onPressed: (){
                Navigator.pop(context, 1);
              },
          ),
          Container(height: 30,),
          FlatButton(
            child: Text(
              "Odds",
              style: TextStyle(
                fontSize: 20.0,
              ),),
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            splashColor: Colors.blueAccent,
            onPressed: (){
              Navigator.pop(context, 2);
            },
          ),
          Container(height: 30,),
          FlatButton(
            child: Text(
              "Default",
              style: TextStyle(
                fontSize: 20.0,
              ),),
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            splashColor: Colors.blueAccent,
            onPressed: (){
              Navigator.pop(context, 0);
            },
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