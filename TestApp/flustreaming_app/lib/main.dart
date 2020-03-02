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

// TODO Create databases for users
// TODO Think about left menu
// TODO Add asset logo
// TODO auto-login
// TODO Internal Player


class Photo{
  final int contentId;
  final String title;
  final String photoUrl;

  Photo({this.contentId, this.title, this.photoUrl});


  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      contentId: json['userId'] as int,
      title: json['title'] as String,
      photoUrl: json['thumbnailUrl'] as String,
    );
  }
}

const users = const{
  'test@gmail.com': '1234',
  'test@email.it': 'test',
};

User user;

class User{
  String name;
  IconData userIcon;

  User({this.name, this.userIcon});

  void userDetails(String name){
    this.name = name;
    this.userIcon = Icons.account_circle;
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming App',
      home: LoginPage(),
      routes: {
        "/login": (_) => new LoginPage(),
        "/homepage": (_) => new HomePage(),
        "/search": (_) => new SearchPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{


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

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){

            },
          ),
          centerTitle: true,
          title: Text('The Streaming App', style: TextStyle(fontSize: 28)),
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
            PhotosList(photos: snapshot.data) :
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


class UserPageRoute extends CupertinoPageRoute {
  UserPageRoute()
      : super(builder: (BuildContext context) => new UserPage());
}

List<Photo> parsePhotos(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('https://jsonplaceholder.typicode.com/photos');

  return compute(parsePhotos, response.body);
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: FadeInImage.assetNetwork(
                    placeholder: 'lib/assets/grey_placeholder.png',
                    image: photos[index].photoUrl)
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.white.withAlpha(0),
                      Colors.white30,
                      Colors.white54
                    ],
                  )
              ),
            ),
            Container(
                width: 200,
                height: 180,
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomCenter,
                child: Text(
                  photos[index].title.substring(0,10),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 25
                  ),
                )
            ),
            Container(
                width: 180,
                height: 180,
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.play_circle_outline, size: 50,),
                  color: Colors.white,
                  onPressed: (){
                    showDialog(
                        context: context,builder: (_) => NetworkGiffyDialog(
                      image: Image.network(photos[index].photoUrl),
                      title: Text(photos[index].title.substring(0,10),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30.0,
                              fontWeight: FontWeight.w600)),
                      description: Text(photos[index].title, textAlign: TextAlign.center),
                      entryAnimation: EntryAnimation.BOTTOM,
                      onOkButtonPressed: (){
                        launch("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4");
                      },
                    ));
                  },
                )
            ),
          ],
        );
      },
    );

  }
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
              user.userIcon,
              color: Colors.blue,
              size: 100
          ),
          Container(height: 50),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Center(child: Text(user.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 25

                  )))
          ),
          Container(height: 25),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Center(child: Text('lorem ipsum',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 25

                  )))
          ),
          Container(height: 25),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Center(child: Text('lorem ipsum',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 25

                  )))
          ),
          Container(height: 25),
          Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Center(child: Text('lorem ipsum',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 25

                  )))
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
              user.name = '';
              Navigator.popAndPushNamed(
                  context, "/login");
            },
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data){
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if(!users.containsKey(data.name)){
        return 'Username not exists';
      }
      if(users[data.name] != data.password){
        return 'Password does not match';
      }
      user = new User();
      user.userDetails(data.name);
      return null;
    });
  }
  Future<String> _recoverPassword(String name){
    print('Name: $name');
    return Future.delayed(loginTime).then((_){
      if(!users.containsKey(name)){
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context){
    return FlutterLogin(
      title: 'Streaming App',
      logo: 'lib/assets/grey_placeholder.png',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: (){
        Navigator.pushReplacementNamed(context,"/homepage");
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

class SearchPageRoute extends CupertinoPageRoute {
  SearchPageRoute(photos)
      : super(builder: (BuildContext context) => new SearchPage(photos: photos));
}

class SearchPage extends StatefulWidget{
  final List<Photo> photos;

  SearchPage({Key key, @required this.photos}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState(photos);
}

class SearchPageState extends State{
  List<Photo> photos;
  var items = List<Photo>();

  var _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      String route = '/homepage';
      if(_selectedIndex == 0) Navigator.pop(context);
    });

  }

  @override
  void initState(){
    items.addAll(photos);
    super.initState();
  }

  @override
  SearchPageState(this.photos);

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        actions: _buildActions(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).popAndPushNamed('/homepage');
          },
        ),
      ),
      body: PhotosList(photos: items),
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

  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search contents...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    if(_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if(_searchQueryController == null ||
            _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        )
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      )
    ];
  }

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery){
    setState(() {
      searchQuery = newQuery;
      searchQuery.isNotEmpty ? _isSearching = true : _isSearching = false;
      filterSearchQuery(newQuery);
    });
  }

  void filterSearchQuery(String newQuery){
    List<Photo> tmp = List<Photo>();
    tmp.addAll(photos);
    if(newQuery.isNotEmpty){
      List<Photo> tmpData = List<Photo>();
      tmp.forEach((item){
        if(item.title.startsWith(newQuery)){
          tmpData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(tmpData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(tmp);
      });
    }
  }

  void _stopSearching(){
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}


