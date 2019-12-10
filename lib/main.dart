// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'jsonstore.dart';
import 'foodevent.dart';
import 'form.dart';
import 'dart:developer';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static _MyAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<FoodEvent>> _events;
  FoodEventFilter _filter;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Map<String, Color> tagColors = {
    'V': Colors.green,
    'DF': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _events = fetchFoodEvents();
    _filter = new FoodEventFilter();
  }

  void updateFilter(FoodEventFilter filter) {
    _filter = filter;
  }

  List<FoodEvent> applyFilter(List<FoodEvent> events) {
    List<FoodEvent> out = List<FoodEvent>.from(events);
    if (_filter.timestampFrom != null) {
      out = out.where((event) => event.timestampFrom.isAfter(_filter.timestampFrom)).toList();
    }
    if (_filter.timestampTo != null) {
      out = out.where((event) => event.timestampTo.isBefore(_filter.timestampTo)).toList();
    }
    if (_filter.tags.length > 0) {
      Set<String> filterSet = Set<String>.from(_filter.tags);
      Function(FoodEvent) matchesTags = (event) => Set<String>.from(event.tags).containsAll(filterSet);
      out = out.where(matchesTags).toList();
    }
    return out;
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      _events = fetchFoodEvents();
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

  Widget _buildListItem(BuildContext context, FoodEvent event) {
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
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ]
        ),
        // What will be seen upon expansion:
        children: <Widget>[
          ListTile(
            title: Text('Description'),
            subtitle: Text('${event.description}')
          ),
          ListTile(
            title: Text('Tags'),
            subtitle: Padding(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    child: Text('VG'),
                    radius: 16,
                  )
                ],
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10),
            )
          )
        ],
      ),
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
            future: _events,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GroupedListView(
                  elements: applyFilter(snapshot.data),
                  groupBy: (element) => DateFormat.EEEE().add_MMM().add_d().format(element.timestampFrom),
                  sort: false,
                  groupSeparatorBuilder: _buildGroupSeparator,
                  itemBuilder: _buildListItem,
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
      MyApp.of(context).updateFilter(result);
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