
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer';


class FoodEvent {
  String name;
  String location;
  DateTime timestamp;
  String description;
  List<String> tags;

  FoodEvent({this.name, this.location, this.timestamp, this.description, this.tags});

  factory FoodEvent.fromJson(Map<String, dynamic> json) {
    return FoodEvent(
      name: json['name'],
      location: json['location'],
      timestamp: new DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000),
      description: json['description'],
      tags: new List<String>.from(json['tags'] ?? const[])
    );
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'location' : location,
    'timestamp' : (timestamp.millisecondsSinceEpoch/1000).round(),
    'description' : description,
    'tags': tags
  };
}

Future<List<FoodEvent>> fetchFoodEvents() async {
  final response =
    await http.get('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/events');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    List<dynamic> res = json.decode(response.body)['result'];
    return res.map((event) => FoodEvent.fromJson(event)).toList();
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load food events');
  }
}

Future<bool> postFoodEvent(FoodEvent event) async {
  log(jsonEncode(event));
  final response =
    await http.post('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/events/0',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event)
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to post event');
  }
}