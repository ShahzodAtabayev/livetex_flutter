import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class EmployeeTypingEvent extends BaseEntity {
  DateTime createdAt;

  EmployeeTypingEvent({
    required this.createdAt,
  });

  factory EmployeeTypingEvent.fromJson(Map<String, dynamic> json) {
    return EmployeeTypingEvent(
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'correlationId': correlationId,
      'type': type.name,
    };
  }

  @override
  ChatEventType get type => ChatEventType.employeeTyping;
}
