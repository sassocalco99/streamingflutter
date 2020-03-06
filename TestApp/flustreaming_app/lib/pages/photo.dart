import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

TextStyle _styleofHomePage = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
    fontSize: 25);

class Photo{
  final int contentId;
  final String title;
  final String photoUrl;

  Photo({this.contentId, this.title, this.photoUrl});


  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      contentId: json['id'] as int,
      title: json['title'] as String,
      photoUrl: json['thumbnailUrl'] as String,
    );
  }
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
  final int filterId;

  List<Photo>filteredList(){
    var tmp = new List<Photo>();

    if(filterId == 1){
      for(Photo photo in photos){
        if(photo.contentId % 2 == 0) tmp.add(photo);
      }
      return tmp;
    }else if(filterId == 2){
      for(Photo photo in photos){
        if(photo.contentId % 2 == 1) tmp.add(photo);
      }
      return tmp;
    }
    return null;
  }

  String title(){
    var output;
    if(filterId == 1){
      output = "Even view";
    }else if(filterId == 2){
      output = "Odds view";
    }else output = "Default view";
    return output;
  }

  PhotosList({Key key, this.photos, this.filterId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var photoToView = (filteredList() == null) ? photos : filteredList();

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            centerTitle: true,
            title: Text(title()),
            floating: true,
            leading: new Container(),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: FadeInImage.assetNetwork(
                              fadeInCurve: Curves.decelerate,
                              fadeInDuration: const Duration(seconds: 1),
                              placeholder: 'lib/assets/grey_placeholder.png',
                              image: photoToView[index].photoUrl)
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
                            photoToView[index].title.substring(0,10),
                            textAlign: TextAlign.center,
                            style: _styleofHomePage,
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
                                image: Image.network(photoToView[index].photoUrl),
                                title: Text(photoToView[index].title.substring(0,10),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30.0,
                                        fontWeight: FontWeight.w600)),
                                description: Text(photoToView[index].title, textAlign: TextAlign.center),
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
            childCount: photoToView.length,
          ),
        ),
      ],
    );
  }

}