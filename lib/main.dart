// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'jsonstore.dart';
import 'foodevent.dart';
import 'form.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<FoodEvent>> events;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    events = fetchFoodEvents();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      events = fetchFoodEvents();
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
          child: FutureBuilder<List<FoodEvent>>(
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

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: MyCustomForm(),
    );
  }
}