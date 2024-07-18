import 'package:livetex_flutter/data/models/file_uploaded_response.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';
import 'package:livetex_flutter/data/entities/creator.dart';
import 'package:livetex_flutter/data/entities/visitor.dart';
import 'package:flutter/material.dart';

class FileMessage extends BaseEntity implements GenericMessage {
  String id;
  String name;
  String url;
  DateTime? createdAt;
  Creator creator;

  FileMessage({
    required this.name,
    required this.url,
    required this.createdAt,
    required this.creator,
  }) : id = UniqueKey().toString();

  FileMessage.fromResponse(FileUploadedResponse response)
      : id = UniqueKey().toString(),
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
}