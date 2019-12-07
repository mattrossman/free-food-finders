// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart' as data;


void main() => runApp(MyApp());
bool pressAttention = false;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<data.FoodEvent>> events;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    events = data.fetchFoodEvents();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      events = data.fetchFoodEvents();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Food Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
        ),
        floatingActionButton: AddEventButton(),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: FutureBuilder<List<data.FoodEvent>>(
            future: events,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data.map((event) {
                    String date = DateFormat.MMMEd().format(event.timestamp);
                    String time = DateFormat.jm().format(event.timestamp);
                    return Card(
                      child: ListTile(
                        title: Text('${event.name}'),
                        subtitle: Text('$date at $time - ${event.location}')
                      )
                    );
                  }).toList()
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
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