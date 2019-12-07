// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response =
      await http.get('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/users');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    List<dynamic> res = json.decode(response.body)['result'];
    return res.map((user) => User.fromJson(user)).toList();
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final String name;
  final int age;

  User({this.name, this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
    );
  }
}


void main() => runApp(MyApp());
bool pressAttention = false;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: FutureBuilder<List<User>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: snapshot.data.map((user) => 
                    ListTile(
                      title: Text(user.name),
                      subtitle: Text('Age: ${user.age}'),
                    )
                  )
                ).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       home: RandomWords(),
//     );
//   }
// }

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Future<List<User>> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Food Events'),
      ),
      body: _getEvents(),
      floatingActionButton: AddEventButton()
    );
  }

  Widget _getEvents() {
    var _events = ListView(
      children: <Widget>[
        ListTile(
          title: Text('MONDAY')
        ),
        Card(
          child: ListTile(
          title: Text('Breakfast at Craigs Place'),
          subtitle: Text('Date: Nov 1  Time: 7AM'),
        ),
        ),

        Card(
          child: ListTile(
          title: Text('Community Breakfast at UUSA'),
          subtitle: Text('Date: Nov 1  Time: 8-10AM'),
        ),
        ),

        Card(
          child: ListTile(
          title: Text('Lunch - Amherst Senior Center'),
          subtitle: Text('Date: Nov 1  Time: 11:45AM - 12:15PM'),
        ),
        ),

        Card(
          child: ListTile(
          title: Text('Fresh Food Distribution - Amherst Survival Center'),
          subtitle: Text('Date: Nov 1  Time: 12:30PM - 7PM'),
        ),
        ),

        Card(
          child: ListTile(
          title: Text('Dinner at Craigs Place'),
          subtitle: Text('Date: Nov 1  Time: 7:30PM - 9PM'),
        )
        ),
        ListTile(
          title: Text('TUESDAY'),
        ),
        Card(
          child: ListTile(
            title: Text('Breakfast at Craigs Place'),
            subtitle: Text('Date: Nov 2  Time: 7AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Community Breakfast at UUSA'),
            subtitle: Text('Date: Nov 2  Time: 8-10AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Lunch - Amherst Senior Center'),
            subtitle: Text('Date: Nov 2  Time: 11:45AM - 12:15PM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Fresh Food Distribution - Amherst Survival Center'),
            subtitle: Text('Date: Nov 2  Time: 12:30PM - 7PM'),
          ),
        ),

        Card(
            child: ListTile(
              title: Text('Dinner at Craigs Place'),
              subtitle: Text('Date: Nov 2  Time: 7:30PM - 9PM'),
            )
        ),
        ListTile(
          title: Text('WEDNESDAY')
        ),
        Card(
          child: ListTile(
            title: Text('Breakfast at Craigs Place'),
            subtitle: Text('Date: Nov 3  Time: 7AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Community Breakfast at UUSA'),
            subtitle: Text('Date: Nov 3  Time: 8-10AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Lunch - Amherst Senior Center'),
            subtitle: Text('Date: Nov 3  Time: 11:45AM - 12:15PM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Fresh Food Distribution - Amherst Survival Center'),
            subtitle: Text('Date: Nov 3  Time: 12:30PM - 7PM'),
          ),
        ),

        Card(
            child: ListTile(
              title: Text('Dinner at Craigs Place'),
              subtitle: Text('Date: Nov 3  Time: 7:30PM - 9PM'),
            )
        ),
        ListTile(
          title: Text('THURSDAY'),
        ),
        Card(
          child: ListTile(
            title: Text('Breakfast at Craigs Place'),
            subtitle: Text('Date: Nov 4  Time: 7AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Community Breakfast at UUSA'),
            subtitle: Text('Date: Nov 4  Time: 8-10AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Lunch - Amherst Senior Center'),
            subtitle: Text('Date: Nov 4  Time: 11:45AM - 12:15PM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Fresh Food Distribution - Amherst Survival Center'),
            subtitle: Text('Date: Nov 4  Time: 12:30PM - 7PM'),
          ),
        ),

        Card(
            child: ListTile(
              title: Text('Dinner at Craigs Place'),
              subtitle: Text('Date: Nov 4  Time: 7:30PM - 9PM'),
            )
        ),
        ListTile(
          title: Text('FRIDAY'),
        ),
        Card(
          child: ListTile(
            title: Text('Breakfast at Craigs Place'),
            subtitle: Text('Date: Nov 5  Time: 7AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Community Breakfast at UUSA'),
            subtitle: Text('Date: Nov 5  Time: 8-10AM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Lunch - Amherst Senior Center'),
            subtitle: Text('Date: Nov 5  Time: 11:45AM - 12:15PM'),
          ),
        ),

        Card(
          child: ListTile(
            title: Text('Fresh Food Distribution - Amherst Survival Center'),
            subtitle: Text('Date: Nov 5  Time: 12:30PM - 7PM'),
          ),
        ),

        Card(
            child: ListTile(
              title: Text('Dinner at Craigs Place'),
              subtitle: Text('Date: Nov 5  Time: 7:30PM - 9PM'),
            )
        ),
      ],
    );
    return _events;
  }
}

class AddEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEvent()),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }
}
// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.star),
              labelText: 'Name:'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '*Missing Required Information';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.location_city),
              labelText: 'Location:'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '*Missing Required Information';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.event),
              labelText: 'Date:'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '*Missing Required Information';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.timer),
              labelText: 'Time:'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '*Missing Required Information';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.description),
              labelText: 'Description:'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '*Missing Required Information';
              }
              return null;
            },
          ),
          RaisedButton(
            child: new Text('Vegan'),
            textColor: Colors.black,
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
            ),
          color: pressAttention ? Colors.white : Colors.green,
          onPressed: () => setState(() => pressAttention = !pressAttention),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Created Event!')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: MyCustomForm(),
        ),
      )
    );
  }
  
}