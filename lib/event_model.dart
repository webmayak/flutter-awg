import 'dart:convert';

List<Event> postFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromMap(x)));

class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.place,
  });

  int id;
  String title;
  String description;
  String place;

  factory Event.fromMap(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        place: json["place"],
      );
}
