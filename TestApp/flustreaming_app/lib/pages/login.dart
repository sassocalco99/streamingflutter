import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flustreamingapp/pages/user.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {

  List<User> users =  new List<User>();

  Future<void> matchUsers() async{
    List<User> tmp = await fetchUsers(http.Client());
    users.addAll(tmp);
  }

  int containsEmail(List<User> list, String email){
    for(int i = 0; i<list.length; i++){
      if(list[i].email == email) return i;
    }
    return -1;
  }


  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data){

    print('Email: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {


      int userIndex = containsEmail(users, data.name);
      if(userIndex < 0){
        return 'Username not exists';
      }
      if(users[userIndex].password != data.password){
        return 'Password does not match';
      }
      user = new User();
      user.userDetails(users[userIndex]);


      return null;

    });
  }
  Future<String> _recoverPassword(String name){
    print('Name: $name');
    return Future.delayed(loginTime).then((_){
      if(containsEmail(users, name) < 0){
        return 'Username not exists';
      }
      return null;
    });
  }


  @override
  Widget build(BuildContext context){

    matchUsers();
    return FlutterLogin(
      title: 'Streaming App',
      logo: 'lib/assets/logo200.png',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: (){
        Navigator.pushReplacementNamed(context,"/homepage");
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}