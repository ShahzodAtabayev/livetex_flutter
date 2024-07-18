import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';

class AttributesEntity extends BaseEntity {
  String? name;
  String? phone;
  String? email;
  final Map<String, dynamic> attributes = {};

  AttributesEntity({this.name, this.phone, this.email, Map<String, dynamic>? attrs}) {
    if (attrs != null) {
      attributes.addAll(attrs);
    }
  }

  factory AttributesEntity.fromJson(Map<String, dynamic> json) {
    return AttributesEntity(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      attrs: json['attributes'] != null ? Map<String, Object>.from(json['attributes']) : null,
    )..correlationId = json['correlationId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'correlationId': correlationId,
      'type': type.name,
      'name': name,
      'phone': phone,
      'email': email,
      'attributes': attributes,
    };
  }

  @override
  ChatEventType get type => ChatEventType.attributes;
}
