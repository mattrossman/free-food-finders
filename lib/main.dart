// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'database.dart';


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

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat.jm().add_MMMEd();
  final InputDecoration decoration;
  final FormFieldValidator validator;
  final Function(DateTime) onSaved;
  BasicDateTimeField({this.decoration, this.validator, this.onSaved});
  
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      format: format,
      decoration: this.decoration,
      validator: this.validator,
      onSaved: onSaved,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
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
  FoodEvent _event = new FoodEvent();
  final dateFormat = DateFormat("yyyy-MM-dd");

  String validateRequiredText(value) {
    if (value.isEmpty) {
      return '*Missing Required Information';
    }
    return null;
  } 

  String validateRequiredDatetime(value) {
    if (value == null) {
      return '*Missing Required Information';
    }
    return null;
  } 

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.star),
                labelText: 'Name:'
              ),
              validator: validateRequiredText,
              onSaved: (val) => setState(() => _event.name = val),
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.location_city),
                labelText: 'Location:'
              ),
              validator: validateRequiredText,
              onSaved: (val) => setState(() => _event.location = val),
            ),
            BasicDateTimeField(
              decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                labelText: 'Time:'
              ),
              validator: validateRequiredDatetime,
              onSaved: (val) => setState(() => _event.timestamp = val),
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Description:'
              ),
              validator: validateRequiredText,
              onSaved: (val) => setState(() => _event.description = val),
            ),
            EventTags(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: RaisedButton(
                onPressed: () {
                  final form = _formKey.currentState;
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (form.validate()) {
                    form.save();
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Created Event ${_event.name}!')));
                    postFoodEvent(_event);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventTagEntry {
  const EventTagEntry(this.name, this.id);
  final String name;
  final String id;
}

class EventTags extends StatefulWidget {
  @override
  State createState() => EventTagsState();
}

class EventTagsState extends State<EventTags> {
  final List<EventTagEntry> _tagEntries = <EventTagEntry>[
    const EventTagEntry('Gluten Free', 'GF'),
    const EventTagEntry('Vegan', 'V'),
    const EventTagEntry('Vegetarian', 'VG')
  ];
  List<String> _tags = <String>[];

  Iterable<Widget> get actorWidgets sync* {
    for (EventTagEntry tag in _tagEntries) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          // avatar: CircleAvatar(child: Text(tag.id)),
          label: Text(tag.name),
          selected: _tags.contains(tag.id),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _tags.add(tag.id);
              } else {
                _tags.removeWhere((String id) {
                  return id == tag.id;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: actorWidgets.toList(),
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