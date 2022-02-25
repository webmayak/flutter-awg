import 'dart:convert';

List<Order> postFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromMap(x)));

class Order {
  Order({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  int id;
  String title;
  String subtitle;
  String description;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    id: json["order_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
  );
}
