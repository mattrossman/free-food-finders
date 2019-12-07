
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class FoodEvent {
  final String name;
  final String location;
  final DateTime timestamp;
  final String description;
  final List<String> tags;

  FoodEvent({this.name, this.location, this.timestamp, this.description, this.tags});

  factory FoodEvent.fromJson(Map<String, dynamic> json) {
    return FoodEvent(
      name: json['name'],
      location: json['location'],
      timestamp: new DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000),
      description: json['description'],
      tags: new List<String>.from(json['tags'])
    );
  }
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