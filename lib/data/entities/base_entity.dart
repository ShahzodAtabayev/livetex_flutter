import 'package:flutter/material.dart';
import 'package:livetex_flutter/data/entities/attributes_entity.dart';
import 'package:livetex_flutter/data/entities/attributes_request.dart';
import 'package:livetex_flutter/data/entities/department.dart';
import 'package:livetex_flutter/data/entities/department_request_entity.dart';
import 'package:livetex_flutter/data/entities/dialog_state.dart';
import 'package:livetex_flutter/data/entities/employee_typing_event.dart';
import 'package:livetex_flutter/data/entities/history_entity.dart';
import 'package:livetex_flutter/data/entities/response_entity.dart';
import 'package:livetex_flutter/data/entities/typing_event.dart';
import 'package:livetex_flutter/core/enums/chat_event_type.dart';
import 'package:uuid/uuid.dart';

abstract class BaseEntity {
  late final String correlationId;
  List<LiveTexError>? error;

  ChatEventType get type;

  BaseEntity({String? correlationId}) {
    this.correlationId = correlationId ?? const Uuid().v4();
  }

  factory BaseEntity.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'state':
        return DialogState.fromJson(json);
      case 'typing':
        return TypingEvent.fromJson(json);
      case 'department':
        return Department.fromJson(json);
      case 'result':
        return ResponseEntity.fromJson(json);
      case 'attributes':
        return AttributesEntity.fromJson(json);
      case 'attributesRequest':
        return AttributesRequest.fromJson(json);
      case 'departmentRequest':
        return DepartmentRequestEntity.fromJson(json);
      case 'update':
        return HistoryEntity.fromJson(json);
      case 'employeeTyping':
        return EmployeeTypingEvent.fromJson(json);
      default:
        debugPrint('Unknown model with type ${json['type']}');
        return UnknownEntity.fromJson(json);
    }
  }
}

class UnknownEntity extends BaseEntity {
  UnknownEntity({required super.correlationId});

  factory UnknownEntity.fromJson(Map<String, dynamic> json) {
    return UnknownEntity(correlationId: json['correlationId']);
  }

  @override
  ChatEventType get type => ChatEventType.unknown;
}

class LiveTexError {
  // Define fields and methods as necessary
  LiveTexError();

  factory LiveTexError.fromJson(Map<String, dynamic> json) {
    // Implement this based on the fields in the LiveTexError class
    return LiveTexError();
  }

  Map<String, dynamic> toJson() {
    // Implement this based on the fields in the LiveTexError class
    return {};
  }
}
