import 'package:livetex_flutter/data/entities/creator.dart';

class Employee implements Creator {
  String? name;
  String? position;
  String? avatarUrl;
  String? rating;

  Employee({
    required this.name,
    this.position,
    this.avatarUrl,
    this.rating,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      position: json['position'],
      avatarUrl: json['avatarUrl'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'avatarUrl': avatarUrl,
      'rating': rating,
    };
  }
}
