import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class ButtonPressedEvent extends BaseEntity {
  String payload;

  ButtonPressedEvent({
    required this.payload,
    super.correlationId,
    String? type,
  });

  factory ButtonPressedEvent.fromJson(Map<String, dynamic> json) {
    return ButtonPressedEvent(
      correlationId: json['correlationId'],
      type: json['type'],
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    // Override toJson method to include specific fields
    Map<String, dynamic> json = {};
    json['payload'] = payload;
    return json;
  }

  @override
  ChatEventType get type => ChatEventType.buttonPressed;
}
