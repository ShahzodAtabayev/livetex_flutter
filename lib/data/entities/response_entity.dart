import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class ResponseEntity extends BaseEntity {
  SentMessageBody? sentMessage;

  ResponseEntity({super.correlationId});

  factory ResponseEntity.fromJson(Map<String, dynamic> json) {
    return ResponseEntity(correlationId: json['correlationId'])
      ..sentMessage = json['sentMessage'] != null ? SentMessageBody.fromJson(json['sentMessage']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'correlationId': correlationId,
      'type': type.name,
      'sentMessage': sentMessage?.toJson(),
    };
  }

  @override
  ChatEventType get type => ChatEventType.result;
}

class SentMessageBody {
  DateTime? createdAt;
  String? id;

  SentMessageBody({
    required this.createdAt,
    required this.id,
  });

  factory SentMessageBody.fromJson(Map<String, dynamic> json) {
    return SentMessageBody(
      createdAt: DateTime.parse(json['createdAt']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'id': id,
    };
  }
}
