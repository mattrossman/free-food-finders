
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<User>> fetchUsers() async {
  final response =
      await http.get('https://www.jsonstore.io/959e4e7e2c37c98a703fab508a1c94cbc02f0c12d451d7d5e0131264f49fe476/users');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    List<dynamic> res = json.decode(response.body)['result'];
    return res.map((user) => User.fromJson(user)).toList();
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final String name;
  final int age;

  User({this.name, this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
    );
  }
}