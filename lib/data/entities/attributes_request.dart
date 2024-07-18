import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class AttributesRequest extends BaseEntity {
  AttributesRequest({super.correlationId});

  factory AttributesRequest.fromJson(Map<String, dynamic> json) {
    return AttributesRequest(correlationId: json['correlationId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'correlationId': correlationId,
      'type': type.name,
    };
  }

  @override
  ChatEventType get type => ChatEventType.attributesRequest;
}
