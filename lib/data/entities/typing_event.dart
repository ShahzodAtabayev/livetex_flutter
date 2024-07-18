import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class TypingEvent extends BaseEntity {
  String? content;

  TypingEvent({required this.content});

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    return TypingEvent(
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'correlationId': correlationId,
      'type': type.name,
    };
  }

  @override
  ChatEventType get type => ChatEventType.typing;
}
