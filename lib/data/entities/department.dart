import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class Department extends BaseEntity implements Comparable<Department> {
  String? id;
  String? name;
  int? order;

  Department({
    required this.id,
    required this.name,
    required this.order,
  });

  @override
  int compareTo(Department other) {
    return (order ?? 0) - (other.order ?? 0);
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'correlationId': correlationId,
      'type': type.name,
    };
  }

  @override
  ChatEventType get type => ChatEventType.department;
}
