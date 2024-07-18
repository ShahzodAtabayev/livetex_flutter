import 'package:livetex_flutter/data/models/file_uploaded_response.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';
import 'package:livetex_flutter/data/entities/creator.dart';
import 'package:livetex_flutter/data/entities/visitor.dart';
import 'package:flutter/material.dart';

class FileMessage extends BaseEntity implements GenericMessage {
  String _id;
  String name;
  String url;
  DateTime? createdAt;
  Creator creator;

  FileMessage({
    required String? id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.creator,
  }) : _id = id ?? UniqueKey().toString();

  FileMessage.fromResponse(FileUploadedResponse response)
      : _id = UniqueKey().toString(),
        name = response.name ?? '',
        url = response.url ?? '',
        createdAt = DateTime.now(),
        creator = Visitor();

  @override
  Creator getCreator() {
    return creator;
  }

  @override
  void setCreator(Creator creator) {
    this.creator = creator;
  }

  factory FileMessage.fromMap(Map<String, dynamic> json) {
    return FileMessage(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      createdAt: DateTime.tryParse(json['createdAt']),
      creator: Creator.fromJson(json['creator'] ?? {}), // This should be parsed based on actual type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
      'type': 'file',
      'correlationId': correlationId,
    };
  }

  @override
  ChatEventType get type => ChatEventType.update;

  @override
  DateTime? get createdTime => createdAt;

  @override
  String get id => _id;
}
