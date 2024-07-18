import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class RatingEvent extends BaseEntity {
  String value;

  RatingEvent({
    required this.value,
    super.correlationId,
  });

  factory RatingEvent.fromJson(Map<String, dynamic> json) {
    return RatingEvent(
      value: json['value'],
      correlationId: json['correlationId'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['value'] = value;
    json['type'] = type.name;
    json['correlationId'] = correlationId;
    return json;
  }

  @override
  ChatEventType get type => ChatEventType.rating;
}
