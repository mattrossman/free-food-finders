// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:grouped_list/grouped_list.dart';
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

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Padding(
      child: Text(
        '$groupByValue',
        style: TextStyle(
          fontSize: 25
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 30, 10, 10),
    );
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
          actions: <Widget>[
            FilterButton()
          ],
        ),
        floatingActionButton: AddEventButton(),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: FutureBuilder<List<FoodEvent>>(
            future: events,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GroupedListView(
                  elements: snapshot.data,
                  groupBy: (element) => DateFormat.EEEE().add_MMM().add_d().format(element.timestampFrom),
                  sort: false,
                  groupSeparatorBuilder: _buildGroupSeparator,
                  itemBuilder: (context, event) {
                    String timeFrom = DateFormat.j().format(event.timestampFrom);
                    String timeTo = DateFormat.jm().format(event.timestampTo);
                    // String dateFrom = DateFormat.MMMEd().format(event.timestampFrom);
                    return Card(
                      child: ExpansionTile(
                        title: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Text('${event.name}'),
                                Spacer(),
                                Text('$timeFrom - $timeTo',
                                  style: TextStyle(fontSize: 14)
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            Row(
                              children: <Widget>[
                                Text('${event.location}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54
                                  )
                                ),
                                Spacer(),
                                Text('')
                              ],
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                          ]
                        ),
                        // What will be seen upon expansion:
                        children: <Widget>[
                          // Divider(),
                          ListTile(title: Text('${event.description}'),)
                          // Padding(
                          //   child: Text('${event.description}',
                          //     // textAlign: TextAlign.left
                          //   ),
                          //   padding: EdgeInsets.all(10)
                          // ),
                        ],
                        // trailing: SizedBox(width: 0, height: 0,),
                      ),
                    );
                  },
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

class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final FoodEventFilter result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterScreen()),
    );
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Applying tags: ${result.tags.toString()}")));
    }
  }
}

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: FilterForm(),
    );
  }
}