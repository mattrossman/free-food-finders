import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'jsonstore.dart';
import 'foodevent.dart';
import 'dart:developer';

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
                labelText: 'Start time:'
              ),
              validator: validateRequiredDatetime,
              onSaved: (val) => setState(() => _event.timestampFrom = val),
            ),
            BasicDateTimeField(
              decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                labelText: 'End time:'
              ),
              validator: validateRequiredDatetime,
              onSaved: (val) => setState(() => _event.timestampTo = val),
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Description:'
              ),
              validator: validateRequiredText,
              onSaved: (val) => setState(() => _event.description = val),
            ),
            EventTagField(
              onSaved: (val) => setState(() {
                _event.tags = val;
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: RaisedButton(
                onPressed: () {
                  final form = _formKey.currentState;
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (form.validate()) {
                    form.save();
                    postFoodEvent(_event);
                    Navigator.pop(context, 'Created Event ${_event.name}!');
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

class EventTagField extends FormField<List<String>> {

  static final List<EventTagEntry> _tagEntries = <EventTagEntry>[
    const EventTagEntry('Gluten Free', 'GF'),
    const EventTagEntry('Dairy Free', 'DF'),
    const EventTagEntry('Vegan', 'V'),
    const EventTagEntry('Vegetarian', 'VG'),
    const EventTagEntry('Halal', 'H'),
    const EventTagEntry('Kosher', 'K')
  ];

  EventTagField({
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
    bool autovalidate = false})
    : super(
        onSaved: onSaved,
        validator: validator,
        initialValue: new List<String>(),
        autovalidate: autovalidate,
        builder: (FormFieldState<List<String>> state) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: _tagEntries.map((tag) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilterChip(
                // avatar: CircleAvatar(child: Text(tag.id)),
                label: Text(tag.name),
                selected: state.value.contains(tag.id),
                onSelected: (bool value) {
                  state.setState(() {
                    if (value) {
                      state.value.add(tag.id);
                    } else {
                      state.value.removeWhere((String id) {
                        return id == tag.id;
                      });
                    }
                  });
                },
              ),
            );
          }).toList(),
        );
        }
    );
}