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