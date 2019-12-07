// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

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

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
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
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      )
    );
  }
  
}