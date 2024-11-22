import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Users.dart';

class Homeuser extends StatefulWidget {
  const Homeuser({super.key});

  @override
  State<Homeuser> createState() => _HomeuserState();
}

List<User> user = [];
Future<List<User>> getusers() async {
  try {
    var response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      List date = jsonDecode(response.body);
      for (var element in date) {
        user.add(User.fromJson(element));
      }
      return user;
    }
  } catch (e) {
    print(e);
  }

  return user;
}

class _HomeuserState extends State<Homeuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users information"),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getusers(),
          builder: (context, snap) {
            if (snap.hasData) {
              return ListView(
                children: [
                  for (var itm in snap.data!)
                    Container(
                      padding: EdgeInsets.all(22),
                      child: ListTile(
                        title: Text('ID: ${itm.id} , Name: ${itm.name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username: ${itm.username}',
                              style: TextStyle(color: Colors.cyan),
                            ),
                            Text('Email: ${itm.email}'),
                            Text('Phone: ${itm.phone}'),
                            Text('Website: ${itm.website}'),
                            Text(
                                'Address: ${itm.address?.street}, ${itm.address?.city}, ${itm.address?.zipcode}'),
                            Text('Company: ${itm.company?.name}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    )
                ],
              );
            } else if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
