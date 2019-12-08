class FoodEvent {
  String name;
  String location;
  DateTime timestampFrom;
  DateTime timestampTo;
  String description;
  List<String> tags;

  FoodEvent({this.name, this.location, this.timestampFrom, this.timestampTo, this.description, this.tags});

  factory FoodEvent.fromJson(Map<String, dynamic> json) {
    return FoodEvent(
      name: json['name'],
      location: json['location'],
      timestampFrom: new DateTime.fromMillisecondsSinceEpoch(json['timestampFrom'] * 1000),
      timestampTo: new DateTime.fromMillisecondsSinceEpoch(json['timestampTo'] * 1000),
      description: json['description'],
      tags: new List<String>.from(json['tags'] ?? const[])
    );
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'location' : location,
    'timestampFrom' : (timestampFrom.millisecondsSinceEpoch/1000).round(),
    'timestampTo' : (timestampTo.millisecondsSinceEpoch/1000).round(),
    'description' : description,
    'tags': tags
  };
}