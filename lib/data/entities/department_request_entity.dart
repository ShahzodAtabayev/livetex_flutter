import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/entities/department.dart';
import 'package:livetex_flutter/data/models/chat_event.dart';

class DepartmentRequestEntity extends BaseEntity {
  late List<Department> departments;

  DepartmentRequestEntity({required this.departments});

  factory DepartmentRequestEntity.fromJson(Map<String, dynamic> json) {
    return DepartmentRequestEntity(
      departments: (json['departments'] as List).map((deptJson) => Department.fromJson(deptJson)).toList(),
    )..correlationId = json['correlationId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'correlationId': correlationId,
      'type': type.name,
      'departments': departments.map((dept) => dept.toJson()).toList(),
    };
  }

  @override
  ChatEventType get type => ChatEventType.departmentRequest;
}
