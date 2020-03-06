import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';


String _usersdb = 'https://jsonplaceholder.typicode.com/users';


TextStyle _styleofUserPage = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
    fontSize: 25);

double _logosize = 35.0;


User user;

class User{
  String name;
  String email;
  String password;
  String city;
  String tel;


  User({this.name, this.email, this.password, this.city, this.tel});

  void userDetails(User user){
    this.name = user.name;
    this.email = user.email;
    this.password = user.password;
    this.city = user.city;
    this.tel = user.tel;
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['username'] as String,
      city: json['address']['city'] as String,
      tel: json['phone'] as String,
    );
  }
}


Future<List<User>> fetchUsers(http.Client client) async {
  final response = await client.get(_usersdb);

  return compute(parseUsers, response.body);
}

List<User> parseUsers(String responseBody) {
  final parsed =  json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}


class UserPageRoute extends CupertinoPageRoute {
  UserPageRoute()
      : super(builder: (BuildContext context) => new UserPage());
}

class UserPage extends StatefulWidget {

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage>{
  PageController _controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Icon(
              Icons.account_circle,
              color: Colors.blue,
              size: 100
          ),
          Divider(),
          Container(height: 25, child: Text("Name", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child:
                  Center(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(user.name,
                              style: _styleofUserPage
                          )
                      ))

          ),
          Divider(),
          Container(height: 25, child: Text("Email", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child:
                  Center(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(user.email,
                              style: _styleofUserPage
                          )
                      ))

          ),
          Divider(),
          Container(height: 25, child: Text("Phone", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child:
                  Center(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(user.tel,
                              style: _styleofUserPage
                          )
                      ))

          ),
          Divider(),
          Container(height: 25, child: Text("City", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child:
                  Center(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(user.city,
                            style: _styleofUserPage
                            )
                      )
                  )

          ),
          Container(height: 50),
          FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            splashColor: Colors.blueAccent,
            onPressed: (){
              user = null;
              Navigator.popAndPushNamed(
                  context, "/login");
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
              'Logout',
              style: TextStyle(fontSize: 25)
              ),
            ),
          )
        ],
      ),
    );
  }
}