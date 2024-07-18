import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/entities/creator.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:livetex_flutter/data/entities/keyboard_entity.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class TextMessage extends BaseEntity implements GenericMessage {
  String id;
  String content;
  DateTime? createdAt;
  Creator creator;
  Map<String, String>? attributes;
  KeyboardEntity? keyboard;

  TextMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.creator,
    this.attributes,
    this.keyboard,
  });

  @override
  Creator getCreator() {
    return creator;
  }

  @override
  void setCreator(Creator creator) {
    this.creator = creator;
  }

  @override
  ChatEventType get type => ChatEventType.update;

  Map<String, dynamic> toMap() {
    return {'content': content, 'type': 'text', "correlationId": correlationId};
  }

  factory TextMessage.fromMap(Map<String, dynamic> map) {
    return TextMessage(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.tryParse(map['createdAt']),
      creator: Creator.fromJson(map['creator']),
      attributes: map['attributes'] as Map<String, String>?,
      keyboard: map['keyboard'] != null ? KeyboardEntity.fromJson(map['keyboard']) : null,
    );
  }

  @override
  DateTime? get createdTime => createdAt;
}
