import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class GetHistoryRequest extends BaseEntity {
  String messageId;
  int offset;

  GetHistoryRequest({
    required this.messageId,
    required this.offset,
    super.correlationId,
  });

  factory GetHistoryRequest.fromJson(Map<String, dynamic> json) {
    return GetHistoryRequest(
      correlationId: json['correlationId'],
      messageId: json['messageId'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messageId'] = messageId;
    json['correlationId'] = correlationId;
    json['offset'] = offset;
    return json;
  }

  @override
  ChatEventType get type => ChatEventType.getHistory;
}
