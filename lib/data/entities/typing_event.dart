import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

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
