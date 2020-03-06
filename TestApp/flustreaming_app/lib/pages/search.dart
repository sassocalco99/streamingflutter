import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flustreamingapp/pages/photo.dart';

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
            Navigator.pop(context);
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


