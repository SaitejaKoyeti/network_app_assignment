import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Album> fetchAlbum() async {

  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if(response.statusCode==200){
    return Album.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('failed to load Album');
  }

}

class Album {

  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json){
    return Album(userId: json['userId'], id:json['id'], title:json['title']);

  }
}


class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  late Future<Album> futureAlbum;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum= fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fetch the data"),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {

              if(snapshot.hasData){

                return Column(
                  children: [
                    Text(snapshot.data!.userId.toString()),
                   Text(snapshot.data!.id.toString()),
                    Text(snapshot.data!.title),
                  ],
                );


              }else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}




