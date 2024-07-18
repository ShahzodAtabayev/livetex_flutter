import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/entities/file_message.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:livetex_flutter/data/entities/text_message.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class HistoryEntity extends BaseEntity {
  DateTime? createdAt;
  List<GenericMessage> messages;

  HistoryEntity({required this.createdAt, required this.messages, super.correlationId});

  factory HistoryEntity.fromJson(Map<String, dynamic> json) {
    var messageList = json['messages'] as List;
    List<GenericMessage> messages = messageList.map((i) => parseMessage(i)).toList();
    return HistoryEntity(
      messages: messages,
      correlationId: json['correlationId'],
      createdAt: DateTime.tryParse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'messages': messages
          .map((message) => (message is TextMessage)
              ? message.toMap()
              : (message is FileMessage)
                  ? message.toJson()
                  : null)
          .toList(),
      'correlationId': correlationId,
      'type': type,
    };
  }

  static GenericMessage parseMessage(Map<String, dynamic> json) {
    switch (json['type']) {
      case "text":
        return TextMessage.fromMap(json);
      case "file":
        return FileMessage.fromMap(json);
      default:
        return TextMessage.fromMap(json);
    }
  }

  @override
  ChatEventType get type => ChatEventType.update;
}
