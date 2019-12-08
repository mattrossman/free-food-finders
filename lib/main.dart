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
  static _MyAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

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
                    String timeFrom = DateFormat.jm().format(event.timestampFrom);
                    String timeTo = DateFormat.jm().format(event.timestampTo);
                    String dateFrom = DateFormat.MMMEd().format(event.timestampFrom);
                    return Card(
                      child: ListTile(
                        title: Text('${event.name}'),
                        subtitle: Text('$timeFrom-$timeTo $dateFrom at ${event.location}')
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
        _navigateAndDisplaySelection(context);
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result != null) {
      await MyApp.of(context).refreshList();
      Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
    }
  }
}

class AddEventScreen extends StatelessWidget {
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