import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getpostjson/posts.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Posts> posts = [];
  Future<List<Posts>> getPost() async {
    try {
      var response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List date = jsonDecode(response.body);
        for (var element in date) {
          posts.add(Posts.fromJson(element));
        }
        return posts;
      }
    } catch (e) {
      print(e);
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Get date"),
        titleSpacing: 2,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getPost(),
          builder: (Context, snapshort) {
            return snapshort.hasData
                ? ListView(
                    children: [
                      for (var itm in snapshort.data!)
                        ListTile(
                          // subtitle: Text(itm.userId.toString()),
                          title: Text(itm.title!),
                          leading: Text(itm.body!),
                        ),
                    ],
                  )
                : snapshort.hasError
                    ? Text("xogta la ma haaayo")
                    : Center(
                        child: CircularProgressIndicator(),
                      );
          }),
    );
  }
}
