
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'foodevent.dart';


Future<List<FoodEvent>> fetchFoodEvents() async {
  final response =
    await http.get('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/events');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    List<dynamic> res = json.decode(response.body)['result'] ?? const[];
    return res.map((event) => FoodEvent.fromJson(event)).toList();
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load food events');
  }
}

Future<bool> postFoodEvent(FoodEvent event) async {
  log(jsonEncode(event));
  List<FoodEvent> events = await fetchFoodEvents();
  final response =
    await http.post('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/events/${events.length}',
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